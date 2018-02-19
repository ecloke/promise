require 'open-uri'

class AchievementsController < ApplicationController
  before_action :set_achievement, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @achievements = Achievement.all
    @bn_promises = @achievements.where(party: 'Barisan National')
    @ph_promises = @achievements.where(party: 'Pakatan Harapan')
  end

  def show
  end

  def new
    @achievement = current_user.achievements.build
  end

  def edit
  end

  def bn_promises
    @bn_promises = Achievement.where(party: 'Barisan National')
  end

  def ph_promises
    @ph_promises = Achievement.where(party: 'Pakatan Harapan')
  end

  def my_activity
    @my_post = current_user.achievements.all
    @achievements = Achievement.all
  end

  def create
    image = Nokogiri::HTML(open(params[:achievement][:source]))
    url = image.css("meta[property='og:image']").first.attributes["content"].value
    @achievement = current_user.achievements.build(achievement_params)
    @achievement.update(photo: url)

    respond_to do |format|
      if @achievement.save

        format.html { redirect_to @achievement, notice: 'Achievement was successfully created.' }
        format.json { render :show, status: :created, location: @achievement }
      else
        format.html { render :new }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @achievement.update(achievement_params)
        format.html { redirect_to @achievement, notice: 'Achievement was successfully updated.' }
        format.json { render :show, status: :ok, location: @achievement }
      else
        format.html { render :edit }
        format.json { render json: @achievement.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @achievement.destroy
    respond_to do |format|
      format.html { redirect_to achievements_url, notice: 'Achievement was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def upvote 
    @achievement = Achievement.find(params[:id])
    @achievement.upvote_by current_user
    redirect_back fallback_location: root_path
  end

  def downvote
    @achievement = Achievement.find(params[:id])
    @achievement.downvote_by current_user
    redirect_back fallback_location: root_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_achievement
      @achievement = Achievement.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def achievement_params
      params.require(:achievement).permit(:title, :description, :source, :timeline, :amount, :party, :location, :status, :approved, :photo)
    end
end
