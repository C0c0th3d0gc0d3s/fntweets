class CreateTweets < ActiveRecord::Migration[7.0]
  def change
    create_table :tweets do |t|
      t.string :external_id
      t.string :text
      t.string :author_name
      t.string :author_avatar_url
      t.string :video
      t.string :posting_date

      t.timestamps
    end
  end
end
