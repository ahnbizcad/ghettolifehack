class HacksController < ApplicationController
  before_action :set_hack, only: [:show, :edit, :update, :destroy]

  before_action :authenticate_user!, except: [:index, :show]

  # GET /hacks
  # GET /hacks.json
  def index
    @hacks = Hack.all.by_newest
  end

  # GET /hacks/1
  # GET /hacks/1.json
  def show
    @comment = Comment.build_from(@hack, current_user.id, "") if user_signed_in?
    @comments = @hack.comment_threads.order('created_at DESC')    

  end

  # GET /hacks/new
  def new
    @hack = Hack.new
  end

  # GET /hacks/1/edit
  def edit
    if timed_out?(@hack)
      redirect_to request.referrer, notice: "No longer editable."
    end
  end

  # POST /hacks
  # POST /hacks.json
  def create
    @hack = Hack.new(hack_params)
    @hack.user_id = current_user.id

    respond_to do |format|
      if @hack.save
        format.html { redirect_to hacks_path, notice: 'Hack was successfully submitted.' }
        format.json { render :show, status: :created, location: @hack }
      else
        format.html { render :new }
        format.json { render json: @hack.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hacks/1
  # PATCH/PUT /hacks/1.json
  def update
    respond_to do |format|
      if @hack.update(hack_params)
        format.html { redirect_to @hack, notice: 'Hack was successfully updated.' }
        format.json { render :show, status: :ok, location: @hack }
      else
        format.html { render :edit }
        format.json { render json: @hack.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hacks/1
  # DELETE /hacks/1.json
  def destroy
    @hack.destroy
    respond_to do |format|
      format.html { redirect_to hacks_url, notice: 'Hack was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hack
      @hack = Hack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hack_params
      params.require(:hack).permit(:body)
    end
end
