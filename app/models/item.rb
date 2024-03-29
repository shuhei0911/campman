class Item < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :order_details
  has_one_attached :image

  belongs_to :customer, optional: true
  has_many :comments, dependent: :destroy
  has_many :favorites, dependent: :destroy

  validates :name, presence: true
  validates :introduction, presence: true
  validates :price, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validate :image_type

  scope :where_item_active, -> { joins(:item).where(items: { is_active: true }) }

   def favorited_by?(customer)
      favorites.exists?(customer_id: customer.id)
   end

  def get_image(*size)
    unless image.attached?
      file_path = Rails.root.join('app/assets/images/no-image.png')
      image.attach(io: File.open(file_path), filename: 'no-image.png', content_type: 'image/png')
    end

    if !size.empty?
      image.variant(resize: size)
    else
      image
    end
  end

  def with_tax_price
    (price * 1.1).ceil
    # ceilは切り上げ、floorが切り捨て、roundが四捨五入
  end

  def self.recommended
    recommends = []
    #active_items = Item.only_active.includes(:items)
    #active_items.each do |item|
      #item = items.last
      #recommends << item if item
    #end
    recommends
  end


  private

  def image_type
    if !image.blob
      errors.add(:image, 'をアップロードしてください')
    elsif !image.blob.content_type.in?(%('image/jpeg image/png'))
      errors.add(:image, 'はJPEGまたはPNG形式を選択してアップロードしてください')
    end
  end
end