class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
        :recoverable, :rememberable, :validatable
  
  mount_uploader :image, ImageUploader

  has_many :posts, dependent: :destroy
  has_many :likes, dependent: :destroy  #どの投稿にいいねをしているのか 中間テーブル
  has_many :liked_posts, through: :likes, source: :post #userがどの投稿をいいねしているのかを簡単に取得できる
  #has_many :メソッド名, through: :中間テーブル名(複数系), source: :相手のテーブル名(単数系)

  has_many :favorites #中間テーブル
  has_many :favorite_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy #どの投稿にコメントをしているのか 中間テーブル
  has_many :relationships #どの人をフォローしているのかの中間テーブル
  has_many :followings, through: :relationships, source: :follow #userがどの人をフォローしているのか
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'follow_id'#どの人からフォローされているのかの中間テーブル
  has_many :followers, through: :reverse_of_relationships, source: :user


  validates :name, presence: true 
  validates :profile, length: { maximum: 200 } 

  def already_liked?(post)
    self.likes.exists?(post_id: post.id)
  end

  def follow(other_user)
    unless self == other_user
      self.relationships.find_or_create_by(follow_id: other_user.id)
    end
  end

  def unfollow(other_user)
    relationship = self.relationships.find_by(follow_id: other_user.id)
    relationship.destroy if relationship
  end

  def following?(other_user)
    self.followings.include?(other_user)
  end

end
