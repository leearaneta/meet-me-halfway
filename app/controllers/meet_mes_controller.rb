require 'googlestaticmap'

class MeetMesController < ApplicationController
  before_action :set_meet_me, only: [:show, :edit, :update, :destroy]

  def start
  end

  def pass
    @carrier = Carrier.create(params.permit(:quantity))
    redirect_to new_meet_me_path
  end

  def new
    @meet_me = MeetMe.new
    amount.times { @meet_me.addresses.build }
  end

  def create
    @meet_me = MeetMe.new(meet_me_params)
    @meet_me.associate_addresses
    if @meet_me.find_error
      @meet_me.reset
      render :new
    else
      @meet_me.save
      redirect_to meet_me_path(@meet_me)
    end
  end

  def show
    @yelp = @meet_me.yelp_query
    @yelp.count == 1 ? @places = "Place" : @places = "Places"
    map = @meet_me.generate_map
    add_yelp_markers_to_map(@yelp, map)
    @img_url = map.url
    byebug
  end

  private

    def set_meet_me
      @meet_me = MeetMe.find(params[:id])
    end

    def meet_me_params
      params.require(:meet_me).permit(:term, :results, addresses_attributes: [:name])
    end

    def add_yelp_markers_to_map(yelp, map)
      yelp.each do |business|
        add = business.location.display_address.join(" ")
        map.markers << MapMarker.new(:color => "red", :location => MapLocation.new(:address => add))
      end
    end

    def amount
      Carrier.last.quantity
    end

end
