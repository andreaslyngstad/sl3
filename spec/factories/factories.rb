
FactoryBot.define do
  sequence(:random_string)  { |n| "name#{n}" }
  sequence(:name)           { |n|"name#{n}"}
  sequence(:subdomain)      { |n| "subdomain#{n}"}
  sequence(:email)          { |n| "foo#{n}@example.com" }
  sequence(:invoice_number) { |n| "#{n + 10000}"}
  sequence(:address)        { |n| "customer#{n}@example.com" }


  factory :firm do
   name
   subdomain
   plan
   time_zone {"Pacific Time (US & Canada)"}
   closed {false}
   time_format {1}
   date_format {1}
   clock_format {1}
   language {"en"}
   currency {"NOK"}
   tax {25}
   bank_account {1}
   vat_number {1}

   # invoice_email "test@test.no"
   # invoice_message "testing test"
   # invoice_subject  "test"
  end
  factory :firm_no_plan, class: Firm do
   name
   subdomain
   tax {25}
   closed {false}
   time_format {1}
   date_format {1}
   clock_format {1}
  end

  factory :firm_with_users, :parent => :firm do
    after_create do |firm|
      FactoryBot.create(:user, :firm => firm)
    end
  end

  factory :user do
    name
    password {"password"}
    password_confirmation { |u| u.password }
    email
    role {"Admin"}
    firm
  end

  factory :admin_user do
    password {"password"}
    password_confirmation { |u| u.password }
    email
  end

  factory :usernn, class: User do

    password {"password"}
    password_confirmation { |u| u.password }
    email
    role {"Admin"}
    firm
  end
  factory :email2, class: Email do
    address
  end

  factory :project do
    name
    active {true}
    firm
  end

  factory :payment do
    firm
    amount {99}
    plan_name {'costly_factory'}
    card_type {'rich_dude'}
    last_four {'1111'}
  end
  factory :log do
    event {"customer man"}
    begin_time {"2012-10-24 16:08:07 +0200"}
    end_time {"2012-10-24 16:09:07 +0200"}
    log_date {'2012-10-24'}
    firm
    user
  end

  factory :milestone do
    goal {"This is the goal"}
    due {Date.today}
    firm
  end

  factory :todo do
    name {"Todo today"}
    due {Date.current.strftime("%d.%m.%y")}
    user
    firm
    project
  end

  factory :employee do
    name {"employee guy"}
    firm
    customer
  end

  factory :customer do
    name {"customer man"}
    firm
  end
  factory :guides_category do
    title {"test"}
  end

  factory :guide do
    title {"test"}
    content {"test"}
    guides_category
  end


  factory :blog do
    author {"test"}
    title {"test"}
    content {"test"}
  end
  factory :invoice do
    content {"test"}
    firm
    status {1}
    customer
  end
  factory :invoice_line do
    description {"test"}
    invoice
  end
end
