class DishesController < ApplicationController

  before_action :owner_has_right_to, only: [:create,:update,:destroy]
  before_action :choose_restaurant, only: [:index]

  def index
    if current_user.type == "Owner"
      @dishes = selected_restaurant.dishes.all
      if @dishes.nil?
        render notice:"Restaurants have no dishes added"
      else
        render :index, notice: "Your Restaurant Dishes"
      end
    else
      @dishes = Dish.all
      respond_to do |format|
        format.json { render json: Dish.all }
        format.html {  }
      end
    end
    # @restaurants
    # @dishes = Restaurant.find_by_id(params[:restaurant_id]).dishes.all
    # @dishes = selected_restaurant.dishes.all if current_user.type == "Owner"
    # if @dishes.nil?
    #     render :index, notice:"Restaurants have no dishes added"
    # else
    #     render :index, notice: "Your choosen Restaurant Dishes"
    # end
  end

  def new
    @restaurant = selected_restaurant
    @dish = @restaurant.dishes.new
  end

  def create
    @dish = selected_restaurant.dishes.new(set_params)
    if @dish.save
      redirect_to restaurant_dishes_path(@restaurant), notice: "User's dish Created"
    else
      # byebug
      render :new, notice: "User's dish doesn'ts Created"
    end
  end

  def show
    @dish =  if current_user.type == "Owner"
              selected_dish
            else
              Dish.find_by_id(params[:id])
            end
    render :show, notice:"Here is your choosen dish"
  end

  def edit
    @dish = selected_dish
  end

  def update
    @dish = selected_dish
    return render :show, notice:"Updated dish" if @dish.update(set_params)
    render :show, notice: "Dish doesn't update"
  end

  def destroy
    @dish = selected_dish
    return render :index, notice: "dish deleted succesfully" if @dish.destroy
    render :show, alert: "dish doesn't deleted succesfully"
  end

  def search
    if params[:name]
      render json: Dish.where(name:params[:name])
    elsif params[:category_id]
      render json: Dish.where(category_id:params[:category_id])
    end
  end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      # byebug
      params.require(:dish).permit(:name,:price,:category_id,:image)
    end

    def selected_restaurant
      @restaurant = Restaurant.where(user_id: current_user.id).find_by_id(params[:restaurant_id])
    end

    def selected_dish
      @restaurant = selected_restaurant
      @dish = @restaurant.dishes.find_by_id(params[:id])
      if @dish.nil?
        render :index, notice: "No such dish added in our restaurants"\
      else
        return @dish
      end
    end

end
