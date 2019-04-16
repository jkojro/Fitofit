FactoryBot.define do
  factory :walk do
    start_location { 'Plac Europejski 2, Warszawa, Polska' }
    end_location { 'Poznańska 121, Warszawa, Polska' }
    distance { 2.36 }
    association :user
  end
end
