require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }

  describe 'user visit task index page' do
    senerio 'tasks show on index page' do
      3.times do 
        FactoryBot.create(:task)
      end
      visit tasks_path

      titles = all('#task_index_table tr > td:first-child').map(&:text)
      result = Task.all.map{|t| t.title}
      expect(titles).to eq result
    end
  end

  describe 'user creates a new task' do
    scenario 'with title and content' do
      visit new_task_path
      fill_in 'Title', with: title
      fill_in 'Content', with: content
      click_button 'Create Task'

      expect(Task.all.size).to eq 1
      expect(page).to have_content('新增任務成功！')
      expect(page).to have_content(title)
      expect(page).to have_content(content)
    end

    scenario 'without title and content' do
      visit new_task_path
      fill_in 'Title', with: ''
      fill_in 'Content', with: ''
      click_button 'Create Task'

      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Content can\'t be blank')
    end

    scenario 'without title' do
      visit new_task_path
      fill_in 'Title', with: ''
      click_button 'Create Task'

      expect(page).to have_content('Title can\'t be blank')
    end

    scenario 'without content' do
      visit new_task_path
      fill_in 'Content', with: ''
      click_button 'Create Task'

      expect(page).to have_content('Content can\'t be blank')
    end
  end

end
