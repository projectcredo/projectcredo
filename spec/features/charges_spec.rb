require 'rails_helper'
require 'stripe_mock'

describe 'charges page' do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  it 'shows simple payment page' do
    visit new_charges_path
    expect(page.body).to include('Amount')
  end

  it 'can make a simple payment', type: :request do
    post charges_path, params: {
      stripeToken: stripe_helper.generate_card_token,
      stripeEmail: 'test@email.com',
    }
    expect(response.status).to eq 302
    expect(flash[:alert]).not_to be_present
    expect(flash[:notice]).to be_present
  end

  describe 'subscriptions' do
    before do
      @user = create(:user)
      @plan = create(:plan)
      @stripe_plan = stripe_helper.create_plan(:id => @plan.stripe_id, :amount => 5)
      login_as(@user, :scope => :user)
    end

    it 'show subscriptios page' do
      visit subscriptions_charges_path
      expect(page.body).to include(@plan.name)
    end

    it 'can subscribe to a plan', type: :request do
      post subscribe_charges_path, params: {
        stripe_token: stripe_helper.generate_card_token,
        plan_id: @plan.id,
      }
      expect(response.status).to eq 302
      expect(flash[:alert]).not_to be_present
      expect(flash[:notice]).to be_present
    end

    it 'can cancel subscription', type: :request do
       post subscribe_charges_path, params: {
        stripe_token: stripe_helper.generate_card_token,
        plan_id: @plan.id,
      }
      get subscriptions_charges_path
      expect(response.body).to include(@plan.name)
      expect(response.body).to include('Cancel')

      get unsubscribe_charges_path
      expect(response.status).to eq 302
      expect(flash[:alert]).not_to be_present
      expect(flash[:notice]).to be_present
    end
  end

end
