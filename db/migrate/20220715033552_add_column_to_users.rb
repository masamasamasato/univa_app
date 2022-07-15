class AddColumnToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column  :users,  :confirmation_token,  :string  #一意のランダムトークン。この値を使って認証を行う
    add_column  :users,  :confirmed_at,        :datetime  #ユーザーが確認リンクをクリックしたときのタイムスタンプ
    add_column  :users,  :confirmation_sent_at,:datetime  #confirmation_tokenが生成されたときのタイムスタンプ
    add_column  :users,  :unconfirmed_email,   :string  #変更後メールアドレスを認証完了まで一時的に保持。確認リンクが押された時点でemailが上書きされ、このカラムは空に（メールアドレス変更時のみ使用）
  end
end
