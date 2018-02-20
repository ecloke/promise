require 'open-uri'

class AchievementsController < ApplicationController
  before_action :set_achievement, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @achievements = Achievement.all
    @bn_promises = @achievements.where(party: 'Barisan National', approved: true).order('year DESC').limit(8)
    @ph_promises = @achievements.where(party: 'Pakatan Harapan', approved: true).order('year DESC').limit(8)
  end

  def show
  end

  def new
    @achievement = current_user.achievements.build
  end

  def edit
  end

  def admin
    if current_user.email == "janganlupa@admin.my"
      @not_approved_bnpost = Achievement.all.where(party: "Barisan National", approved: false)
      @not_approved_phpost = Achievement.all.where(party: "Pakatan Harapan",approved: false)
      @approved_post = Achievement.all.where(approved: true)
    else
      redirect_to root_path
    end
  end

  def bn_promises
    @bn_pending = Achievement.where(party: 'Barisan National', status: "Pending", approved: true)
    @bn_completed = Achievement.where(party: 'Barisan National', status: "Completed", approved: true)
  end

  def ph_promises
    @ph_pending = Achievement.where(party: 'Pakatan Harapan', status: "Pending", approved: true)
    @ph_completed = Achievement.where(party: 'Pakatan Harapan', status: "Completed", approved: true)
  end

  def my_activity
    @comments = Comment.all
    @my_post = current_user.achievements.all
    @my_comments = @comments.where(user_id: current_user)
  end

  def create
    page = Nokogiri::HTML(open(params[:achievement][:source]))
    url = page.css("meta[property='og:image']").first.attributes["content"].value
    title = page.css("meta[property='og:title']").first.attributes["content"].value
    if page.css("meta[property='og:description']").first == nil
      description = page.css("meta[name='twitter:description']").first.attributes["content"].value
    else
      description = page.css("meta[property='og:description']").first.attributes["content"].value
    end
    @achievement = current_user.achievements.build(achievement_params)
    @achievement.photo = url
    @achievement.title = title
    @achievement.description = description

    respond_to do |format|
      if @achievement.save

        format.html { redirect_to @achievement, notice: 'Post was successfully submitted. Please wait for admin to approve your article.' }
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
        format.html { redirect_to @achievement, notice: 'Post was successfully updated.' }
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
      format.html { redirect_to achievements_url, notice: 'Post was successfully destroyed.' }
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
      params.require(:achievement).permit(:title, :description, :source, :year, :amount, :party, :location, :status, :approved, :photo)
    end
end
