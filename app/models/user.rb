class User < ApplicationRecord
  # No :registerable — accounts are only created via db/seeds.rb, never through the UI.
  devise :database_authenticatable, :validatable

  enum :role, { member: 0, admin: 1 }
end
