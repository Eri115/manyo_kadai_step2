class Task < ApplicationRecord
  belongs_to :user
  has_many :task_labels, dependent: :destroy
  has_many :labels, through: :task_labels
 
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true


  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { waiting: 0, working: 1, completed: 2 }


  scope :deadline_asc_sort, -> { order(deadline_on: :asc) }
  # 締め切り日（deadline_on）を昇順（古い順）でソートするスコープ
  scope :priority_high_sort, -> { order(priority: :desc) }
  #priority_high_sort: 優先度（priority）を降順（高い順）でソートするスコープ。
  scope :created_at_newest_first, -> { order(created_at: :desc) }
  #created_at_newest_first: 作成日時（created_at）を降順（新しい順）でソートするスコープ。


  scope :search_title, ->(query) { where("title LIKE ?", "%#{query}%") }
  scope :search_status, ->(query) { where(status: query) if query.present? }
  scope :search_label, ->(label_id) { joins(:labels).where(labels: { id: label_id }) if label_id.present? }

  #scope :search_title, ->(query) { where("title LIKE ?", "%#{query}%") }
  #scope :search_status, ->(query) { where(status: query) }
  #scope :search_label, ->(label_id) { joins(:labels).where(labels: { id: label_id }) if label_id.present? }


  #scope :search_label, ->(label) { joins(:labels).where(labels: { id: label }) if label.present? }

 
  scope :search, -> (search_params) do
    return all if search_params.blank?
    # binding.irb
    search_title(search_params[:title]).search_status(search_params[:status])
      .search_label(search_params[:label_id])
     
    # scope :status_is, -> (status) {where(status: :status)if status.present?}
    # scope :title_and_tatus_is, -> (title, status) {title_like(title). status_is(status)}
    # scope :label_is, ->(label) { joins(:label).where(labels:label) if label.present? }
    # 指定された検索パラメータに基づいてタイトル（title）とステータス（status）でフィルタリングする。
  end

  private

  #def validate_name_not_including_comma
    #if name&.include?(',')
      #errors.add(:name, "Name cannot include a comma")
    #end
  #end
end


