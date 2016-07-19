class EventsController < ApplicationController

  # show events for all labs
  def main_index
    @events = Event.upcoming.includes(:lab)
    #authorize_action_for @events
  end

  def edit
    @lab = Lab.friendly.find(params[:lab_id])
    @event = Event.find(params[:id])
    authorize_action_for @lab
  end

  def show
    @event = Event.find(params[:id])
    #authorize_action_for @event
  end

  # show events for current lab only
  def index
    @lab = Lab.friendly.find(params[:lab_id])
    #authorize_action_for Event
  end

  def new
    @lab = Lab.friendly.find(params[:lab_id])
    @event = Event.new
    authorize_action_for @lab
  end

  def update
    @lab = Lab.friendly.find(params[:lab_id])
    @event = Event.find(params[:id])
    authorize_action_for @lab
    if @event.update_attributes event_params
      # track_activity @event, current_user
      redirect_to [@event.lab,@event], notice: "Event Updated"
    else
      render :new
    end
  end

  def create
    @lab = Lab.friendly.find(params[:lab_id])
    @event = @lab.events.build(event_params)
    @event.creator = current_user
    authorize_action_for @lab
    if @event.save
      track_activity @event, current_user
      redirect_to [@event.lab,@event], notice: "Event Created"
    else
      render :new
    end
  end

private

  def event_params
    params.require(:event).permit!
    # (
    #   :name,
    #   :description,
    #   :starts_at,
    #   :ends_at,
    #   :lab_id
    # )
  end

end
