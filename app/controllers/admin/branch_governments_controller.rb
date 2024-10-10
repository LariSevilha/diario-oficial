# frozen_string_literal: true

module Admin
  class BranchGovernmentsController < ApplicationController
    layout 'admin'
    before_action :set_branch_government, only: %i[show edit update destroy]
    load_and_authorize_resource

    # GET /admin/branch_governments
    def index
      if params[:query].present?
        query = params[:query].downcase
        @branch_governments = BranchGovernment.where(build_search_query(BranchGovernment,
                                                                        query)).order(id: :desc).page(params[:page]).per(10)
      else
        @branch_governments = BranchGovernment.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/branch_governments/1
    def show; end

    # GET /admin/branch_governments/new
    def new
      @branch_government = BranchGovernment.new
    end

    # GET /admin/branch_governments/1/edit
    def edit; end

    # POST /admin/branch_governments
    def create
      @branch_government = BranchGovernment.new(branch_government_params)

      if @branch_government.save
        redirect_to [:admin, @branch_government], notice: 'Salvo com sucesso!'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /admin/branch_governments/1
    def update
      if @branch_government.update(branch_government_params)
        redirect_to [:admin, @branch_government], notice: 'Salvo com sucesso!'
      else
        render action: 'edit'
      end
    end

    # DELETE /admin/branch_governments/1
    def destroy
      @branch_government.destroy
      redirect_to admin_branch_governments_url, notice: 'Deletado com sucesso!'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_branch_government
      @branch_government = BranchGovernment.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def branch_government_params
      params.require(:branch_government).permit(:name)
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end
