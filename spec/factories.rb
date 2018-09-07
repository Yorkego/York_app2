FactoryBot.define do
  factory :friendship do

  end
  factory :comment do
    body { "comment text"}
    parent_id { nil }
  end
  factory :user do
    sequence(:username) { |n| "John#{n}" }
    sequence(:email) { |n| "person#{n}@example.com" }
    password { "password" }
  end
  factory :admin do
    sequence(:username) { |n| "Bob#{n}" }
    sequence(:email) { |n| "admin#{n}@example.com" }
    password { "password" }
    admin { true }
  end
  factory :post do
    title { "Post name" }
    content { "Some text about topic" }
  end
end
