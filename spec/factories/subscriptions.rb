# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryBot.define do
  factory :subscription do
    active {true}
    paymill_id {"test"}
    last_four {"1234"}
    card_type {"none"}
    email
    name
    firm
    plan


  end
end
