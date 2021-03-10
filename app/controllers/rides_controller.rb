class RidesController < ApplicationController
  # skip_before_action :authenticate_user!, only: [:index, :show]
  before_action :set_ride, only: [:show, :edit, :update, :destroy, :fav, :unfav]

  def index # filter & search here
    if params[:query].present?
      @rides = filter.search_rides(params[:query])
    else
      filter
    end

    update_tracking
  end

  def show
    @request = Request.new
    update_tracking
  end

  def new
    @ride = current_user.rides.new
    update_tracking
    authorize @ride
  end

  def create
    @ride = current_user.rides.new(ride_params)
    authorize @ride
    if @ride.save
      redirect_to ride_path(@ride)
    else
      render :new
    end
    update_tracking
  end

  def edit
  end

  def update
    @ride.update(ride_params)
    if @ride.save
      redirect_to @ride
    else
      render :edit
    end
    update_tracking
  end

  def destroy
    @ride.destroy
    update_tracking
    redirect_to user_path(current_user), notice: 'Ride was succesfully removed!'
  end

  def fav
    current_user.favorite(@ride)
  end

  def unfav
    current_user.unfavorite(@ride)
  end

  def update_tracking
    tracking = Tracking.find_by(user: current_user.id)
    tracking.update!(location: request.url, location_time: Time.now)
  end

  private

  def filter # ratings!
    case params[:select]
      when '2' # ratings # we don't have this atm!
        @rides = policy_scope(Ride).order(ratings: :desc)
      when '3' # difficulty asc
        @rides = policy_scope(Ride).order(:difficulty)
      when '4' # difficulty desc
        @rides = policy_scope(Ride).order(difficulty: :desc)
      when '5' # num of people asc
        @rides = policy_scope(Ride).order(:number_of_people)
      when '6' # num of people desc
        @rides = policy_scope(Ride).order(number_of_people: :desc)
      when '7' # available_dates: :asc  => earliest
        @rides = policy_scope(Ride).order(:slug)
    else # '1' ie. default
      @rides = policy_scope(Ride).order(created_at: :desc)
    end
  end

  def ride_params
    params.require(:ride).permit(:title, :short_description, :start_location, :start_time, :end_location, :end_time, :difficulty, :number_of_people, :available_dates, :user_id, photos: [])
  end

  def set_ride
    @ride = Ride.find(params[:id])
    authorize @ride
  end
end
