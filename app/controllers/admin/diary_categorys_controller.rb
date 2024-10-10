# frozen_string_literal: true

module Admin
  class DiaryCategorysController < ApplicationController
    layout 'admin'
    before_action :set_diary_category, only: %i[show edit update destroy]
    load_and_authorize_resource

    # GET /admin/diary_categorys
    def index
      if params[:query].present?
        query = params[:query].downcase
        @diary_categorys = DiaryCategory.where(build_search_query(DiaryCategory,
                                                                  query)).order(id: :desc).page(params[:page]).per(10)
      else
        @diary_categorys = DiaryCategory.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/diary_categorys/1
    def show; end

    # GET /admin/diary_categorys/new
    def new
      @diary_category = DiaryCategory.new
    end

    # GET /admin/diary_categorys/1/edit
    def edit; end

    # POST /admin/diary_categorys
    def create
      @diary_category = DiaryCategory.new(diary_category_params)

      if @diary_category.save
        redirect_to [:admin, @diary_category], notice: 'Salvo com sucesso!'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /admin/diary_categorys/1
    def update
      if @diary_category.update(diary_category_params)
        redirect_to [:admin, @diary_category], notice: 'Salvo com sucesso!'
      else
        render action: 'edit'
      end
    end

    # DELETE /admin/diary_categorys/1
    def destroy
      @diary_category.destroy
      redirect_to admin_diary_categorys_url, notice: 'Deletado com sucesso!'
    end

    def subcategories
      diary_category = DiaryCategory.find(params[:id])
      subcategories = diary_category.diary_sub_categorys

      render json: subcategories.select(:id, :name) # Retorna apenas o ID e o nome
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_diary_category
      @diary_category = DiaryCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def diary_category_params
      params.require(:diary_category).permit(:name)
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end
