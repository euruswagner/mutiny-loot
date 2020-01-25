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

  factory :rank do
    rank { 1 }

    association :item
    association :user
  end
end