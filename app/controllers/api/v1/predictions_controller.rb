module Api
  module V1
    class PredictionsController < ApplicationController
      before_action :authenticate_user!

      def show
        prediction = Prediction.find(params[:id])
        render json: prediction, root: :prediction
      end
    end
  end
end
