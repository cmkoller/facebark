require "rails_helper"

feature "View all Dogs", %q(
  As a user
  I want to view a list of all dogs on the site
  So I can pick the nicest dogs for my dog to befriend.
) do

  scenario "user views all dogs" do
    fido = FactoryGirl.create(:dog, name: "Fido")
    buster = FactoryGirl.create(:dog, name: "Buster")

    visit dogs_path

    expect(page).to have_content (fido.name)
    expect(page).to have_content (buster.name)
  end
end
