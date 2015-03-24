FactoryGirl.define do
  factory :dog do
    name "Fido"
    age 3
    owner

    factory :old_dog do
      age 12
    end
  end

  factory :owner do
    name "Christina"
    age 23
    email "christina@gmail.com"

    factory :owner_with_dogs do
      after(:create) do |owner|
        FactoryGirl.create(:dog, name: "Bristol", owner: owner)
        FactoryGirl.create(:dog, name: "Allie", owner: owner)
        FactoryGirl.create(:dog, name: "Sisal", owner: owner)
      end
    end
  end
end
