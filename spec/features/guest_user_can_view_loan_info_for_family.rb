require 'rails_helper'

RSpec.feature "user can view loan info for family" do
  scenario "user visits loan page from family page" do

    family = create(:family)
    loan = create(:loan)

    visit family_path(family)

    expect(page).to have_content "This family has requested a loan."

    click_on "View Loan"

    expect(current_path).to eq(loan_path(loan))
    expect(page).to         have_content loan.description
    expect(page).to         have_content loan.requested_amount
    expect(page).to         have_content loan.name
  end
end