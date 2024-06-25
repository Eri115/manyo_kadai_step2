class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline_on, presence: true
  validates :priority, presence: true
  validates :status, presence: true
 
  enum priority: { low: 0, medium: 1, high: 2 }
  enum status: { waiting: 0, working: 1, completed: 2 }


  scope :deadline_asc_sort, -> { order(deadline_on: :asc) }
  scope :priority_high_sort, -> { order(priority: :desc) }
  scope :created_at_newest_first, -> { order(created_at: :desc) }

  scope :search, -> (search_params) do
    return all if search_params.blank?
    
    where(title: search_params[:title], status: search_params[:status])
  end
end

