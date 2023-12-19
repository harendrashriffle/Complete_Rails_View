class RestaurantsController < ApplicationController

  # before_action :owner_has_right_to, only: [:create,:update,:destroy]

  def index
    @restaurants = Restaurant.all
    @restaurants = current_user.restaurants if current_user.type == 'Owner'
    @restaurants = @restaurants.where('name LIKE ?', "%#{params[:name]}%") if params[:name].present?
    @restaurants = @restaurants.where(status: params[:status]) if params[:status].present?
    @restaurants = @restaurants.where('location LIKE ?', "%#{params[:location]}%") if params[:location].present?
    # restaurants = restaurants.page(params[:page]).per(
    # return render json: { message: 'Restaurants found', data: @restaurants } if @restaurants.present?
    # render json: { message: 'No restaurants found' }
  end

  def new
    @restaurant = Restaurant.new
  end

  def create
    # byebug
    @restaurant = current_user.restaurants.new(set_params)
    if @restaurant.save
      redirect_to root_path, notice: "Your's Restaurant Created"
    else
      # byebug
      render :new, notice: "Restaurant doesn't created"
    end
  end

  def show
    # @restaurant = if current_user.type == "Owner"
    #               selected_restaurant
    #             else
    #               Restaurant.find_by(id: params[:id])
    #             end
    # render json: {message: "Here is your choosen retaurant",data: restaurant}
    @restaurant = selected_restaurant
    @dishes = @restaurant.dishes


  end

  def edit
    @restaurant = current_user.restaurants.find_by_id(params[:id])
  end

  def update
    @restaurant = selected_restaurant
    if @restaurant.update(set_params)
      redirect_to restaurant_path(@restaurant)
    else
      render :edit, notice: "Restaurant doesn't updated"
    end
  end

  def destroy
    @restaurant = selected_restaurant
    if @restaurant.destroy
      redirect_to root_path, notice: "Restaurant Deleted Succesfully"
    else
      render :show, notice: "Restaurant doesn't deleted succesfully"
    end
  end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      params.require(:restaurant).permit(:name,:status,:location,:image)
    end

    def selected_restaurant
      # byebug
      @restaurant = Restaurant.all
      @restaurant = current_user.restaurants if current_user.type == 'Owner'
      @restaurant = @restaurant.find_by(id: params[:id])
      @restaurant.nil? ? "You have no such restaurant" : @restaurant
    end
end
