class MeetMesController < ApplicationController
  before_action :set_meet_me, only: [:show, :edit, :update, :destroy]

  def index
    @meet_mes = MeetMe.all
  end

  def start
    @meet_me = MeetMe.new
  end

  def pass
    @meet_me = MeetMe.create(params.permit(:people))
    redirect_to new_meet_me_path(@meet_me)
  end

  def show
    midpoint = @meet_me.find_midpoint
    if midpoint[0].nan?
      @warning = 'Please input valid addressses.'
      redirect_to new_meet_me_path
    else
      address = @meet_me.find_address(midpoint)
      params = @meet_me.find_params
      @term = params[:term]
      @yelp = yelp_query(address, params).businesses
    end
  end

  def new
    byebug
    meet_me_proxy = MeetMe.find(params[:id])
    amount = meet_me_proxy.people
    @meet_me = MeetMe.new
    amount.times { @meet_me.addresses.build }
  end

  def edit
  end

  def create
    @meet_me = MeetMe.new(meet_me_params)
    @meet_me.addresses_attributes= meet_me_params[:addresses_attributes]
    @meet_me.addresses.each do |address|
      address.meet_me = @meet_me
    end
    @meet_me.save
    redirect_to meet_me_path(@meet_me)
  end

  def update
    respond_to do |format|
      if @meet_me.update(meet_me_params)
        format.html { redirect_to @meet_me, notice: 'Meet me was successfully updated.' }
        format.json { render :show, status: :ok, location: @meet_me }
      else
        format.html { render :edit }
        format.json { render json: @meet_me.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @meet_me.destroy
    respond_to do |format|
      format.html { redirect_to meet_mes_url, notice: 'Meet me was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def yelp_query(address, params)
    Yelp.client.search(address, params)
  end


  private
    def set_meet_me
      @meet_me = MeetMe.find(params[:id])
    end

    def meet_me_params
      params.require(:meet_me).permit(:term, :results, addresses_attributes: [:name])
    end
end
