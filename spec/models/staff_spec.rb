require "rails_helper"

RSpec.describe Staff, type: :model do
  let(:category) { StaffCategory.create!(name: "Presidente") }

  def build_staff(attrs = {})
    Staff.new({ nombre: "Ana", cargo: "Presidenta", staff_category: category }.merge(attrs))
  end

  it "is valid with nombre, cargo and a category" do
    expect(build_staff).to be_valid
  end

  it "requires nombre and cargo" do
    expect(build_staff(nombre: nil)).not_to be_valid
    expect(build_staff(cargo: nil)).not_to be_valid
  end

  it "requires a staff_category" do
    expect(build_staff(staff_category: nil)).not_to be_valid
  end

  it "rejects invalid emails" do
    expect(build_staff(correo: "not-an-email")).not_to be_valid
    expect(build_staff(correo: "ana@kotonoha.cl")).to be_valid
  end

  it "rejects non-http(s) linkedin urls" do
    expect(build_staff(linkedin_url: "javascript:alert(1)")).not_to be_valid
    expect(build_staff(linkedin_url: "https://linkedin.com/in/ana")).to be_valid
  end

  it "auto-assigns the next position within its category on create" do
    first = Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)
    second = Staff.create!(nombre: "Beto", cargo: "Vice", staff_category: category)

    expect(second.position).to be > first.position
  end

  describe "computed date fields" do
    it "computes edad from birth_date" do
      staff = build_staff(birth_date: 20.years.ago.to_date)
      expect(staff.edad).to eq(20)
    end

    it "returns nil when birth_date is absent" do
      expect(build_staff(birth_date: nil).edad).to be_nil
    end

    it "computes anos_en_la_u from university_start_date" do
      staff = build_staff(university_start_date: 3.years.ago.to_date)
      expect(staff.anos_en_la_u).to eq(3)
    end

    it "computes tiempo_en_kotonoha as a human string" do
      staff = build_staff(kotonoha_start_date: 14.months.ago.to_date)
      expect(staff.tiempo_en_kotonoha).to match(/año/)
    end

    it "reports less than a month for a very recent start date" do
      staff = build_staff(kotonoha_start_date: 3.days.ago.to_date)
      expect(staff.tiempo_en_kotonoha).to eq("Menos de un mes")
    end
  end

  describe "#move_up / #move_down" do
    it "only swaps within the same category" do
      other_category = StaffCategory.create!(name: "Vicepresidente")
      a = Staff.create!(nombre: "A", cargo: "x", staff_category: category)
      _b_other = Staff.create!(nombre: "B", cargo: "y", staff_category: other_category)

      expect { a.move_up }.not_to change { a.reload.position }
    end

    it "swaps position with the adjacent staff in the same category" do
      first = Staff.create!(nombre: "A", cargo: "x", staff_category: category)
      second = Staff.create!(nombre: "B", cargo: "y", staff_category: category)

      second.move_up

      expect(Staff.ordered.where(staff_category: category)).to eq([ second, first ])
    end
  end
end
