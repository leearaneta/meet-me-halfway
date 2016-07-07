class MeetMe < ApplicationRecord


  def find_midpoint
    array = [self.address_1, self.address_2]
    Geocoder::Calculations.geographic_center(array)
  end
  def find_address(midpoint)
    ReverseLocation.create(latitude: midpoint[0], longitude: midpoint[1]).address
  end
  def find_params
    params = {}
    params[:term] = self.term
    params[:limit] = self.results
    params
  end
end
