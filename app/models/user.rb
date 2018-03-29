class User < ApplicationRecord
devise :database_authenticatable, :registerable, :recoverable, :rememberable,
        :trackable, :validatable

has_one :parameter, dependent: :destroy
has_one :calculation, dependent: :destroy
end
