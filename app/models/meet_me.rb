class MeetMe < ApplicationRecord
  has_many :addresses
  accepts_nested_attributes_for :addresses

  def find_midpoint
    array = self.addresses.map do |address|
      address.name
    end
    Geocoder::Calculations.geographic_center(array)
  end

  def find_address
    midpoint = self.find_midpoint
    ReverseLocation.create(latitude: midpoint[0], longitude: midpoint[1]).address
  end

  def find_params
    params = {term: self.term, limit: self.results, sort: 2}
  end

  def associate_addresses
    self.addresses.each { |address| address.meet_me = self }
  end

  def yelp_query
    address = self.find_address
    params = self.find_params
    begin
      Yelp.client.search(address, params).businesses
    rescue
      self.addresses = []
    end
  end

  def find_error
    self.yelp_query
    if self.addresses.empty?
      return "you'll probably end up in the ocean"
    elsif self.yelp_query.count == 0
      return "There are no vendors of this category in your area."
    elsif self.find_midpoint[0].nan?
      return "Please enter valid addresses."
    end
  end

  def reset
    error = self.find_error
    self.errors.add(:addresses, error)
    self.addresses = []
    Carrier.last.quantity.times { self.addresses.build }
  end

  def generate_map
    map = GoogleStaticMap.new(:api_key => "AIzaSyDEsYgk8H0XMACDf4Wk4SxW4P05UQkZmXY")
    self.addresses.each do |add|
      map.markers << MapMarker.new(:color => "purple", :location => MapLocation.new(:address => add.name))
    end
    map
  end


end
