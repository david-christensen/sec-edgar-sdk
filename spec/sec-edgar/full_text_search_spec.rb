require_relative '../spec_helper'

RSpec.describe SecEdgar::FullTextSearch do
  describe '.perform' do
    subject { described_class.perform(keys_typed: keys_typed, narrow: narrow) }
    let(:keys_typed) { 'BRK' }
    let(:narrow) { nil }

    let(:search_response) { subject.to_h }

    it { is_expected.to be_success }

    specify { expect(search_response).to be_a Hash }
  end
end
