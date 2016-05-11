require 'rails_helper'

describe Fae::BaseModelConcern do

  describe '#to_csv' do
    context 'when to_csv is run' do
      it 'it should return a csv with the correct data items' do
        release1 = FactoryGirl.create(:release, id: 1, release_date: Date.today)
        @items = Release.for_fae_index
        @csv = CSV.parse(@items.to_csv)
        expect(@csv.first) == Release.column_names

        Release.column_names.each do |field|
          if release1[field].present?
            expect(@csv.second).to include(release1[field].to_s)
          end
        end

      end
    end
  end

  describe '#fae_nested_parent' do
    context 'when defined in a model' do
      it 'should return a symbol' do
        aroma = FactoryGirl.build(:aroma)
        expect(aroma.fae_nested_parent).to eq(:release)
      end
    end

    context 'when not defined in a model' do
      it 'should return nil' do
        release = FactoryGirl.build(:release)
        expect(release.fae_nested_parent).to eq(nil)
      end
    end
  end

  describe '#fae_nested_foreign_key' do
    context 'when #fae_nested_parent is defined in a model' do
      it 'should return a foreign key' do
        aroma = FactoryGirl.build(:aroma)
        expect(aroma.fae_nested_foreign_key).to eq('release_id')
      end
    end

    context 'when #fae_nested_parent is not defined in a model' do
      it 'should return nil' do
        release = FactoryGirl.build(:release)
        expect(release.fae_nested_foreign_key).to eq(nil)
      end
    end
  end

end