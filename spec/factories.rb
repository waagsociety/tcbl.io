# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do

  factory :lab, aliases: [:linkable, :trackable] do
    sequence(:name) { |n| "Fab Lab #{n}" }
    sequence(:slug) { |n| "fablab#{n}" }
    description { Faker::Lorem.sentence }
    address_1 { Faker::Address.street_address }
    county "County"
    country_code "es"
    network true
    programs true
    tools true
    kind 1
    referee_id 1
    creator
  end

  factory :repeat do
    event
    year 2013
    month 0
    day 1
    week 1
    weekday 1
  end

  factory :coupon do
    user
    description "Fab 10 Discount Code"
    value 300
  end

  factory :academic do
    user
    lab
    started_in 2012
    approver
  end

  factory :page do
    pageable
    name { "Tutorial #{1}" }
    body "this is a tutorial"
    creator
  end

  factory :event do
    # type ""
    sequence(:name) { |n| "Event #{n}" }
    description "An Open Day"
    lab
    creator
    starts_at { Time.zone.now + 1.day }
    ends_at { Time.zone.now + 1.day + 2.hours }
  end

  factory :activity do
    actor
    creator
    action "create"
    trackable
  end

  factory :admin_application do
    applicant
    lab
    notes "MyText"
  end

  factory :comment do
    author
    commentable
    body "MyText"
  end

  factory :employee do
    user
    lab
    job_title "Manager"
    description "Manages the Lab"
    started_on "2013-10-04"
    finished_on "2013-11-12"
  end

  factory :discussion do
    title "MyString"
    body "MyText"
    association :discussable, factory: :lab
    creator
    workflow_state "MyString"
  end

  factory :facility do
    lab
    machine
    notes "cool machine"
  end

  factory :link do
    linkable
    url "http://www.fablabbcn.org/"
    description "Wordpress Blog"
  end

  factory :featured_image do
    src "http://www.fablabbcn.org/wp-content/uploads/2013/10/012.jpg"
    name "ELEFAB"
    description "A one-of-a-kind elephant creature during a kids' workshop "
    url "http://www.fablabbcn.org/2013/10/elefab-2/"
  end

  factory :user, aliases: [:creator, :author, :applicant, :actor, :approver] do
    sequence(:username) {|n| "user#{n}"}
    first_name "John"
    last_name "Rees"
    sequence(:email) {|n| "john#{n}@bitsushi.com"}
    password "password"
    password_confirmation "password"
  end

  factory :recovery do
    user
    ip '8.8.8.8'
  end

  factory :brand do
    name "Roland"
  end

  factory :machine, aliases: [:commentable, :pageable] do
    name "Modela"
    brand
    description "A general purpose milling machine"
  end

  factory :role_application do
    user
    lab
    description "I work here"
  end

end
