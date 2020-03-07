FactoryBot.define  do
  factory :user do
    email {"fakeuser@gmail.com"}
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
end