require 'rails_helper'

describe Card do
  it 'create card with empty original text' do
    expect { create(:card, :with_empty_original_text) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card with empty translated text' do
    expect { create(:card, :with_empty_translated_text) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card with empty texts' do
    expect { create(:card, :with_empty_texts) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'equal_texts Eng' do
    expect { create(:card, :with_equal_texts_eng) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'equal_texts Rus' do
    expect { create(:card, :with_equal_texts_rus) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'full_downcase Eng' do
    expect { create(:card, :full_downcase_eng) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'full_downcase Rus' do
    expect { create(:card, :full_downcase_rus) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card without user_id' do
    expect { create(:card, :without_user_id) }
      .to raise_error(ActiveRecord::RecordInvalid)
  end

  it 'create card witout block_id' do
    expect { create(:card, :without_block_id) }
      .to raise_error(ActiveRecord::RecordInvalid)
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
    expect(create(:card).review_date.strftime('%Y-%m-%d %H:%M'))
      .to eq(Time.zone.now.strftime('%Y-%m-%d %H:%M'))
  end
end
