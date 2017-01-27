module CardHelper 
  def check_translation(card, translation, param, result)
    check_result = card.check_translation(translation)
    expect(check_result[param]).to be result
  end
end
