class StaffCategoriesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_staff_category, only: [ :update, :destroy, :move_up, :move_down ]

  def index
    @categories = StaffCategory.ordered
    @category = StaffCategory.new
  end

  def create
    @category = StaffCategory.new(staff_category_params)
    if @category.save
      redirect_to staff_categories_path, notice: "Categoría creada."
    else
      @categories = StaffCategory.ordered
      render :index, status: :unprocessable_content
    end
  end

  def update
    if @staff_category.update(staff_category_params)
      redirect_to staff_categories_path, notice: "Categoría actualizada."
    else
      redirect_to staff_categories_path, alert: @staff_category.errors.full_messages.to_sentence
    end
  end

  def destroy
    if @staff_category.destroy
      redirect_to staff_categories_path, notice: "Categoría eliminada."
    else
      redirect_to staff_categories_path, alert: @staff_category.errors.full_messages.to_sentence
    end
  end

  def move_up
    @staff_category.move_up
    redirect_to staff_categories_path
  end

  def move_down
    @staff_category.move_down
    redirect_to staff_categories_path
  end

  private

  def admin_redirect_path
    staffs_path
  end

  def set_staff_category
    @staff_category = StaffCategory.find(params[:id])
  end

  def staff_category_params
    params.require(:staff_category).permit(:name)
  end
end
