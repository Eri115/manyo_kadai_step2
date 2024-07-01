class User < ApplicationRecord
  has_secure_password
  has_many :tasks, dependent: :destroy

  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  validates :password, confirmation: true, length: { minimum: 6 }
  #validates :password_confirmation, presence: true
  validates :admin, inclusion: { in: [true, false] }
  #validates :email, confirmation: true 
  before_validation { email.downcase! }
  #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }

  before_destroy :ensure_admin
  before_update :ensure_admin_presence_on_update
 

  def admin_authority
    admin ? 'あり' : 'なし'
  end

  private

  def ensure_admin
    if admin? && User.where(admin: true).count == 1
      throw :abort
    end
  end

  def ensure_admin_presence_on_update
    if self.admin_changed? && self.admin_was == true && User.where(admin: true).count <= 1
      errors.add(:base, '管理者が0人になるため権限を変更できません')
      throw :abort
    end
  end
end

 