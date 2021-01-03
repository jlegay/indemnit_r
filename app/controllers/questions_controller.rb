class QuestionsController < ApplicationController

  def show
    # Si la réponse a une dépendance vers une autre question, affiche la question dépendante.
    if params[:name]
      @question = Question.where(name: params[:name]).first
    else
      @question = Question.find(params[:id])
    end
  end
end
