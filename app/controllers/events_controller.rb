class EventsController < ApplicationController
  before_action :authenticate_admin!, only: [ :new, :create, :edit, :update, :destroy, :toggle_hidden ]
  before_action :set_event, only: [ :show, :edit, :update, :destroy, :toggle_hidden ]

  def index
    scope = (current_user&.admin? ? Event.all : Event.visible).with_attached_image
    @upcoming_events = scope.upcoming
    @past_events = scope.past
  end

  def show
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to @event, notice: "Evento creado."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Evento actualizado."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Evento eliminado."
  end

  def toggle_hidden
    @event.update(hidden: !@event.hidden)
    redirect_to events_path
  end

  private

  def admin_redirect_path
    events_path
  end

  def set_event
    @event = Event.find(params[:id])
  end

  def event_params
    params.require(:event).permit(
      :title, :description, :event_date, :location, :capacity, :form_url, :status, :image
    )
  end
end
