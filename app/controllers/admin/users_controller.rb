# frozen_string_literal: true

module Admin
  class UsersController < ApplicationController
    layout 'admin'
    before_action :set_user, only: %i[show edit update destroy]
    load_and_authorize_resource

    # GET /admin/users
    def index
      @users = User.accessible_by(current_ability)
      if params[:query].present?
        query = params[:query].downcase
        @users = @users.where(build_search_query(User, query)).order(id: :desc).page(params[:page]).per(10)
      else
        @users = @users.order(id: :desc).page(params[:page]).per(10)
      end
    end

    # GET /admin/users/1
    def show; end

    # GET /admin/users/new
    def new
      @user = User.new
    end

    # GET /admin/users/1/edit
    def edit; end

    # POST /admin/users
    def create
      @user = User.new(user_params)
      if @user.save
        redirect_to [:admin, @user], notice: 'Salvo com sucesso!'
      else
        render action: 'new'
      end
    end

    # PATCH/PUT /admin/users/1
    def update
      if @user.update(user_params)
        redirect_to [:admin, @user], notice: 'Salvo com sucesso!'
      else
        render action: 'edit'
      end
    end

    # DELETE /admin/users/1
    def destroy
      @user.destroy
      redirect_to admin_users_url, notice: 'Deletado com sucesso!'
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:email, :name, :slug, :avatar, :cpf, :rg, :date_birth, :sex,
                                   :functional_registration, :uf, :city, :street, :neighborhood,
                                   :number_address, :complement, :phone, :status,
                                   :office_id, :password, :password_confirmation, :cep, :super_user, :admin_user,
                                   :common_user, :register, :read, :publish, entity_ids: [])
    end
  end
end

def build_search_query(model, query)
  columns = model.column_names
  search_conditions = columns.map { |column| "LOWER(CAST(#{column} AS TEXT)) LIKE :query" }.join(' OR ')
  [search_conditions, { query: "%#{query}%" }]
end
