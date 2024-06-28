class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  validates :name, presence: true, length: { maximum: 30 }
  validates :email, presence: true, length: { maximum: 255 }, uniqueness: true
  #format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  before_validation { email.downcase! }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  #validates :email, confirmation: true 
 


  scope :deadline_asc_sort, -> { order(deadline_on: :asc) }
  # 締め切り日（deadline_on）を昇順（古い順）でソートするスコープ
  scope :priority_high_sort, -> { order(priority: :desc) }
  #priority_high_sort: 優先度（priority）を降順（高い順）でソートするスコープ。
  scope :created_at_newest_first, -> { order(created_at: :desc) }
  #created_at_newest_first: 作成日時（created_at）を降順（新しい順）でソートするスコープ。


  scope :search_title, ->(query) { where("title LIKE ?", "%#{query}%") }
  scope :search_status, ->(query) { where(status: query) }



 
  scope :search, -> (search_params) do
    return all if search_params.blank?
    # search_paramsが空であれば、全てのタスクを返す。
    search_title(search_params[:title]).search_status(search_params[:status])
     
  scope :status_is, -> (status) {where(status: :status)if status.present?}
  scope :title_and_tatus_is, -> (title, status) {title_like(title). status_is(status)}
    # 指定された検索パラメータに基づいてタイトル（title）とステータス（status）でフィルタリングする。
  end
end

