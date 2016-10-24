class EventsController < ApplicationController
  def index
    # @user = current_user
    @user_state = current_user.state
    @my_state = Event.where(state: @user_state).all
    @other_state = Event.where.not(state: @user_state).all
    # events = Event.where(state:"WA").all -- first table for events page - by state
    # events = Event.where(state:"WA").first.user.first_name -- to find HOST
    # events = Event.where(state:"WA").first.attendees.where(user = user.first)
    # event = Event.where.not(state:'WA')
  end

  def new
  end

  def create #Event.create(name:"Black Belt Test", user:User.where(id:1).first, date:Date.new(1984, 12, 23), state:'WA', location:'Bellevue') -- make sure to find out how to pass the date
    @user = current_user
    @event = Event.create(name: params[:name], location: params[:location], state: params[:state], date: params[:date], user: @user)
    if @event.save 
      redirect_to "/events"
    else
      flash[:errors] = @event.errors.full_messages
      redirect_to '/events'
    end
  end

  def edit
    @event = Event.where(id: params[:id]).first
  end

  def update
    @event = Event.where(id: params[:id]).first
    if @event.update(event_params)
      redirect_to '/events'
    else
      flash[:errors] = @event.errors.full_messages
      redirect_to "/events/#{@event.id}/edit"
    end
  end

  def show
    @event = Event.where(id: params[:id]).first
    puts @event
    @attendance = @event.attending_users
  end

  def destroy
    Event.where(id: params[:id]).first.destroy
    redirect_to '/events'
  end

  private
  def event_params
    params.require(:event).permit(:name, :location, :state, :date)
  end

end

