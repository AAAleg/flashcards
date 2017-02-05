require 'super_memo'
require 'string_helper'


class CheckTranslation
  include StringHelper
  include Interactor

  def call
    distance = Levenshtein.distance(full_downcase(context.card.translated_text),
                                    full_downcase(context.user_translation))
    sm_hash = SuperMemo.algorithm(context.card.interval, context.card.repeat, context.card.efactor,
                                  context.card.attempt, distance, 1)

    if distance <= 1
      sm_hash.merge!({ review_date: Time.now + context.card.interval.to_i.days, attempt: 1 })
      context.card.update(sm_hash)
      if distance == 0
        context.message = I18n.t(:correct_translation_notice)
        context.key = :notice
      else
        context.message = I18n.t 'translation_from_misprint_alert',
                          user_translation: context.user_translation,
                          original_text: context.card.original_text,
                          translated_text: context.card.translated_text
        context.key = :alert
      end
    else
      sm_hash.merge!({ attempt: [context.card.attempt + 1, 5].min })
      context.card.update(sm_hash)
      context.message = I18n.t(:incorrect_translation_alert)
      context.key = :alert
      context.fail!
    end
  end
end
