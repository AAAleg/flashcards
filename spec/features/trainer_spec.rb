require 'rails_helper'
require 'support/helpers/login_helper.rb'
require 'support/helpers/trainer_helper.rb'
include LoginHelper
include TrainerHelper

update_review_date = ->(card){card.update_attribute(:review_date,
                                                     Time.now - 3.days) }

describe 'review cards without blocks' do
  it_behaves_like 'training without cards' do
    let(:user) { [:user] }
  end
end

describe 'review cards with one block' do
  it_behaves_like 'training without cards' do
    let(:user) { [:user_with_one_block_without_cards] }
  end

  describe 'training with two cards' do
    before do
      user = create(:user_with_one_block_and_two_cards)
      user.cards.each(&update_review_date)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it_behaves_like 'training with two cards'
  end

  describe 'training with one card' do
    before do
      user = create(:user_with_one_block_and_one_card)
      user.cards.each(&update_review_date)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it_behaves_like 'training with one card'

    it 'correct translation quality=3' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'House'
      click_button 'Проверить'
      expect(page).to have_content 'Текущая карточка'
    end

    it 'correct translation quality=4' do
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'RoR'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'House'
      click_button 'Проверить'
      fill_in 'user_translation', with: 'House'
      click_button 'Проверить'
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end
end

describe 'review cards with two blocks' do
  it_behaves_like 'training without cards' do
    let(:user) { [:user_with_two_blocks_without_cards] }
  end

  describe 'training with two cards' do
    before do
      user = create(:user_with_two_blocks_and_one_card_in_each)
      user.cards.each(&update_review_date)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it_behaves_like 'training with two cards'
  end

  describe 'training with one card' do
    before do
      user = create(:user_with_two_blocks_and_only_one_card)
      user.cards.each(&update_review_date)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it_behaves_like 'training with one card'
  end
end

describe 'review cards with current_block' do
  it_behaves_like 'training without cards' do
    let(:user) { [:user_with_two_blocks_without_cards, current_block_id: 1] }
  end
  
  describe 'training with two cards' do
    before do
      user = create(:user_with_two_blocks_and_two_cards_in_each)
      block = user.blocks.first
      user.set_current_block(block)
      card = user.cards.find_by(block_id: block.id)
      card.update_attribute(:review_date, Time.now - 3.days)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it_behaves_like 'training with two cards'
  end

  describe 'training with one card' do
    before do
      user = create(:user_with_two_blocks_and_one_card_in_each)
      block = user.blocks.first
      user.set_current_block(block)
      card = user.cards.find_by(block_id: block.id)
      card.update_attribute(:review_date, Time.now - 3.days)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it_behaves_like 'training with one card'
  end
end