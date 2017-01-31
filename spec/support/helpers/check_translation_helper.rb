module CheckTranslationHelper 
  def check_translation(card, translation, param, result)
    check_result = CheckTranslation.call(
      card: card,
      translated_text: translation
    )
    expect(check_result.send(param)).to be result
  end
end
