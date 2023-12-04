class User < ApplicationRecord
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable,  stretches: 13
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  # has_secure_password

  validates :name, length: {minimum: 3}, presence: true
  validates :email, uniqueness: {case_sensitive: false}, presence: true
  # validates :encrypted_password, length: {minimum: 4}
  validates :type, inclusion: { in: ['Owner', 'Customer']}
  validates :mobile, length: {is: 10}, uniqueness: true, presence: true
end
