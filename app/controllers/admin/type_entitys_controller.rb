# frozen_string_literal: true

module Admin
  class TypeEntitysController < ApplicationController
    layout 'admin'
    before_action :set_type_entity, only: %i[show edit update destroy]
    load_and_authorize_resource

    # GET /admin/type_entitys
    def index
      if params[:query].present?
        query = params[:query].downcase
        @type_entitys = TypeEntity.where(build_search_query(TypeEntity,
                                                            query)).order(id: :desc).page(params[:page]).per(10)
      else
        @type_entitys = TypeEntity.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/type_entitys/1
    def show; end

    # GET /admin/type_entitys/new
    def new
      @type_entity = TypeEntity.new
    end

    # GET /admin/type_entitys/1/edit
    def edit; end

    # POST /admin/type_entitys
    def create
      @type_entity = TypeEntity.new(type_entity_params)

      if @type_entity.save
        redirect_to [:admin, @type_entity], notice: 'Salvo com sucesso!'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /admin/type_entitys/1
    def update
      if @type_entity.update(type_entity_params)
        redirect_to [:admin, @type_entity], notice: 'Salvo com sucesso!'
      else
        render action: 'edit'
      end
    end

    # DELETE /admin/type_entitys/1
    def destroy
      @type_entity.destroy
      redirect_to admin_type_entitys_url, notice: 'Deletado com sucesso!'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_type_entity
      @type_entity = TypeEntity.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def type_entity_params
      params.require(:type_entity).permit(:name)
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end
