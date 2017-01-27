module TrainerHelper
  def create_and_check_review_card(user, block, repeat, translate)
    card = create(:card, user: user, block: block, repeat: repeat)
    put :review_card, params: { card_id: card.id, user_translation: translate }
    Card.find(card.id)
  end

  def check_review_card(card, translate, number)
    number.times {
      put :review_card, params:{ card_id: card.id, user_translation: translate }
    }
    Card.find(card.id)
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
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
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
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end
end

shared_examples 'training with one card' do
  it 'incorrect translation' do
    fill_in 'user_translation', with: 'RoR'
    click_button 'Проверить'
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation' do
    fill_in 'user_translation', with: 'house'
    click_button 'Проверить'
    expect(page).to have_content 'Ожидайте наступления даты пересмотра.'
  end

  it 'incorrect translation distance=2' do
    fill_in 'user_translation', with: 'hou'
    click_button 'Проверить'
    expect(page).
        to have_content 'Вы ввели не верный перевод. Повторите попытку.'
  end

  it 'correct translation distance=1' do
    fill_in 'user_translation', with: 'hous'
    click_button 'Проверить'
    expect(page).to have_content 'Вы ввели перевод c опечаткой.'
  end
end