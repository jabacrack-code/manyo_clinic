require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  describe 'Registration' do
    context 'when a user submits a new task' do
      it 'displays the newly created task' do
        visit new_task_path
        fill_in 'タイトル', with: 'My Test Task'
        fill_in '内容', with: 'My test content.'
        fill_in '終了期限', with: '2026-12-31'
        select '中', from: 'task[priority]'
        select '未着手', from: 'task[status]'
        click_button '登録する'

        expect(page).to have_content 'タスクを登録しました'
        expect(page).to have_content 'My Test Task'
      end
    end
  end

  describe 'Task list' do
    let!(:first_task)  { FactoryBot.create(:task, title: 'first_task',  created_at: '2026-02-18', deadline_on: '2026-02-18', priority: 'medium', status: 'not_started') }
    let!(:second_task) { FactoryBot.create(:task, title: 'second_task', created_at: '2026-02-12', deadline_on: '2026-02-20', priority: 'high', status: 'in_progress') }
    let!(:third_task)  { FactoryBot.create(:task, title: 'third_task',  created_at: '2026-01-06', deadline_on: '2026-02-10', priority: 'low', status: 'completed') }

    before { visit tasks_path }   

    context 'when the list page is loaded' do
      it 'shows all registered tasks' do
        expect(page).to have_content 'first_task'
        expect(page).to have_content 'second_task'
        expect(page).to have_content 'third_task'
      end

      it '作成済みのタスク一覧が作成日時の降順で表示される' do
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'first_task'
        expect(task_list[1]).to have_content 'second_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context '新たにタスクを作成した場合' do
      it '新しいタスクが一番上に表示される' do
        visit new_task_path
        fill_in 'タイトル', with: 'newly_created_task'
        fill_in '内容', with: 'My test content.'
        fill_in '終了期限', with: '2026-12-31'
        select '中', from: 'task[priority]'
        select '未着手', from: 'task[status]'
        click_button '登録する'

        expect(page).to have_content 'タスクを登録しました'
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'newly_created_task'
      end
    end

    context 'when sorted by deadline' do
      it 'shows tasks sorted by deadline ascending' do
        click_link '終了期限'
        sleep 0.2
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'third_task'
        expect(task_list[1]).to have_content 'first_task'
        expect(task_list[2]).to have_content 'second_task'
      end
    end

    context 'when sorted by priority' do
      it 'shows tasks sorted by priority descending' do
        click_link '優先度'
        sleep 0.2
        task_list = all('tbody tr')
        expect(task_list[0]).to have_content 'second_task'
        expect(task_list[1]).to have_content 'first_task'
        expect(task_list[2]).to have_content 'third_task'
      end
    end

    context 'when search is performed' do
      it 'filters tasks by fuzzy title' do
        fill_in 'search[title]', with: 'first'
        click_button '検索'
        expect(page).to have_content 'first_task'
        expect(page).not_to have_content 'second_task'
      end

      it 'filters tasks by status' do
        select '着手中', from: 'search[status]'
        click_button '検索'
        expect(page).to have_content 'second_task'
        expect(page).not_to have_content 'first_task'
      end

      it 'filters tasks by both title and status' do
        fill_in 'search[title]', with: 'second'
        select '着手中', from: 'search[status]'
        click_button '検索'
        expect(page).to have_content 'second_task'
        expect(page).not_to have_content 'first_task'
      end
    end
  end

  describe 'Task detail' do
    context 'when a user visits a task page' do
      it 'displays the full task content' do
        task = FactoryBot.create(:task, title: 'Document preparation', content: 'My test content.')
        visit task_path(task.id)

        expect(page).to have_content 'Document preparation'
        expect(page).to have_content 'My test content.'
      end
    end
  end
end