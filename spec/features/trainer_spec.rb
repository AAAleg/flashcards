require 'rails_helper'
require 'support/helpers/login_helper.rb'
require 'support/helpers/trainer_helper.rb'
include LoginHelper
include TrainerHelper

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
      prepare(:user_with_one_block_and_two_cards)
    end

    it_behaves_like 'training with two cards'
  end

  describe 'training with one card' do
    before do
      prepare(:user_with_one_block_and_one_card)
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
      prepare(:user_with_two_blocks_and_one_card_in_each)
    end

    it_behaves_like 'training with two cards'
  end

  describe 'training with one card' do
    before do
      prepare(:user_with_two_blocks_and_only_one_card)
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
      prepare_for_current_block(:user_with_two_blocks_and_two_cards_in_each)
    end

    it_behaves_like 'training with two cards'
  end

  describe 'training with one card' do
    before do
      prepare_for_current_block(:user_with_two_blocks_and_one_card_in_each)
    end

    it_behaves_like 'training with one card'
  end
end
