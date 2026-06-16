FactoryBot.define do
  factory :task do
    title { 'Document preparation' }
    content { 'Create a proposal.' }
  end

  factory :second_task, class: Task do
    title { 'send e-mail' }
    content { 'Send a sales email to a customer.' }
  end
end
