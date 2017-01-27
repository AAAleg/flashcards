require 'rails_helper'
require 'support/helpers/card_helper.rb'
include CardHelper

describe Card do
  it 'create card with empty original text' do
    expect { create(:card, :with_empty_original_text) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card with empty translated text' do
    expect { create(:card, :with_empty_translated_text) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card with empty texts' do
    expect { create(:card, :with_empty_texts) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'equal_texts Eng' do
    expect { create(:card, :with_equal_texts_eng) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'equal_texts Rus' do
    expect { create(:card, :with_equal_texts_rus) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'full_downcase Eng' do
    expect { create(:card, :full_downcase_eng) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'full_downcase Rus' do
    expect { create(:card, :full_downcase_rus) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card without user_id' do
    expect { create(:card, :without_user_id) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card witout block_id' do
    expect { create(:card, :without_block_id) }.to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card original_text OK' do
    expect(create(:card).original_text).to eq('дом')
  end

  it 'create card translated_text OK' do
    expect(create(:card).translated_text).to eq('house')
  end

  it 'create card errors OK' do
    expect(create(:card).errors.any?).to be false
  end

  it 'set_review_date OK' do
    expect(create(:card).review_date.strftime('%Y-%m-%d %H:%M')).
        to eq(Time.zone.now.strftime('%Y-%m-%d %H:%M'))
  end

  it 'check_translation Eng OK' do
    check_translation(create(:card), 'house', :state, true)
  end

  it 'check_translation Eng NOT' do
    check_translation(create(:card), 'RoR', :state, false)
  end

  it 'check_translation Rus OK' do
    check_translation(create(:card, :rus), 'дом', :state, true)
  end

  it 'check_translation Rus NOT' do
    check_translation(create(:card, :rus), 'RoR', :state, false)
  end

  it 'check_translation Eng OK levenshtein_distance' do
    check_translation(create(:card, :levenshtein_distance_1), 'house', :state, true)
  end

  it 'check_translation Eng OK levenshtein_distance=1' do
    check_translation(create(:card, :levenshtein_distance_1), 'house', :distance, 1)
  end

  it 'check_translation Rus OK levenshtein_distance' do
    check_translation(create(:card, :rus_levenshtein_distance_1), 'дом', :state, true)
  end

  it 'check_translation Rus OK levenshtein_distance=1' do
    check_translation(create(:card, :rus_levenshtein_distance_1), 'дом',:distance, 1)
  end

  it 'check_translation Eng NOT levenshtein_distance=2' do
    check_translation(create(:card, :levenshtein_distance_2), 'RoR', :state, false)
  end

  it 'check_translation Rus NOT levenshtein_distance=2' do
    check_translation(create(:card, :rus_levenshtein_distance_2), 'RoR', :state, false)
  end
end
