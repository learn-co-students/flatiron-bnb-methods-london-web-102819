class Reservation < ActiveRecord::Base
  belongs_to :listing
  belongs_to :guest, :class_name => "User"
  has_one :review

  validates :checkin, presence: true
  validates :checkout, presence: true
  validate :checkin_checkout
  validate :available
  validate :checkout


  def checkin_checkout

    if (self.checkin && self.checkout && self.checkin >= self.checkout) || (self.status == "pending")
      errors.add(:dates, "start date must be strictly before end date")
    end

  end

  def available
    l = self.listing

    l.reservations.each do |r|

      if self.checkin && self.checkout && !(self.checkin > r.checkout || self.checkout <  r.checkout)
        errors.add(:dates, "there is already a reservation for the given dates")
      end

    end

  end

  def duration
    (self.checkout - self.checkin).to_i
  end

  def total_price
    self.duration*self.listing.price
  end


end
