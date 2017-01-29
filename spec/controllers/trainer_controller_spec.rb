require 'rails_helper'
require 'support/helpers/trainer_helper.rb'
include TrainerHelper

describe Dashboard::TrainerController do
  describe 'review_card' do
    before do
      @user = create(:user)
      @block = create(:block, user: @user)
      @controller.send(:auto_login, @user)
    end

    context 'correct translation' do
      it_behaves_like 'correct translation' do
        let(:card_factory) { [:card, user: @user, block: @block] }
        let(:expected_repeat) { 2 }
        let(:interval) { 1 }
        let(:expected_interval) { 6 }
        let(:efactors) { [2.6, 2.18, 1.5] }
      end

      # it_behaves_like 'correct translation' do
      #   let(:card_factory) { [:card, :second_check, user: @user, block: @block] }
      #   let(:expected_repeat) { 3 }
      #   let(:interval) { 6 }
      #   let(:expected_interval) { 16 }
      #   let(:efactors) { [2.7, 2.28, 1.6] }
      # end

      # it_behaves_like 'correct translation' do
      #   let(:card_factory) { [:card, :third_check, user: @user, block: @block] }
      #   let(:expected_repeat) { 4 }
      #   let(:interval) { 16 }
      #   let(:expected_interval) { 45 }
      #   let(:efactors) { [2.8, 2.38, 1.7] }
      # end      

      it 'repeat=1-3 quality=5' do
        card = create(:card, user: @user, block: @block,
                      interval: 1, repeat: 1, efactor: 2.5, quality: 5)
        card = check_review_card(card, 'house', 1)
        card.update(review_date: Time.zone.now)
        card = check_review_card(card, 'house', 1)
        card.update(review_date: Time.zone.now)
        card = check_review_card(card, 'house', 1)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 16.days).strftime('%Y-%m-%d %H:%M'))
        expect(card.interval).to eq(45)
        expect(card.repeat).to eq(4)
        expect(card.attempt).to eq(1)
        expect(card.efactor).to eq(2.8)
        expect(card.quality).to eq(5)
      end
    end

    context 'incorrect translation' do
      it_behaves_like 'incorrect translation' do
        let(:attempt) { 1 }
        let(:efactor) { 2.18 }
        let(:quality) { 2 }
      end

      it_behaves_like 'incorrect translation' do
        let(:attempt) { 2 }
        let(:efactor) { 1.64 }
        let(:quality) { 1 }
      end

      it_behaves_like 'incorrect translation' do
        let(:attempt) { 3 }
        let(:efactor) { 1.3 }
        let(:quality) { 0 }
      end
    end

    context 'correct and incorrect translation' do
      it 'repeat=1-3 quality=4' do
        card = create(:card, user: @user, block: @block,
                      interval: 1, repeat: 1, efactor: 2.5, quality: 4)
        card = check_review_card(card, 'house', 1)
        card.update(review_date: Time.zone.now)
        card = check_review_card(card, 'house', 1)
        card.update(review_date: Time.zone.now)
        card = check_review_card(card, 'RoR', 1)
        card = check_review_card(card, 'house', 1)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
        expect(card.interval).to eq(6)
        expect(card.repeat).to eq(2)
        expect(card.attempt).to eq(1)
        expect(card.efactor).to eq(2.38)
        expect(card.quality).to eq(4)
      end

      it 'repeat=1-3 quality=5' do
        card = create(:card, user: @user, block: @block,
                      interval: 1, repeat: 1, efactor: 2.5, quality: 4)
        card = check_review_card(card, 'house', 1)
        card.update(review_date: Time.zone.now)
        card = check_review_card(card, 'RoR', 1)
        card = check_review_card(card, 'house', 1)
        card.update(review_date: Time.zone.now)
        card = check_review_card(card, 'house', 1)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 6.days).strftime('%Y-%m-%d %H:%M'))
        expect(card.interval).to eq(14)
        expect(card.repeat).to eq(3)
        expect(card.attempt).to eq(1)
        expect(card.efactor).to eq(2.38)
        expect(card.quality).to eq(5)
      end

      it 'repeat=3 attempt=4' do
        card = create(:card, user: @user, block: @block,
                      interval: 16, repeat: 3, efactor: 2.7, quality: 5)
        card = check_review_card(card, 'RoR', 3)
        card = check_review_card(card, 'house', 1)
        expect(card.review_date.strftime('%Y-%m-%d %H:%M')).
            to eq((Time.zone.now + 1.days).strftime('%Y-%m-%d %H:%M'))
        expect(card.interval).to eq(6)
        expect(card.repeat).to eq(2)
        expect(card.attempt).to eq(1)
        expect(card.efactor).to eq(1.3)
        expect(card.quality).to eq(3)
      end
    end
  end
end