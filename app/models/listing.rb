class Listing < ActiveRecord::Base
  belongs_to :neighborhood
  belongs_to :host, :class_name => "User"
  has_many :reservations
  has_many :reviews, :through => :reservations
  has_many :guests, :class_name => "User", :through => :reservations
  after_validation :change_host_status
  before_destroy :check_host_status


  validates :address, presence: true
  validates :listing_type, presence: true
  validates :title, presence: true
  validates :description, presence: true
  validates :price, presence: true
  validates :neighborhood, presence: true


  def average_review_rating
    review_sum = self.reviews.sum(:rating)
    reservation_count = self.reservations.count

    average = review_sum/reservation_count.to_f
  end

  private


  def change_host_status
    self.host.update(host: true) if self.host
  end

  def check_host_status
    self.host.update(host: false) if self.host.listings.count == 1
  end
  
end
