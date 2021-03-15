require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }
  let(:task) { create(:task, title: title, content: content) }


  describe 'user visit task index page' do
    scenario 'tasks show on index page' do
      3.times { create(:task) }
      visit tasks_path

      titles = all('#task_index_table tr > td:first-child').map(&:text)
      result = Task.pluck(:title)
      expect(titles).to eq result
    end
  end

  describe 'user creates a new task' do
    scenario 'with title and content' do
      expect{ create_task(title: title, content: content) }.to change { Task.count }.by(1)
      expect(page).to have_content(I18n.t('tasks.create.notice'))
      expect(page).to have_content(title)
      expect(page).to have_content(content)
    end

    scenario 'without title and content' do
      create_task()
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.title')} #{I18n.t('activerecord.errors.models.task.attributes.title.blank')}")
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.content')} #{I18n.t('activerecord.errors.models.task.attributes.content.blank')}")
    end

    scenario 'without title' do
      create_task(content: content)
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.title')} #{I18n.t('activerecord.errors.models.task.attributes.title.blank')}")
    end

    scenario 'without content' do
      create_task(title: title)
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.content')} #{I18n.t('activerecord.errors.models.task.attributes.content.blank')}")
    end
  end

  describe 'show a task' do
    it 'should show right content of a task' do
      visit task_path(task)
      expect(page).to have_content(title)
      expect(page).to have_content(content)
    end
  end

  describe 'edit a task' do
    let(:new_title) { Faker::Lorem.sentence }
    let(:new_content) { Faker::Lorem.paragraph }

    it 'with new_title and new_content' do
      edit_task(title: new_title, content: new_content)
      expect(page).to have_content(new_title)
      expect(page).to have_content(new_content)
    end

    it 'without title and content' do
      edit_task()
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.title')} #{I18n.t('activerecord.errors.models.task.attributes.title.blank')}")
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.content')} #{I18n.t('activerecord.errors.models.task.attributes.content.blank')}")
    end

    it 'without title' do
      edit_task(content: new_content)
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.title')} #{I18n.t('activerecord.errors.models.task.attributes.title.blank')}")
    end

    it 'without content' do
      edit_task(title: new_title)
      expect(page).to have_content("#{I18n.t('activerecord.attributes.task.content')} #{I18n.t('activerecord.errors.models.task.attributes.content.blank')}")
    end
  end

  describe 'delete a task' do
    it do
      create_task(title: title, content: content)
      visit tasks_path
      click_on '刪除'
      expect(Task.all.size).to eq 0
      expect(page).to have_content(I18n.t('.tasks.destroy.notice'))
    end
  end

  private
  def create_task(title: nil, content: nil)
    visit new_task_path
    within('form.task_form') do
      fill_in '任務名稱', with: title
      fill_in '內容', with: content
      click_button '新增任務'
    end
  end

  def edit_task(title: nil, content: nil)
    visit edit_task_path(task)
    within('form.task_form') do
      fill_in '任務名稱', with: title
      fill_in '內容', with: content
      click_button '更新任務'
    end
  end
end
