require "rails_helper"

feature "View all Dogs", %q(
  As a user
  I want to view a list of all dogs on the site
  So I can pick the nicest dogs for my dog to befriend.
) do

  scenario "user views all dogs" do
    owner = Owner.create(name: "George", email: "george@gmail.com")
    fido = Dog.create(name: "Fido",
      age: 3,
      avatar_url:  "http://27.media.tumblr.com/tumblr_ls6tpnEwe71r3ip8io1_500.jpg",
      owner: owner)
    buster = Dog.create(name: "Buster",
      age: 6,
      avatar_url:  "http://placepu.gs/500/350",
      owner: owner)
    visit dogs_path

    expect(page).to have_content (fido.name)
    expect(page).to have_content (buster.name)
  end

end
