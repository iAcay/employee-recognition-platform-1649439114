class KudosController < ApplicationController
  before_action :set_kudo, only: %i[show edit update destroy]
  before_action :authenticate_employee!, except: %i[index show]
  before_action :correct_employee, only: %i[edit update destroy]
  before_action :can_add_another_kudo?, only: %i[new create]

  # GET /kudos
  def index
    @kudos = Kudo.includes(:receiver, :giver).all
  end

  # GET /kudos/1
  def show; end

  # GET /kudos/new
  def new
    @kudo = Kudo.new
  end

  # GET /kudos/1/edit
  def edit; end

  # POST /kudos
  def create
    @kudo = Kudo.new(kudo_params)
    @kudo.giver = current_employee

    if @kudo.save
      redirect_to kudos_path, notice: 'Kudo was successfully created.'

      current_employee.update(number_of_available_kudos: current_employee.number_of_available_kudos - 1)
    else
      render :new
    end
  end

  # PATCH/PUT /kudos/1
  def update
    if @kudo.update(kudo_params)
      redirect_to @kudo, notice: 'Kudo was successfully updated.'
    else
      render :edit
    end
  end

  # DELETE /kudos/1
  def destroy
    @kudo.destroy
    redirect_to kudos_url, notice: 'Kudo was successfully destroyed.'

    current_employee.update(number_of_available_kudos: current_employee.number_of_available_kudos + 1)
  end

  def correct_employee
    return if @kudo.giver == current_employee

    redirect_to kudos_path, notice: 'Not authorized to edit this Kudo.'
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_kudo
    @kudo = Kudo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def kudo_params
    params.require(:kudo).permit(:title, :content, :giver_id, :receiver_id)
  end

  def can_add_another_kudo?
    return if current_employee.number_of_available_kudos.positive?

    redirect_to kudos_path, notice: 'You cannot add more kudos.'
  end
end
