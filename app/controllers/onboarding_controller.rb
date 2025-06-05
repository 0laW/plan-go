class OnboardingController < ApplicationController
  before_action :authenticate_user!

  def steps
    @onboarding_step = params[:step] || "welcome"

    case @onboarding_step
    when "interests"
      @categories = Category.all
    when "sub_interests"
      @selected_category_ids = session[:selected_category_ids] || []
      @subcategories = Subcategory.where(category_id: @selected_category_ids)
    when "style_and_personality"
      style_category = Category.find_by(name: "Style")
      personality_category = Category.find_by(name: "Personality")
      @style_subcategories = style_category&.subcategories || []
      @personality_subcategories = personality_category&.subcategories || []
    end

    render :steps
  end

  def save_interests
    category_ids = params[:category_ids] || []

    category_ids.each do |cat_id|
      Preference.find_or_create_by(user: current_user, category_id: cat_id, subcategory_id: nil)
    end

    session[:selected_category_ids] = category_ids
    redirect_to onboarding_steps_path(step: "sub_interests")
  end

  def save_sub_interests
    subcategory_ids = params[:subcategory_ids] || []
    subcategory_ids.each do |subcat_id|
      subcat = Subcategory.find_by(id: subcat_id)
      next unless subcat
      Preference.find_or_create_by(
        user: current_user,
        category_id: subcat.category_id,
        subcategory_id: subcat.id
      )
    end
    redirect_to onboarding_steps_path(step: "style_and_personality")
  end

  def save_style_and_personality
    redirect_to onboarding_steps_path(step: "complete")
  end

  def find_friends
    if params[:username].present?
      @search_results = User.where("username ILIKE ?", "%#{params[:username]}%").where.not(id: current_user.id)
    else
      @search_results = []
    end
  end

  def complete
    session[:onboarding_complete] = true
    redirect_to root_path, notice: "You're all set!"
  end
end
