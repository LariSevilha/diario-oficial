# frozen_string_literal: true

module Admin
  class DiarySubCategorysController < ApplicationController
    layout 'admin'
    before_action :set_diary_sub_category, only: %i[show edit update destroy]
    load_and_authorize_resource

    # GET /admin/diary_sub_categorys
    def index
      if params[:query].present?
        query = params[:query].downcase
        @diary_sub_categorys = DiarySubCategory.where(build_search_query(DiarySubCategory,
                                                                         query)).order(id: :desc).page(params[:page]).per(10)
      else
        @diary_sub_categorys = DiarySubCategory.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/diary_sub_categorys/1
    def show; end

    # GET /admin/diary_sub_categorys/new
    def new
      @diary_sub_category = DiarySubCategory.new
    end

    # GET /admin/diary_sub_categorys/1/edit
    def edit; end

    # POST /admin/diary_sub_categorys
    def create
      @diary_sub_category = DiarySubCategory.new(diary_sub_category_params)

      if @diary_sub_category.save
        redirect_to [:admin, @diary_sub_category], notice: 'Salvo com sucesso!'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /admin/diary_sub_categorys/1
    def update
      if @diary_sub_category.update(diary_sub_category_params)
        redirect_to [:admin, @diary_sub_category], notice: 'Salvo com sucesso!'
      else
        render action: 'edit'
      end
    end

    # DELETE /admin/diary_sub_categorys/1
    def destroy
      @diary_sub_category.destroy
      redirect_to admin_diary_sub_categorys_url, notice: 'Deletado com sucesso!'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_diary_sub_category
      @diary_sub_category = DiarySubCategory.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def diary_sub_category_params
      params.require(:diary_sub_category).permit(:name, :diary_category_id)
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end
