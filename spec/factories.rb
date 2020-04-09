FactoryBot.define  do
  factory :user do
    sequence(:email) { |n| "person#{n}@example.com" }
    char_name {"fake"}
    password {"password"}
    password_confirmation {"password"}
    approved { true }
  end

  factory :category do 
    name {"Test"}
  end
  
  factory :item do
    name {"test item"}
    zone {"Blackwing Lair"}

    association :category
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
    name {'ZG'}
    start_time {'April 15th, 2020 8:00 PM'}
  end
end