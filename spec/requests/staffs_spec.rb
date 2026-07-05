require "rails_helper"

RSpec.describe "Staffs", type: :request do
  let(:admin) { User.create!(email: "admin@kotonoha.cl", password: "a-long-password", role: :admin) }
  let(:category) { StaffCategory.create!(name: "Presidente") }

  describe "GET /staffs" do
    it "returns http success" do
      get staffs_path
      expect(response).to have_http_status(:success)
    end

    it "lists staff under their category heading" do
      Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)

      get staffs_path

      expect(response.body).to include("Ana")
      expect(response.body).to include("Presidente")
    end
  end

  describe "as a guest" do
    it "cannot reach the new staff form" do
      get new_staff_path
      expect(response).to redirect_to(staffs_path)
    end

    it "cannot create staff" do
      expect {
        post staffs_path, params: { staff: { nombre: "Ana", cargo: "Presidenta", staff_category_id: category.id } }
      }.not_to change(Staff, :count)
    end

    it "does not show admin controls" do
      Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)
      get staffs_path
      expect(response.body).not_to include("Editar")
    end

    it "cannot delete staff" do
      staff = Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)
      expect { delete staff_path(staff) }.not_to change(Staff, :count)
    end
  end

  describe "as a signed-in admin" do
    before { sign_in admin }

    it "creates staff with valid params" do
      expect {
        post staffs_path, params: { staff: { nombre: "Ana", cargo: "Presidenta", staff_category_id: category.id } }
      }.to change(Staff, :count).by(1)

      expect(response).to redirect_to(staffs_path)
    end

    it "re-renders the form with errors when invalid" do
      expect {
        post staffs_path, params: { staff: { nombre: "", cargo: "" } }
      }.not_to change(Staff, :count)

      expect(response).to have_http_status(:unprocessable_content)
    end

    it "accepts an attached photo" do
      file = fixture_file_upload("spec/fixtures/files/test_image.png", "image/png")

      post staffs_path, params: {
        staff: { nombre: "Ana", cargo: "Presidenta", staff_category_id: category.id, photo: file }
      }

      expect(Staff.last.photo).to be_attached
    end

    it "updates staff" do
      staff = Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)

      patch staff_path(staff), params: { staff: { cargo: "Ex-presidenta" } }

      expect(staff.reload.cargo).to eq("Ex-presidenta")
    end

    it "deletes staff" do
      staff = Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)

      expect { delete staff_path(staff) }.to change(Staff, :count).by(-1)
    end

    it "reorders staff within a category" do
      first = Staff.create!(nombre: "Ana", cargo: "x", staff_category: category)
      second = Staff.create!(nombre: "Beto", cargo: "y", staff_category: category)

      patch move_up_staff_path(second)

      expect(Staff.ordered.where(staff_category: category)).to eq([ second, first ])
    end
  end
end
