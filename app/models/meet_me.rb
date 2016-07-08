class MeetMe < ApplicationRecord
  has_many :addresses
  accepts_nested_attributes_for :addresses
  # validates :addresses_must_be_valid

  def find_midpoint
    array = self.addresses.map do |address|
      address.name
    end
    Geocoder::Calculations.geographic_center(array)
  end

  def find_address(midpoint)
    ReverseLocation.create(latitude: midpoint[0], longitude: midpoint[1]).address
  end

  def find_params
    params = {}
    params[:term] = self.term
    params[:limit] = self.results
    params[:sort] = 2
    params
  end

  # def addresses_must_be_valid
  #   unless !self.find_midpoint.nan?
  #     self.errors.add(:addresses, "Addresses must be valid.")
  #   end
  # end

end
