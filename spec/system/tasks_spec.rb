require 'rails_helper'

RSpec.describe 'Task management function', type: :system do
  describe 'Registration function' do
    context 'When registering a task' do
      it 'The registered task is displayed' do
        visit new_task_path
        fill_in 'Title', with: 'Document preparation'
        fill_in 'Content', with: 'Create a proposal.'
        click_button 'Create Task'
        expect(page).to have_content 'Task was successfully created.'
        expect(page).to have_content 'Document preparation'
      end
    end
  end

  describe 'List display function' do
    context 'When transitioning to the list screen' do
      it 'A list of registered tasks is displayed' do
        FactoryBot.create(:task)
        visit tasks_path
        expect(page).to have_content 'Document preparation'
      end
    end
  end

  describe 'Detailed display function' do
    context 'When transitioned to any task details screen' do
      it 'The content of the task is displayed' do
        task = FactoryBot.create(:task)
        visit task_path(task)
        expect(page).to have_content 'Document preparation'
        expect(page).to have_content 'Create a proposal.'
      end
    end
  end
end
