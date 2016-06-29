require 'rails_helper'

RSpec.feature "User Adds Supply To Carts" do
  scenario "cart has supply that user added" do
    family = create(:family)
    supply = create(:supply)
    supply_item = create(:supply_item)

    visit family_path(family)

    within(".Twin") do
      select  1, from: "supply_item[quantity]"
      find(:button, "add to cart").click
    end

    visit cart_index_path

    expect(page).to have_content("Twin")
  end
end
