class SurveysController < ApplicationController

  def show
    @survey = Survey.first
    @first_question = @survey.questions.first
  end
end
