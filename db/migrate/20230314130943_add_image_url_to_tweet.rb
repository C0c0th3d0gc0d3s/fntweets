class AddImageUrlToTweet < ActiveRecord::Migration[7.0]
  def change
    add_column :tweets, :image_url, :string
  end
end
