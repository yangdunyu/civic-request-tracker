# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end
admin = User.find_or_create_by!(email: "admin@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :admin
end

User.find_or_create_by!(email: "citizen@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
  user.role = :citizen
end

Issue.find_or_create_by!(title: "Broken glass near school bus stop") do |issue|
  issue.description = "There is broken glass near the school bus stop on Main Road."
  issue.category = :other
  issue.status = :new_request
  issue.priority = :medium
  issue.location = "Main Road bus stop"
  issue.contact_email = "resident@example.com"
  issue.assigned_to = admin
end
