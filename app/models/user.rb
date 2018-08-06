class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

# 如果 User 已經有了評論，就不允許刪除帳號（刪除時拋出 Error）
  has_many :comments, dependent: :restrict_with_error
  has_many :restaurants, through: :comments

# 「使用者收藏很多餐廳」的多對多關聯
  has_many :favorites, dependent: :destroy
  has_many :favorited_restaurants, through: :favorites, source: :restaurant

# 「使用者喜歡很多餐廳」的多對多關聯
  has_many :likes, dependent: :destroy
  has_many :liked_restaurants, through: :likes, source: :restaurant

  has_many :followships, dependent: :destroy
  has_many :followings, through: :followships

  has_many :inverse_followships, class_name: "Followship", foreign_key: "following_id"
  has_many :followers, through: :inverse_followships, source: :user

  has_many :friendships, dependent: :destroy
  has_many :confirmed_friendships, -> { where confirmed: true}, primary_key: "id", foreign_key: "user_id", class_name: "Friendship", dependent: :destroy
  has_many :friends, through: :friendships
  has_many :confirmed_friends, through: :confirmed_friendships, source: :friend
  
  has_many :inverse_friendships, class_name: "Friendship", foreign_key: "friend_id"
  has_many :confirmed_inverse_friendships, -> { where confirmed: true}, primary_key: "id", foreign_key: "friend_id", class_name: "Friendship", dependent: :destroy
  has_many :inverse_friends, through: :inverse_friendships, source: :user
  has_many :confirmed_inverse_friends, through: :confirmed_inverse_friendships, source: :user


  validates_presence_of :name
  mount_uploader :avatar, AvatarUploader

  def admin?
    self.role == "admin"
  end

  def following?(user)
    self.followings.include?(user)
  end

  def friend?(user)
    self.friends.include?(user)
  end

  def inverse_friend?(user)
    self.inverse_friends.include?(user)
  end

  def confirmed?(user)
    self.friendships.where(friend_id: user.id).first.confirmed 
  end

  def all_friends
    # confirmed_friendships = self.friendships.where(confirmed: true)
    # confirmed_inverse_friendships = self.inverse_friendships.where(confirmed: true)
    # friend_list = Array.new
    # if confirmed_friendships.count > 0
    #   confirmed_friend_list = Array.new
    #   confirmed_friendships.each do |friend|
    #     confirmed_friend_list = confirmed_friend_list + self.friends.where(id: friend.friend_id) 
    #   end
    #   friend_list = friend_list + confirmed_friend_list
    # end
    # puts "confirmed_friend_list = #{confirmed_friend_list}"
    
    # if confirmed_inverse_friendships.count > 0
    #   confirmed_inverse_friend_list = Array.new
    #   confirmed_inverse_friendships.each do |friend|
    #     confirmed_inverse_friend_list  = confirmed_inverse_friend_list  + self.inverse_friends.where(id: friend.user_id) 
    #   end
    #   friend_list = friend_list + confirmed_inverse_friend_list
    # end
    # puts "confirmed_inverse_friend_list = #{confirmed_inverse_friend_list }"
    friend_list = self.confirmed_friends + self.confirmed_inverse_friends
    return friend_list
  end
end
