class MeetMesController < ApplicationController
  before_action :set_meet_me, only: [:show, :edit, :update, :destroy]

  # GET /meet_mes
  # GET /meet_mes.json
  def index
    @meet_mes = MeetMe.all
  end

  # GET /meet_mes/1
  # GET /meet_mes/1.json
  def show
    midpoint = @meet_me.find_midpoint
    if midpoint[0].nan?
      @warning = 'Please input valid addresses.'
      render 'meet_mes/new'
      # new_meet_me_path
    else
      address = @meet_me.find_address(midpoint)
      params = @meet_me.find_params
      @term = params[:term]
      @yelp = yelp_query(address, params).businesses
    end
    #byebug

  end

  # GET /meet_mes/new
  def new
    @meet_me = MeetMe.new
  end

  # GET /meet_mes/1/edit
  def edit
  end

  # POST /meet_mes
  # POST /meet_mes.json
  def create
    @meet_me = MeetMe.create(meet_me_params)

    redirect_to meet_me_path(@meet_me)

    # respond_to do |format|
    #   if @meet_me.save
    #     format.html { redirect_to @meet_me, notice: 'Meet me was successfully created.' }
    #     format.json { render :show, status: :created, location: @meet_me }
    #   else
    #     format.html { render :new }
    #     format.json { render json: @meet_me.errors, status: :unprocessable_entity }
    #   end
    # end
  end

  # PATCH/PUT /meet_mes/1
  # PATCH/PUT /meet_mes/1.json
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

  # DELETE /meet_mes/1
  # DELETE /meet_mes/1.json
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
    # Use callbacks to share common setup or constraints between actions.
    def set_meet_me
      @meet_me = MeetMe.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meet_me_params
      params.require(:meet_me).permit(:address_1, :address_2, :term, :results)
    end
end
