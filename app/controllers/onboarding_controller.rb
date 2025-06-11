class OnboardingController < ApplicationController
  before_action :authenticate_user!

  def welcome
    redirect_to onboarding_interests_path
  end

  def interests
    @categories = Category.order(:name)
    @step = 'interests'
    @show_onboarding = true
    render 'trips/index'
  end

  def save_interests
    category_ids = params[:category_ids] || []

    category_ids.each do |cat_id|
      Preference.find_or_create_by(
        user: current_user,
        category_id: cat_id,
        subcategory_id: nil
      )
    end

    redirect_to onboarding_sub_interests_path(selected_category_ids: category_ids)
  end

  def sub_interests
    @step = 'sub_interests'
    @show_onboarding = true
    @selected_category_ids = params[:selected_category_ids] || []
    @subcategories = Subcategory.where(category_id: @selected_category_ids)
    render 'trips/index'
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

    redirect_to onboarding_style_and_personality_path
  end

  def style_and_personality
    @step = 'style_and_personality'
    @show_onboarding = true
    style_category = Category.find_by(name: "Style")
    personality_category = Category.find_by(name: "Personality")
    @style_subcategories = style_category&.subcategories || []
    @personality_subcategories = personality_category&.subcategories || []
    render 'trips/index'
  end

  def save_style_and_personality
    redirect_to onboarding_complete_path
  end

  def complete
    session[:onboarding_complete] = true
    redirect_to trips_path, notice: "You're all set!"
  end
end
