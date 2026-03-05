# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  ROLES = %w[customer mechanic admin].freeze

  enum :role, { customer: "customer", mechanic: "mechanic", admin: "admin" }, default: :customer

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :role, inclusion: { in: ROLES }
end
