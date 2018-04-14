class CreateInterimResults < ActiveRecord::Migration[5.0]
  def change
    create_table :interim_results do |t|
      t.float :anger
      t.float :contempt
      t.float :disgust
      t.float :fear
      t.float :happiness
      t.float :neutral
      t.float :sadness
      t.float :surprise
      t.integer :user_id, foreign_key: true
    end
  end
end
