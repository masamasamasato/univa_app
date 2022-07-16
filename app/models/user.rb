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
  has_many :followings, through: :relationships, source: :follow #フォローされる人全員を中間テーブルを通じて取ってくる
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: :follow_id #どの人からフォローされているのかの中間テーブル
  has_many :followers, through: :reverse_of_relationships, source: :user


  validates :name, presence: true 
  validates :profile, length: { maximum: 200 } 

  def already_liked?(post)  #いいねしているかの判定
    self.likes.exists?(post_id: post.id)
  end

  def follow(other_user)  #other_userのフォローをする
    unless self == other_user #フォローしようとしているother_user自身が自分自身でないかを確認
      self.relationships.find_or_create_by(follow_id: other_user.id)  #follow_idはother_user_idのrelationshipを新規作成して保存する
    end
  end

  def unfollow(other_user)  #other_userのフォローを外す
    relationship = self.relationships.find_by(follow_id: other_user.id) #other_userのrelationshipを取ってくる
    relationship.destroy if relationship  #relationshipが存在すればそれをdestroyする
  end

  def following?(other_user)  #other_userをフォローしているかの判定を行う。
    self.followings.include?(other_user)  #self.followingsで自分自身がfollowしている人全員を取ってきてother_userがそこに含まれているかを調べる
  end

end
