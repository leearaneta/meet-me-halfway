class MeetMesController < ApplicationController
  before_action :set_meet_me, only: [:show, :edit, :update, :destroy]

  def start
  end

  def pass
    @carrier = Carrier.create(params.permit(:quantity))
    redirect_to new_meet_me_path(@carrier)
  end

  def new
    byebug
    amount = Carrier.find(params[:id]).quantity
    @meet_me = MeetMe.new
    amount.times { @meet_me.addresses.build }
  end

  def create
    byebug
    @meet_me = MeetMe.new(meet_me_params)
    @meet_me.addresses_attributes= meet_me_params[:addresses_attributes]
    @meet_me.addresses.each do |address|
      address.meet_me = @meet_me
    end
    @meet_me.save
    render meet_me_path(@meet_me) #redirect_to
  end

  def show
    midpoint = @meet_me.find_midpoint
    if midpoint[0].nan?
      @warning = 'Please input valid addresses.'
      redirect_to new_meet_me_path(@meet_me)
    else
      address = @meet_me.find_address(midpoint)
      params = @meet_me.find_params
      @term = params[:term]
      @yelp = yelp_query(address, params).businesses
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
end
