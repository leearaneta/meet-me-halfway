class MeetMe < ApplicationRecord
  has_many :addresses
  accepts_nested_attributes_for :addresses

  def find_midpoint
    array = self.addresses.map do |address|
      address.name
    end
    Geocoder::Calculations.geographic_center(array)
    #Geocoder takes in multiple addresses and calculates the midpoint in lat long
  end

  def find_address
    midpoint = self.find_midpoint
    ReverseLocation.create(latitude: midpoint[0], longitude: midpoint[1]).address
    #Reverse geocoder takes in the midpoint's coordinates and calculates the actual address
  end

  def find_params
    params = {term: self.term, limit: self.results, sort: 2}
    #returns the attributes of the meet_me object
  end

  def associate_addresses
    self.addresses.each { |address| address.meet_me = self }
    #make address belong to meet_me
  end

  def yelp_query
    address = self.find_address
    params = self.find_params
    begin
      Yelp.client.search(address, params).businesses
    rescue
      self.addresses = []
      #exceptions
    end
  end

  def find_error
    self.yelp_query
    if self.addresses.empty?
      return "you'll probably end up in the ocean"
      #when midpoint doesnt have a valid address
    elsif self.yelp_query.count == 0
      return "There are no vendors of this category in your area."
      #valid midpoint, but no vendors nearby
    elsif self.find_midpoint[0].nan?
      return "Please enter valid addresses."
      #addresses are not in the correct format
    end
  end

  def reset
    error = self.find_error
    self.errors.add(:addresses, error)
    self.addresses = []
    Carrier.last.quantity.times { self.addresses.build }
  end

  def generate_map
    map = GoogleStaticMap.new(:api_key => "AIzaSyCc4G3qvx_jiAqH-pJrPq_o7Dmma2Q14Ic")
    self.addresses.each do |add|
      map.markers << MapMarker.new(:color => "purple", :location => MapLocation.new(:address => add.name))
    end
    map
  end


end
