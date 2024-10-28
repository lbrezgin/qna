FactoryBot.define do
  factory :comment do
    content { "comment's content" }
    association :commentable, factory: :question
    association :user
  end
end
