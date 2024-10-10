# frozen_string_literal: true

class OfficialDiarysController < ApplicationController
  def index
    @diarys = OfficialDiary.all.order(created_at: :desc).page(params[:page]).per(10)
  end
end
