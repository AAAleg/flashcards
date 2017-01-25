module CardHelper 
  def errors_cheking(card, text, message)
    expect(card.errors[text]).to include(message)
  end

  def check_translation(card, translation, param, result)
    check_result = card.check_translation(translation)
    expect(check_result[param]).to be result
  end
end
