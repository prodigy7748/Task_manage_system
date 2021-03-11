require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }

  describe 'user visit task index page' do
    scenario 'tasks show on index page' do
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
      create_task(title, content)
      expect(page).to have_content('新增任務成功！')
      expect(page).to have_content(title)
      expect(page).to have_content(content)
    end

    scenario 'without title and content' do
      create_task(nil, nil)
      expect(page).to have_content('Title can\'t be blank')
      expect(page).to have_content('Content can\'t be blank')
    end

    scenario 'without title' do
      create_task(nil, content)
      expect(page).to have_content('Title can\'t be blank')
    end

    scenario 'without content' do
      create_task(title, nil)
      expect(page).to have_content('Content can\'t be blank')
    end
  end

  describe 'show a task' do
    it do
      task = Task.create(title: title, content: content)
      visit task_path(task)

      expect(page).to have_content(title)
      expect(page).to have_content(content)
    end
  end

  private
  def create_task(title, content)
    visit new_task_path
    fill_in '任務名稱', with: title
    fill_in '內容', with: content
    click_button '新增任務'
  end

end
