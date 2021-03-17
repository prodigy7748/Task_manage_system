class Task < ApplicationRecord
  enum priority: { low:0, medium:1, high:2 }
  enum status: { pending: 0, processing: 1, completed: 2 }

  validates :title, presence: true, uniqueness: true
  validates :content, presence: true
  validates :priority, presence: true, inclusion: { in: %w(low medium high) }
  validates :status, presence: true, inclusion: { in: %w(pending processing completed) }
  validates :start_time, presence: true
  validates :end_time, presence: true

end
