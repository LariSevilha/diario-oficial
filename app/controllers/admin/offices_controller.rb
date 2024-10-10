# frozen_string_literal: true

module Admin
  class OfficesController < ApplicationController
    layout 'admin'
    before_action :set_office, only: %i[show edit update destroy]
    load_and_authorize_resource

    # GET /admin/offices
    def index
      if params[:query].present?
        query = params[:query].downcase
        @offices = Office.where(build_search_query(Office, query)).order(id: :desc).page(params[:page]).per(10)
      else
        @offices = Office.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/offices/1
    def show; end

    # GET /admin/offices/new
    def new
      @office = Office.new
    end

    # GET /admin/offices/1/edit
    def edit; end

    # POST /admin/offices
    def create
      @office = Office.new(office_params)

      if @office.save
        redirect_to [:admin, @office], notice: 'Salvo com sucesso!'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /admin/offices/1
    def update
      if @office.update(office_params)
        redirect_to [:admin, @office], notice: 'Salvo com sucesso!'
      else
        render action: 'edit'
      end
    end

    # DELETE /admin/offices/1
    def destroy
      @office.destroy
      redirect_to admin_offices_url, notice: 'Deletado com sucesso!'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_office
      @office = Office.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def office_params
      params.require(:office).permit(:name)
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end
