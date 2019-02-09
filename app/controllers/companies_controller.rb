class CompaniesController < ApplicationController
load_and_authorize_resource

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @company.save
        format.html { redirect_to controller: 'admin', action: 'index', notice: 'Empresa criada com sucesso.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @company.update(company_params)
        format.html { redirect_to @company, notice: 'Empresa atualizada com sucesso.' }
        format.json { render :show, status: :ok, location: @company }
      else
        format.html { render :edit }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

private

  def company_params
    params.require(:company).permit(:name)
  end

end
