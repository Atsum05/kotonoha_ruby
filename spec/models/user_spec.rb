require "rails_helper"

RSpec.describe User, type: :model do
  it "defaults to the member role" do
    user = User.create!(email: "member@kotonoha.cl", password: "a-long-password")
    expect(user.member?).to be true
    expect(user.admin?).to be false
  end

  it "can be an admin" do
    user = User.create!(email: "admin@kotonoha.cl", password: "a-long-password", role: :admin)
    expect(user.admin?).to be true
  end

  it "requires a unique email" do
    User.create!(email: "dup@kotonoha.cl", password: "a-long-password")
    duplicate = User.new(email: "dup@kotonoha.cl", password: "another-password")
    expect(duplicate).not_to be_valid
  end
end
