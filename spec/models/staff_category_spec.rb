require "rails_helper"

RSpec.describe StaffCategory, type: :model do
  it "requires a unique name" do
    StaffCategory.create!(name: "Presidente")
    duplicate = StaffCategory.new(name: "Presidente")
    expect(duplicate).not_to be_valid
  end

  it "auto-assigns the next position on create" do
    first = StaffCategory.create!(name: "Presidente")
    second = StaffCategory.create!(name: "Vicepresidente")

    expect(second.position).to be > first.position
  end

  it "orders by position" do
    b = StaffCategory.create!(name: "B")
    a = StaffCategory.create!(name: "A")
    a.update_column(:position, b.position - 1)

    expect(StaffCategory.ordered).to eq([ a, b ])
  end

  it "prevents deleting a category that still has staff" do
    category = StaffCategory.create!(name: "Presidente")
    Staff.create!(nombre: "Ana", cargo: "Presidenta", staff_category: category)

    expect(category.destroy).to be false
    expect(StaffCategory.exists?(category.id)).to be true
  end

  describe "#move_up / #move_down" do
    it "swaps position with the adjacent category" do
      first = StaffCategory.create!(name: "Presidente")
      second = StaffCategory.create!(name: "Vicepresidente")

      second.move_up

      expect(StaffCategory.ordered).to eq([ second, first ])
    end
  end
end
