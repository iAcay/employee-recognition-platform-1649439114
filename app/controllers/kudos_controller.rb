class KudosController < ApplicationController
  before_action :authenticate_employee!, except: %i[index show]
  before_action :correct_employee?, only: %i[edit update destroy]
  before_action :can_add_another_kudo?, only: %i[new create]

  def index
    render :index, locals: { kudos: Kudo.includes(:receiver, :giver, :company_value).all.order(created_at: :desc) }
  end

  def show
    render :show, locals: { kudo: kudo }
  end

  def new
    render :new, locals: { kudo: Kudo.new }
  end

  def edit
    render :edit, locals: { kudo: kudo }
  end

  def create
    record = Kudo.new(kudo_params)
    record.giver = current_employee

    if record.save
      current_employee.decrement(:number_of_available_kudos).save
      record.receiver.increment(:earned_points).save
      redirect_to kudos_path, notice: 'Kudo was successfully created.'
    else
      render :new, locals: { kudo: record }
    end
  end

  def update
    authorize kudo

    if params.dig(:kudo, :receiver_id).to_i != kudo.receiver.id
      previous_receiver = kudo.receiver
      if kudo.update(kudo_params)
        kudo.receiver.increment(:earned_points).save
        previous_receiver.decrement(:earned_points).save
        redirect_to kudo, notice: 'Kudo was successfully updated.'
      else
        render :edit, locals: { kudo: kudo }
      end
    elsif kudo.update(kudo_params)
      redirect_to kudo, notice: 'Kudo was successfully updated.'
    else
      render :edit, locals: { kudo: kudo }
    end
  end

  def destroy
    authorize kudo

    ActiveRecord::Base.transaction do
      kudo.destroy!
      kudo.giver.increment(:number_of_available_kudos).save!
      kudo.receiver.decrement(:earned_points).save!
    end
    redirect_to kudos_path, notice: 'Kudo was successfully destroyed.'
  rescue ActiveRecord::RecordInvalid, ActiveRecord::StatementInvalid => e
    redirect_to kudos_path, alert: e.message
  end

  private

  def kudo
    @kudo ||= Kudo.find(params[:id])
  end

  def kudo_params
    params.require(:kudo).permit(:title, :content, :giver_id, :receiver_id, :company_value_id)
  end

  def correct_employee?
    return if kudo.giver == current_employee

    redirect_to kudos_path, notice: 'Not authorized to edit this Kudo.'
  end

  def can_add_another_kudo?
    return if current_employee.number_of_available_kudos.positive?

    redirect_to kudos_path, notice: 'You cannot add more kudos.'
  end
end
