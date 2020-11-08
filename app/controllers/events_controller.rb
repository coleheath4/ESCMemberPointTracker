# frozen_string_literal: true

class EventsController < ApplicationController
  def event_params
    params.require(:event).permit(:name, :description, :host, :point_value, :event_date)
  end

  def index
    @future_events, @past_events = Event.all_split(Event.sorted)
    @is_admin = user_is_admin?
    @user = current_user
  end

  def show
    @user = current_user
    @event = Event.find(params[:id])
    @return_path = !params[:return_path].nil? ? params[:return_path] : events_path
    @return_path_name = !params[:return_path].nil? ? params[:return_path_name] : 'Events'
  end

  def my_events
    @user = current_user
    @events = Event.get_my_events(Event.sorted, @user)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)

    if @event.save && @event.has_all_required_fields?
      flash[:notice] = 'Event created successfully'
      redirect_to(events_path)
    else
      @event.destroy
      flash[:alert] = 'Event Name, Points, and Event Date are required.'
      render('new')
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])

    if @event.update_attributes(event_params)
      flash[:notice] = 'Event has been updated'
      redirect_to(event_path(@event))
    else
      flash[:alert] = 'Event could not be updated'
      redirect_to(edit_event_path(@event))
    end
  end

  def delete
    @event = Event.find(params[:id])
  end

  def destroy
    @event = Event.find(params[:id])
    event_name = @event.name
    if @event.destroy
      flash[:notice] = "Event #{event_name} destroyed successfully"
      redirect_to(events_path)
    end
  end
end
