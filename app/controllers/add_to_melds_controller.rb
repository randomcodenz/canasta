class AddToMeldsController < ApplicationController
  def create
    redirect_to Round.find(params[:round_id])
  end
end
