require 'super_memo'
require 'string_helper'
include StringHelper

class CheckTranslation
	include Interactor

  def call
    card = context.card
    distance = Levenshtein.distance(full_downcase(card.translated_text),
                                    full_downcase(context.translated_text))
    sm_hash = SuperMemo.algorithm(card.interval, card.repeat, card.efactor, 
                                  card.attempt, distance, 1)

    if distance <= 1
      sm_hash.merge!({ review_date: Time.now + card.interval.to_i.days, attempt: 1 })
      card.update(sm_hash)
      context.distance = distance
    else
      sm_hash.merge!({ attempt: [card.attempt + 1, 5].min })
      card.update(sm_hash)
      context.distance = distance
      context.fail!
    end
  end
end
