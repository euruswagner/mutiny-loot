FactoryBot.define  do
  factory :user do
    email {"fakeuser@gmail.com"}
    char_name {"fake"}
    password {"password"}
    password_confirmation {"password"}
    approved {true}
  end
end