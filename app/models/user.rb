class User < ActiveRecord::Base
  has_secure_password

  validates :username, presence: true
  validates :email, presence: true
  validates :password, presence: true
  validates :role, presence: true
  validate :password_correct?, on: :update
  validates :cell, format: { with: /\d{10}/, message: "was not in correct format of 1112223333" }, :allow_blank => true

  has_many :donations
  has_many :donation_items, through: :donations
  has_many :user_roles
  has_many :roles, through: :user_roles
  has_many :charities, through: :user_roles

  attr_accessor :current_password

  def password_correct?
    if !password.blank?
      user = User.find_by_id(id)
      if !user.authenticate(current_password)
        errors.add(:current_password, "is incorrect.")
      end
    end
  end

  def platform_admin?
    roles.exists?(name: "platform_admin")
  end

  def charity_admin?
    roles.exists?(name: "charity_admin")
  end

  def charity_original_admin?
    roles.exists?(name: "charity_original_admin")
  end

  def other_user?
    !charity_admin? && !platform_admin? && !charity_original_admin?
  end

  def demote_user
    if charity_admin? && charity_original_admin?
      roles.delete(2)
      roles.delete(3)
    elsif charity_admin?
      roles.delete(2)
    else charity_original_admin?
      roles.delete(name: "charity_original_admin")
    end
  end


end
