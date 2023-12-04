class CategoriesController < ApplicationController

before_action :owner_has_right_to, only: [:create,:update,:destroy]

  def index
    # byebug
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    # byebug
    @category = Category.new(set_params)
    if @category.save
      redirect_to categories_path, notice:"Category Created"
    else
      render :new, notice: "Category Not Created"
    end
  end

  def show
    category = Category.find_by_id(params[:id])
    return render json: {message: "Here is your choosen category", data: category} if category.present?
    render json: {message: "Category is not present"}
  end

  def update
    category = Category.find_by_id(params[:id])
    return render json: {message: "No such category"} if category.nil?
    return render json: {message:"Updated category", data: category} if category.update(set_params)
    render json: {errors: category.errors.full_message}
  end

  # def destroy
  #   category = Category.find_by_id(params[:id])
  #   return render json: {message: "category deleted succesfully"} if category.destroy
  #   render json: {errors: "category doesn't deleted"}
  # end

#----------------------------PRIVATE METHOD-------------------------------------

  private
    def set_params
      params.require(:category).permit(:name)
    end

end
