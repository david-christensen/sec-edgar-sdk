require_relative '../spec_helper'

RSpec.describe SecEdgar::FullTextSearch do
  describe '.perform' do
    subject { described_class.perform(keys_typed: keys_typed, narrow: narrow) }
    let(:keys_typed) { 'BRK' }
    let(:narrow) { nil }

    let(:search_response) { subject.to_h }

    around do |example|
      VCR.use_cassette('efts-brk') do
        example.run
      end
    end

    it { is_expected.to be_success }
    specify { expect(search_response).to be_a Hash }
    specify do
      expect(search_response).to match(
                                   hash_including(
                                     took: a_kind_of(Integer),
                                     timed_out: false,
                                     _shards: { total: 1, successful: 1, skipped: 0, failed: 0 },
                                     hits: hash_including(
                                       total: { value: a_kind_of(Integer), relation: 'eq' },
                                       hits: array_including(
                                         hash_including(
                                           _index: a_kind_of(String),
                                           _type: a_kind_of(String),
                                           _id: a_kind_of(String),
                                           _score: a_kind_of(Float),
                                           _source: a_kind_of(Hash)
                                         )
                                       )
                                     )
                                   )
                                 )
    end
  end
end
