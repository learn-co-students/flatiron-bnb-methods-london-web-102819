class Neighborhood < ActiveRecord::Base
  belongs_to :city
  has_many :listings


  def self.highest_ratio_res_to_listings
    max = 0
    result = nil

    self.all.each do |c|
      no_reservations = 0
      no_listings = c.listings.count

      c.listings.each do |l|
        no_reservations += l.reservations.count
      end

      ratio = no_reservations/no_listings.to_f

      if ratio > max
        max = ratio
        result = c
      end

    end
    result

  end

  def self.most_res
    max = 0
    result = nil

    self.all.each do |c|
      no_reservations = 0

      c.listings.each do |l|
        no_reservations += l.reservations.count
      end

      if no_reservations > max
        max = no_reservations
        result = c
      end

    end
    result

  end

  def neighborhood_openings(start, end_string)

    start_date = Date.parse(start)
    end_date = Date.parse(end_string)

    available_listings = []

    self.listings.each do |l|
      test = true
      l.reservations.each do |r|
          
          if !(r.checkin > end_date || r.checkout < start_date)
            test = false
            break
          end
          
      end
      available_listings << l if test
    end

    available_listings
  end

end
