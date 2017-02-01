require 'rails_helper'
require 'support/helpers/check_translation_helper'
include CheckTranslationHelper

describe CheckTranslation do
  it 'check_translation Eng OK' do
    check_translation(create(:card), 'house', :success?, true)
  end

  it 'check_translation Eng NOT' do
    check_translation(create(:card), 'RoR', :success?, false)
  end

  it 'check_translation Rus OK' do
    check_translation(create(:card, :rus), 'дом', :success?, true)
  end

  it 'check_translation Rus NOT' do
    check_translation(create(:card, :rus), 'RoR', :success?, false)
  end

  it 'check_translation Eng OK levenshtein_distance' do
    check_translation(create(:card, :levenshtein_distance_1), 'house', 
                      :success?, true)
  end

  it 'check_translation Eng OK levenshtein_distance=1' do
    check_translation(create(:card, :levenshtein_distance_1), 'house', 
                      :distance, 1)
  end

  it 'check_translation Rus OK levenshtein_distance' do
    check_translation(create(:card, :rus_levenshtein_distance_1), 'дом', 
                      :success?, true)
  end

  it 'check_translation Rus OK levenshtein_distance=1' do
    check_translation(create(:card, :rus_levenshtein_distance_1), 'дом',
                      :distance, 1)
  end

  it 'check_translation Eng NOT levenshtein_distance=2' do
    check_translation(create(:card, :levenshtein_distance_2), 'RoR', 
                      :success?, false)
  end

  it 'check_translation Rus NOT levenshtein_distance=2' do
    check_translation(create(:card, :rus_levenshtein_distance_2), 'RoR', 
                      :success?, false)
  end
end
