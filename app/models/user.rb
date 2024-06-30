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
 
  before_destroy :check_if_last_admin

  def admin_authority
    admin ? 'あり' : 'なし'
  end

  def check_if_last_admin
    if admin? && User.where(admin: true).count <= 1
      errors.add(:base, "管理者が0人になるため削除できません")
      throw :abort
    end
  end
end