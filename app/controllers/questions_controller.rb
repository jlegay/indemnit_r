class QuestionsController < ApplicationController

  def show
    if params[:name]
      @question = Question.where(name: params[:name]).first
    else
      @question = Question.find(params[:id])
    end
  end
end
