class HacksController < ApplicationController
  # For ajax
  #before_action :all_hacks, only: [:index,                   :create, :update, :destroy]
  before_action :set_hack,  only: [            :show, :edit,          :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  respond_to :js, :html, :json

  def favorite
    @hack_id = params[:id]
    @favorite = Favorite.find_or_initialize_by(user_id: current_user.id, hack_id: params[:id])

    if @favorite.persisted?
      @favorite.destroy
      respond_to do |format|
        format.js {  }
      end
    else
      @favorite.save
      respond_to do |format|
        format.js {  }
      end
    end

  end

  # GET /hacks
  # GET /hacks.json
  def index
    if params[:tag]
      @hacks = Hack.tagged_with(params[:tag]).includes(:taggings, :tags, :favorites, :users).page(params[:page]).per(20)
    else
      @hacks = Hack.all.by_newest.page(params[:page]).per(20)
    end

    #else params[:filter]
      #@hacks = Hack. #call scope method corresponding to filter parameter's semantics.
    #end

    #@users = @hacks.join users where user_id current_user.id
    #@favorites = @hacks.joins favorites where user_id = current_user.id
    #Then bind these to @hacks, and make the partial referencing them call the cached users and favorites
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
    #if request.xhr?
    #  flash[:notice] = "Please log in =)."
    #  flash.keep(:notice) # Keep flash notice around for the redirect.
    #  render :js =>   "window.location = #{login_path.to_json}"
    #end
  end

  # GET /hacks/1/edit
  def edit

    #if timed_out?(@hack)
    # redirect_to request.referrer, notice: "No longer editable."
    #nd
  end

  # POST /hacks
  # POST /hacks.json
  def create
    @hack = Hack.new(hack_params)
    @hack.user_id = current_user.id

    #if @hack.save
    #  flash[:notice] = 'Your hack was successfully submitted.'
    #  #format.js {  }
    #  #format.html { redirect_to hacks_path, notice: 'Hack was successfully submitted.' }
    #  #format.json { render :show, status: :created, location: @hack }
    #else
    #  flash[:alert] = 'There was a problem submitting your hack. Please try again.'
    #  #format.js {  }
    #  #format.html { render :new }
    #  #format.json { render json: @hack.errors, status: :unprocessable_entity }
    #end

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
    #@hack.update(hack_params)
    #  flash[:notice] = 'Hack was successfully updated.'
    #else
    #  flash[:alert] = 'There was a problem editing your hack. Plesae try again.'
    #end

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
    def all_hacks
      @hacks = Hack.eager_loaded_except_comments.by_newest.page(params[:page]).per(10)
    end
    # Use callbacks to share common setup or constraints between actions.
    def set_hack
      @hack = Hack.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hack_params
      params.require(:hack).permit(:body, :tag_list)
    end
end
