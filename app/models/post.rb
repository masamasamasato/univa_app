class Post < ApplicationRecord
    belongs_to :user
    mount_uploader :image, ImageUploader
    has_many :favorites
    has_many :comments, dependent: :destroy
    has_many :likes, dependent: :destroy    #中間テーブル
    has_many :liked_users, through: :likes, source: :user #いいねしてきたユーザー
    #has_many :メソッド名, through: :中間テーブル名(複数系), source: :相手のテーブル名(単数系)

    def favorited_by?(user)
        favorites.where(user_id: user.id).exists?
    end
end
