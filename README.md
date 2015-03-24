#Factory Girl

FactoryGirl is a gem that helps you with testing. It basically allows you to create "factories" that crank out objects to your database for you to test. Once FactoryGirl is set up, instead of needing to type this:

```
let(:user) { User.create(username: "cmkoller", email: "email@email.com", provider: "github", uid: "alksdjalks", avatar_url: "http://1.com"}
```

I can type something like this:

```
let(:user) { FactoryGirl.create(:user) }
```

Awesome, right??

### Resources
- [Installation](https://github.com/thoughtbot/factory_girl#install)
- [Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md)

##Set Up

First, add Factory Girl to your Gemfile:

```ruby
group :development, :test do
  # ... other gems ...
  gem 'factory_girl_rails'
end
```

The `bundle install` to install it!

Next make a file at `spec/support/factories.rb`. This is where you'll be creating your factories!

Last of all, we need to make sure we're loading our factories. Open `rails_helper.rb` and uncomment the following line (should be line 21):

```
Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }
```

## Creating Factories

###Setting up the space

Open up `spec/support/factories.rb`. Add the following code:

```ruby
FactoryGirl.define do

  # Your factories will go here!

end
```

You've now set up the space to write all your factories.

###Writing a Simple Factory ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Defining_factories))

Let's say we have a super simple model called Dog. All a Dog object has is a string for name, and an integer for age. In our `factories.rb` file, this is what we would write:

```
factory :dog do
  name "Fido"
  age 3
end
```

It's that simple! Now we've set default values for our Test Dog's name and age, and every time we use FactoryGirl to create a dog it'll have the name "Fido" and the age of 3.

###Using a Factory ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Using_factories))

Now that this factory is set up, ANY time we want to create a Dog object in one of our tests files, we can say:

```
doggy = FactoryGirl.create(:dog)
```

This will return a new Dog object with the name "Fido" and the age 3, just as if we had called:

```
doggy = Dog.create(name: "Fido", age: 3")
```

####Using Factories with Custom info

What if I love using my factory, but for this one test I need a very old dog to test? I can still use the factory I set up earlier, but override one of the default values with my own info:

```
doggy = FactoryGirl.create(:dog, age: 12)
```

Now we've created a dog with all the default info we specified in our factory, *expect* for age which we've overridden. This can be very useful if you have a lot of info in your factory, and just want to change a small piece of it!

##Fancier Factories

###Objects with Uniqueness Constraints (aka [Sequencing](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Sequences))

As of right now, all dogs I create will have the same name (unless otherwise specified). What if I have a uniqueness constraint on dogs' names, so I can't have duplicate names in my database?

```ruby
# factories.rb
factory :dog do
  sequence(:name) { |n| "Dog Number #{n}" }
end
```

This syntax sets up a sequence, meaning that each time you use the factory to create a new dog, the `n` in the block you wrote will increment by 1. So first we'll have "Dog Number 1", then "Dog Number 2", etc!

###Objects with Associations ([Documentation](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Associations))

Let's say we now have an Owner class as well as Dog, and there's a one-to-many relationship between them: an Owner has many Dogs, and a Dog belongs to Owner. We don't want to have any dogs being created without having owners, so what are we to do? First let's add a factory for Owners to our `factories.rb` file:

```ruby
factory :owner do
  name "George"
  age 32
  email "george@gmail.com"
end
```

Once that factory is set up we can go back to our dog factory and just add the word `owner` as a line. If we don't set value, FactoryGirl will go and look for a factory of that name and create the associated object for us!

```ruby
factory :dog do
  name "Fido"
  age 3
  owner
end
```

Now every time we create a new dog, it'll create a new owner to go with it. Let's check it out:

```
doggy = FactoyGirl.create(:dog)
doggy.owner
=> #<Owner:0x007f8e56d73a70 id: 1, name: "George", age: 32, email: "george@gmail.com">
```

Last of all, let's say we want to create a dog with a specific, pre-existing owner. We can just overwrite this default information like before:

```
owner_named_bob = FactoryGirl.create(:owner, name: "Bob")
bobs_dog = FactoryGirl.create(:dog, owner: owner_named_bob)
bobs_dog.owner
=> #<Owner:0x007f8e56d73a70 id: 1, name: "Bob", age: 32, email: "george@gmail.com">
```

###Different Kinds of Objects (aka [Inheritance](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Inheritance))

Let's say we're making a lot of tests that use old dogs, as well as a lot of tests that use default young dogs. Instead of needing to manually override "age" every time, we should create a special factory for old dogs!

We can make a new factory called `:old_dog` inside the `:dog` factory like so:

```
factory :dog do
  name "Fido"
  age 3
  owner

  factory :old_dog do
    age 12
  end
end
```

If we call `FactoryGirl.create(:old_dog)`, all of the default traits we set up in the normal `dog` factory will still be there, *except* the ones we explicitly override in the `old_dog` factory. Now we'll have a dog with an owner, the name "Fido", and the age 12.

###Factories that create lots of things (using [Callbacks](http://www.rubydoc.info/gems/factory_girl/file/GETTING_STARTED.md#Callbacks))

**Warning: you should be careful not to rely on this too heavily! Don't get lazy. This can be super useful, but there's a time and a place, and often your reader wants to see you create the objects you'll be using.**

Let's say a lot of my tests are dealing with an owner who has lots of dogs, and I'm getting tired of making so many dogs all the time. Let's put it in a factory!

```ruby
factory :owner do
  name "George"
  age 32
  email "george@gmail.com"

  factory :owner_with_dogs do
    # ?????
  end
end
```

Basically what we want to do is create a bunch of dogs after we've created this owner, and make sure all of the dogs belong to this owner. We can do this using callbacks:

```ruby
after(:create) do |owner|
  # do some stuff
end
```

If we put this inside our factory, after the owner has been created, any code we put inside this block will be executed. Let's finish our factory by creating three dogs:

```ruby
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
```
