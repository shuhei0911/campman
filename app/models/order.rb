class Order < ApplicationRecord
  belongs_to :customer
  has_many :order_details
  has_many :items, through: :order_details

  validates :postal_code, presence: true, format: { with: /\A\d{7}\z/ }
  validates :destination, presence: true
  validates :name, presence: true
  validates :shipping_cost, presence: true, :numericality => { :greater_than_or_equal_to => 0 }
  validates :grand_total, presence: true, :numericality => { :greater_than_or_equal_to => 0 }

  #scope :ordered_today, -> { where(created_at: Constants::BEGINNING_OF_TODAY...Constants::BEGINNING_OF_TOMORROW) }

  enum order_status: { 入金待ち: 0, 入金完了: 1, 発送前: 2, 発送済み: 3 }
  enum payment: { クレジットカード: 0, 銀行振込: 1 }

  def get_shipping_informations_from(resource)
    class_name = resource.class.name
    if class_name == 'Customer' # resource: Customer
      self.postal_code = resource.postal_code
      self.destination = resource.address
      self.name = resource.full_name
    elsif class_name == 'Address' # resource: Address
      self.postal_code = resource.postal_code
      self.destination = resource.destination
      self.name = resource.name
    end
  end

  def create_order_details(customer)
    unless order_details.first
      cart_items = customer.cart_items.includes(:item)
      cart_items.each do |cart_item|
        item = cart_item.item
        OrderDetail.create!(
          order_id: id,
          item_id: item.id,
          price: item.with_tax_price,
          amount: cart_item.amount
        )
      end
      cart_items.destroy_all
    end
  end

  def are_all_details_completed?
    (order_details.completed.count == order_details.count) ? true : false
  end
end
