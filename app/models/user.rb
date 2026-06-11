class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum :role, { citizen: 0, admin: 1 }

  has_many :assigned_issues, class_name: "Issue", foreign_key: :assigned_to_id, inverse_of: :assigned_to, dependent: :nullify
  has_many :comments, dependent: :destroy
end
