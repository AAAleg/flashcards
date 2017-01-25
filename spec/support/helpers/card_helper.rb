module CardHelper
  def errors_cheking(original_text, translated_text, user_id, block_id, text, message)
    card = Card.create(original_text: original_text, translated_text: translated_text, 
                       user_id: user_id, block_id: block_id)
    expect(card.errors[text]).to include(message)
  end
end