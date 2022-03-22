class AddTeacherNameToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :teacher_name, :string
  end
end
