require 'rails_helper'

RSpec.feature 'Tasks', type: :feature do
  let(:title) { Faker::Lorem.sentence }
  let(:content) { Faker::Lorem.paragraph }
  let(:end_time) { Faker::Time.between(from: DateTime.now - 3.day ,to: DateTime.now - 2.day) }
  let(:end_time) { Faker::Time.between(from: DateTime.now - 1.day, to: DateTime.now) }
  let(:task) { create(:task, title: title, content: content, start_time: start_time, end_time: end_time) }


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
      expect{ create_task(title: title, content: content, end_time: end_time) }.to change { Task.count }.by(1)
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
      create(:task)
      visit tasks_path
      click_on '刪除'
      expect(Task.all.size).to eq 0
      expect(page).to have_content(I18n.t('.tasks.destroy.notice'))
    end
  end

  describe 'order by created_at desc' do
    before :each do 
      @tasks = []
      3.times do
        task = create(:task)
        @tasks << task
      end
      visit tasks_path
    end

    it 'order by created_at asc' do
      within('table') do
        click_on '建立時間'
        expect(page).to have_content('建立時間▲')
        expect(page).to have_content(
          /#{@tasks[0][:title]}+#{@tasks[1][:title]}+#{@tasks[2][:title]}/
        )
      end
    end

    it 'order by created_at desc' do
      within('table') do
        click_on '建立時間'
        click_on '建立時間▲'
        expect(page).to have_content('建立時間▼')
        expect(page).to have_content(
          /#{@tasks[2][:title]}+#{@tasks[1][:title]}+#{@tasks[0][:title]}/
        )
      end
    end
  end

  private
  def create_task(title: nil, content: nil, end_time: nil)
    visit new_task_path
    within('form.task_form') do
      fill_in '任務名稱', with: title
      fill_in '內容', with: content
      fill_in '結束時間', with: end_time
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
