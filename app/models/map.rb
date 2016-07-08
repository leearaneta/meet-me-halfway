require 'googlestaticmap'

class Map
  def self.map
    map = GoogleStaticMap.new(:zoom => 11, :center => MapLocation.new(:address => "Washington, DC"))
    image_url = map.url(:auto)
  end
end
