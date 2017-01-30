FactoryGirl.define do
  factory :card do
    original_text 'дом'
    translated_text 'house'
    interval 1
    repeat 1
    efactor 2.5
    quality 5
    attempt 1
    user_id 1
    block_id 1

    trait :rus do
      original_text 'house'
      translated_text 'дом'
    end

    trait :rus_levenshtein_distance_1 do
      original_text 'house'
      translated_text 'до'
    end

    trait :rus_levenshtein_distance_2 do
      original_text 'house'
      translated_text 'д'
    end

    trait :with_empty_original_text do
      original_text ''
    end

    trait :with_empty_translated_text do
      translated_text ''
    end

    trait :with_empty_texts do
      original_text ''
      translated_text ''
    end

    trait :with_equal_texts_rus do
      original_text 'дом'
      translated_text 'дом'
    end

    trait :with_equal_texts_eng do
      original_text 'house'
      translated_text 'house'
    end

    trait :full_downcase_eng do
      original_text 'hOuse'
      translated_text 'housE'
    end

    trait :full_downcase_rus do
      original_text 'дОм'
      translated_text 'доМ'
    end

    trait :without_user_id do
      user_id nil
    end

    trait :without_block_id do
      block_id nil
    end

    trait :levenshtein_distance_1 do
      translated_text 'hous'
    end

    trait :levenshtein_distance_2 do
      translated_text 'hou'
    end

    trait :second_check do
      interval 6
      repeat 2
      efactor 2.6
    end
  end
end