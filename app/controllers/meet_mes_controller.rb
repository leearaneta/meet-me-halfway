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
    @meet_me.addresses.each do |address|
      address.meet_me = @meet_me
    end
    if @meet_me.find_midpoint[0].nan?
      @meet_me.errors.add(:addresses, "Please input valid addresses.")
      @meet_me.addresses = []
      amount.times { @meet_me.addresses.build }
      render :new
    else
      @meet_me.save
      redirect_to meet_me_path(@meet_me)
    end
  end

  def show
    midpoint = @meet_me.find_midpoint
    address = @meet_me.find_address(midpoint)
    params = @meet_me.find_params
    @term = params[:term]
    @yelp = yelp_query(address, params).businesses
    byebug
    if @yelp.count == 0
      @meet_me.errors.add(:term, "Sorry, there are no vendors in this category around this area!")
      render :new
      #this renders the 'meetmehalfway/:id' page
      #how do i get to the 'meetmehalfway/new' page?
    else
      @yelp.count == 1 ? @places = "Place" : @places = "Places"
      map = @meet_me.generate_map
      @yelp.each do |business|
        add = business.location.display_address.join(" ")
        map.markers << MapMarker.new(:color => "red", :location => MapLocation.new(:address => add))
      end
      @img_url = map.url
    end
  end

  private

    def yelp_query(address, params)
      Yelp.client.search(address, params)
    end

    def set_meet_me
      @meet_me = MeetMe.find(params[:id])
    end

    def meet_me_params
      params.require(:meet_me).permit(:term, :results, addresses_attributes: [:name])
    end

    def amount
      Carrier.last.quantity
    end
end
