class PreferencesController < ApplicationController
  def index
  end

  def show
    @preference = Preference.find(params[:id])
  end

  def new
    @preference = Preference.new
  end

  def create
    @preference = Preference.new(preference_params)
    if @preference.save
      redirect_to @preference, notice: 'Preference was successfully created.'
    else
      render :new
    end
  end

  def edit
    @preference = Preference.find(params[:id])
  end

  private

  def preference_params
    params.require(:preference).permit(:user_id, :key, :value)
  end
end
