# frozen_string_literal: true

module Admin
  class EntitysController < ApplicationController
    layout 'admin'
    before_action :set_entity, only: %i[show edit update destroy]
    load_and_authorize_resource find_by: :slug

    # GET /admin/entitys
    def index
      @entitys = Entity.accessible_by(current_ability)
      if params[:query].present?
        query = params[:query].downcase
        @entitys = @entitys.where(build_search_query(Entity, query)).order(id: :desc).page(params[:page]).per(10)
      else
        @entitys = @entitys.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/entitys/1
    def show; end

    # GET /admin/entitys/new
    def new
      @entity = Entity.new
    end

    # GET /admin/entitys/1/edit
    def edit; end

    # POST /admin/entitys
    def create
      @entity = Entity.new(entity_params)

      if @entity.save
        redirect_to [:admin, @entity], notice: 'Salvo com sucesso!'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /admin/entitys/1
    def update
      if @entity.update(entity_params)
        redirect_to [:admin, @entity], notice: 'Salvo com sucesso!'
      else
        render action: 'edit'
      end
    end

    # DELETE /admin/entitys/1
    def destroy
      @entity.destroy
      redirect_to admin_entitys_url, notice: 'Deletado com sucesso!'
    end

    def log_entity
      entity = Entity.friendly.find(params[:id])
      if current_user.update(logged: entity.id)
        flash[:notice] = "Você está logado na entidade #{entity.name_entity}."
      else
        flash[:alert] = 'Ocorreu um erro ao tentar logar na entidade.'
      end

      redirect_back(fallback_location: root_path)
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_entity
      @entity = Entity.friendly.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def entity_params
      params.require(:entity).permit(:cnpj, :phone, :type_entity_id, :name_entity, :uf, :city, :cep, :street,
                                     :number_address, :complement, :slug, :law, :name_diary, :logo, :status, :user_id, :number_edition, :diary_content)
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end
