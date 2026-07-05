class StaffsController < ApplicationController
  before_action :authenticate_admin!, only: [ :new, :create, :edit, :update, :destroy, :move_up, :move_down ]
  before_action :set_staff, only: [ :edit, :update, :destroy, :move_up, :move_down ]
  before_action :set_categories, only: [ :new, :create, :edit, :update ]

  def index
    @staffs_by_category = Staff.ordered.with_attached_photo.group_by(&:staff_category)
    @categories = StaffCategory.ordered
  end

  def new
    @staff = Staff.new
  end

  def create
    @staff = Staff.new(staff_params)
    if @staff.save
      redirect_to staffs_path, notice: "Staff creado."
    else
      render :new, status: :unprocessable_content
    end
  end

  def edit
  end

  def update
    if @staff.update(staff_params)
      redirect_to staffs_path, notice: "Staff actualizado."
    else
      render :edit, status: :unprocessable_content
    end
  end

  def destroy
    @staff.destroy
    redirect_to staffs_path, notice: "Staff eliminado."
  end

  def move_up
    @staff.move_up
    redirect_to staffs_path
  end

  def move_down
    @staff.move_down
    redirect_to staffs_path
  end

  private

  def admin_redirect_path
    staffs_path
  end

  def set_staff
    @staff = Staff.find(params[:id])
  end

  def set_categories
    @categories = StaffCategory.ordered
  end

  def staff_params
    params.require(:staff).permit(
      :nombre, :cargo, :staff_category_id, :carrera,
      :birth_date, :university_start_date, :kotonoha_start_date,
      :correo, :linkedin_url, :interests, :photo
    )
  end
end
