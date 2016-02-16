# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :lab_criterium, :class => 'LabCriteria' do
    lab_id 1
    principle1 "MyString"
    principle2 "MyString"
    principle3 "MyString"
    principle4 "MyString"
    principle5 "MyString"
    principle6 "MyString"
    principle7 "MyString"
    service1 "MyString"
    service2 "MyString"
    service3 "MyString"
    service4 "MyString"
    service5 "MyString"
    network "MyString"
  end
end
