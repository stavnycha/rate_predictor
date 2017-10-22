class PredictionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_prediction, only: [ :show, :destroy ]
  before_action :set_predictions, only: [ :create, :index ]

  def index
    @prediction = Prediction.new
  end

  def create
    @prediction = current_user.predictions.build(prediction_params)
    if @prediction.save
      redirect_to prediction_path(@prediction)
    else
      render :index
    end
  end

  def show
  end

  def destroy
    if @prediction.destroy
      flash[:notice] = 'Prediction calculation has been removed'
    else
      flash[:notice] = 'Something went wrong'
    end

    redirect_to predictions_path
  end

  private

  def set_prediction
    @prediction ||= Prediction.find(params[:id])
  end

  def set_predictions
    @predictions ||= current_user.predictions.order(created_at: :desc)
                               .page(params[:page]).per(10)
  end

  def prediction_params
    params.require(:prediction).permit(
      :from_currency_id, :to_currency_id, :weeks, :amount
    )
  end
end
