require_relative '../spec_helper'

RSpec.describe SecEdgar::LatestFilings do
  describe '.fetch' do
    context 'when fetching all latest filings' do
      around do |example|
        VCR.use_cassette('latest-filings-all') do
          example.run
        end
      end

      subject { described_class.fetch }
      let(:fetch_response) { subject.to_h }

      it { is_expected.to be_success }
      specify { expect(fetch_response).to be_a Hash }
      it 'returns a successful response' do
        expect(fetch_response).to match(
          hash_including(
            title: a_kind_of(String),
            author: a_kind_of(Hash),
            entries: array_including(
              hash_including(
                title: a_kind_of(String),
                title_data: a_kind_of(Hash),
                link: a_kind_of(String),
                form: a_kind_of(String),
                summary: a_kind_of(String),
                summary_data: a_kind_of(Hash),
                updated: a_kind_of(String),
                id: a_kind_of(String)
              )
            ),
          )
        )
      end
    end

    context 'when fetching latest filings for BRK' do
      subject { described_class.fetch(cik: cik) }
      let(:cik) { '1067983' }
  
      let(:fetch_response) { subject.to_h }
  
      around do |example|
        VCR.use_cassette('latest-filings-brk') do
          example.run
        end
      end
  
      it { is_expected.to be_success }
      specify { expect(fetch_response).to be_a Hash }
      specify do
        expect(fetch_response).to match(
          hash_including(
            title: a_kind_of(String),
            author: a_kind_of(Hash),
            entries: array_including(
              hash_including(
                title: a_kind_of(String),
                title_data: a_kind_of(Hash),
                link: a_kind_of(String),
                form: a_kind_of(String),
                summary: a_kind_of(String),
                summary_data: a_kind_of(Hash),
                updated: a_kind_of(String),
                id: a_kind_of(String)
              )
            ),
          )
        )

        expect(fetch_response[:entries].all? { |entry| entry[:title_data][:cik] == cik.rjust(10, '0') }).to be(true)
      end
    end

    context 'when paging through latest filings' do
      let(:page_one) { described_class.fetch(start: 0, count: 100) }
      let(:page_two) { described_class.fetch(start: 1, count: 100) }
      let(:page_three) { described_class.fetch(start: 2, count: 100) }
      let(:pages) { [page_one, page_two, page_three] }

      around do |example|
        VCR.use_cassette('latest-filings-3-pages') do
          example.run
        end
      end

      it { pages.each { |page| expect(page).to be_success } }
      specify { pages.each { |page| expect(page.to_h).to be_a Hash } }
      it '3 pages of 100 should equal 300 entries' do
        expect(pages.map { |page| page.to_h[:entries].count }.sum).to eq(300)
      end

      it 'the first page should have a greater updated date than the last page' do
        page_one_updated = DateTime.parse(page_one.to_h[:entries].first[:updated])
        page_three_updated = DateTime.parse(page_three.to_h[:entries].last[:updated])
        expect(page_one_updated).to be > page_three_updated
      end
    end

    context 'when page does not exist' do
      subject { described_class.fetch(start: 2500) } # 2100 seems to be the max, by observation

      around do |example|
        VCR.use_cassette('latest-filings-page-dne') do
          example.run
        end
      end

      it { is_expected.to be_service_unavailable }

      specify { expect(subject.to_h[:code]).to eq(503) }
      specify { expect(subject.to_h[:body]).to be_a String }
      specify { expect(subject.to_h).to be_a Hash }
    end
  end
end
