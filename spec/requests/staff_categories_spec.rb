require "rails_helper"

RSpec.describe "StaffCategories", type: :request do
  let(:admin) { User.create!(email: "admin@kotonoha.cl", password: "a-long-password", role: :admin) }

  describe "as a guest" do
    it "cannot view the categories admin page" do
      get staff_categories_path
      expect(response).to redirect_to(staffs_path)
    end

    it "cannot create a category" do
      expect {
        post staff_categories_path, params: { staff_category: { name: "Nueva" } }
      }.not_to change(StaffCategory, :count)
    end
  end

  describe "as a signed-in admin" do
    before { sign_in admin }

    it "creates a new category" do
      expect {
        post staff_categories_path, params: { staff_category: { name: "Nueva categoría" } }
      }.to change(StaffCategory, :count).by(1)

      expect(response).to redirect_to(staff_categories_path)
    end

    it "reorders categories" do
      first = StaffCategory.create!(name: "Presidente")
      second = StaffCategory.create!(name: "Vicepresidente")

      patch move_up_staff_category_path(second)

      expect(StaffCategory.ordered).to eq([ second, first ])
    end

    it "refuses to delete a category that still has staff" do
      category = StaffCategory.create!(name: "Presidente")
      Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)

      expect {
        delete staff_category_path(category)
      }.not_to change(StaffCategory, :count)
    end

    it "deletes an empty category" do
      category = StaffCategory.create!(name: "Presidente")

      expect {
        delete staff_category_path(category)
      }.to change(StaffCategory, :count).by(-1)
    end
  end
end
