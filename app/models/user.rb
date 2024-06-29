class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }
  validates :admin, inclusion: { in: [true, false] }
  #validates :email, confirmation: true 
  before_validation { email.downcase! }
  #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
 


  def admin_authority
    admin ? 'あり' : 'なし'
  end
end