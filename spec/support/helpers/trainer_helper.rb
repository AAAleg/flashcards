module TrainerHelper
  def create_and_check_review_card(user, block, repeat, translate)
    card = create(:card, user: user, block: block, repeat: repeat)
    put :review_card, params: { card_id: card.id, user_translation: translate }
    Card.find(card.id)
  end

  def check_review_card(card, translate, number)
    number.times {
      put :review_card, params: { card_id: card.id, 
                                  user_translation: translate }
    }
    Card.find(card.id)
  end

  def prepare(user_factory)
    user = create(user_factory)
    user.cards.each do |card|
      card.update_attribute(:review_date, Time.now - 3.days)
    end
    visit trainer_path
    login('test@test.com', '12345', 'Войти')
  end

  def prepare_for_current_block(user_factory)
    user = create(user_factory)
    block = user.blocks.first
    user.set_current_block(block)
    card = user.cards.find_by(block_id: block.id)
    card.update_attribute(:review_date, Time.now - 3.days)
    visit trainer_path
    login('test@test.com', '12345', 'Войти')
  end
end

shared_examples 'training without cards' do
  describe 'training without cards' do
    before do
      create(*user)
      visit trainer_path
      login('test@test.com', '12345', 'Войти')
    end

    it 'no cards' do
      expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
    end
  end
end

shared_examples 'training with two cards' do
  it 'first visit' do
    expect(page).to have_content 'Оригинал'
  end

  it 'incorrect translation' do
    fill_in 'user_translation', with: 'RoR'
    click_button 'Проверить'
    expect(page)
      .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели верный перевод. Продолжайте.'
  end

  it 'correct translation distance=1' do
    fill_in 'user_translation', with: 'hous'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели перевод c опечаткой.'
  end

  it 'incorrect translation distance=2' do
    fill_in 'user_translation', with: 'hou'
    click_button 'Проверить'
    expect(page)
      .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end
end

shared_examples 'training with one card' do
  it 'incorrect translation' do
    fill_in 'user_translation', with: 'RoR'
    click_button 'Проверить'
    expect(page)
      .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end

  it 'incorrect translation distance=2' do
    fill_in 'user_translation', with: 'hou'
    click_button 'Проверить'
    expect(page)
      .to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation distance=1' do
    fill_in 'user_translation', with: 'hous'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели перевод c опечаткой.'
  end
end

shared_examples 'incorrect translation' do
  it 'repeat=1 attempt=' do
    card = create(:card, user: @user, block: @block, quality: 4)
    card = check_review_card(card, 'RoR', attempt)
    expect(card.interval).to eq(1)
    expect(card.repeat).to eq(1)
    expect(card.attempt).to eq(attempt + 1)
    expect(card.efactor).to eq(efactor)
    expect(card.quality).to eq(quality)
  end
end

shared_examples 'correct translation' do
  it 'repeat=1 quality=5' do
    card = create(*card_factory)
    card = check_review_card(card, 'house', 1)
    expect(card.review_date.strftime('%Y-%m-%d %H:%M'))
      .to eq((Time.zone.now + interval.days).strftime('%Y-%m-%d %H:%M'))
    expect(card.interval).to eq(expected_interval)
    expect(card.repeat).to eq(expected_repeat)
    expect(card.attempt).to eq(1)
  end

  it 'repeat=1 quality=5' do
    card = create(*card_factory)
    card = check_review_card(card, 'house', 1)
    expect(card.efactor).to eq(efactors.first)
    expect(card.quality).to eq(5)
  end

  it 'repeat=1 quality=4' do
    card = create(*card_factory)
    card = check_review_card(card, 'RoR', 1)
    card = check_review_card(card, 'house', 1)
    expect(card.efactor).to eq(efactors.second)
    expect(card.quality).to eq(4)
  end

  it 'repeat=1 quality=3' do
    card = create(*card_factory)
    card = check_review_card(card, 'RoR', 3)
    card = check_review_card(card, 'house', 1)
    expect(card.efactor).to eq(1.3)
    expect(card.quality).to eq(3)
  end
end
