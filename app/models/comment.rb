class Comment < ApplicationRecord
  
  belongs_to :customer
  belongs_to :item
  
  def change
    create_table :comments do |t|
      t.integer :customer_id, null: false
      t.integer :item_id, null: false
      t.text :text, null: false
      t.timestamps
    end
  end
end
