class Review < ActiveRecord::Base
  belongs_to :reservation
  belongs_to :guest, :class_name => "User"

  validates :rating, presence: true
  validates :description, presence: true
  validate :reservation_check

  def reservation_check
    
    if !self.reservation || !self.reservation.checkout || self.reservation.status != "accepted" || self.reservation.checkout >= Date.today
      errors.add(:fobidden, "you cannot write reviews for places you have not stayed")
    end

  end

end
