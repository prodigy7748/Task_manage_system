require 'rails_helper'

RSpec.feature "Tasks", type: :feature do

  describe 'visit task index page' do
    it 'should be able to see all tasks' do
      3.times do 
        create(:task)
      end

      visit tasks_path

      titles = all('#task_index_table tr > td:first-child').map{|t| t.text}
      #可改寫成.map(&:text)
      result = Task.all.map{|t| t.title}
      expect(titles).to eq result
    end
  end
end
