class AddIndexToUsersEmail < ActiveRecord::Migration[5.1]
  # Usersモデルのデータベースに、indexを追加し、:emailの一意性を検証するクラス
  def change
    # add_index:rails メソッドの一つ、:unique - trueを指定するとユニークなインデックス
    add_index :users, :email, unique: true  
  end
end
