FactoryBot.define  do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    char_name {"fake"}
    password {"password"}
    password_confirmation {"password"}
    approved { true }
  end

  factory :item do
    name {"test item"}
    zone {"Blackwing Lair"}
    classification {'Unlimited'}

  end

  factory :raider do
    name {'test'}
    which_class {'Warrior'}
    role {'Fury'}
  end

  factory :attendance do
    notes {'test'}
    points {0.2}

    association :raider
  end

  factory :priority do
    ranking {50}

    association :raider
    association :item
  end

  factory :winner do
    points_spent {0.2}

    association :raider
    association :item
  end

  factory :raid do
    time = Time.now + 2.days
    name {'ZG'}
    start_time {time}
  end

  factory :signup do
    notes {'test'}
  end

  factory :news_post do
    title {'Test'}
    message {'This is a test message.'}

    association :user
  end

  factory :comment do
    message {'This is a test message.'}

    association :user
    association :news_post
  end
end