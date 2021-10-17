require_relative '../spec_helper'

RSpec.describe SecEdgar::Submissions do
  describe '.fetch' do
    subject { described_class.fetch(cik: cik) }
    let(:cik) { '1067983' }

    let(:fetch_response) { subject.to_h }

    around do |example|
      VCR.use_cassette('submissions-brk') do
        example.run
      end
    end

    it { is_expected.to be_success }
    specify { expect(fetch_response).to be_a Hash }
    specify do
      expect(fetch_response).to match(
                                   hash_including(
                                     cik: '1067983',
                                     entityType: 'operating',
                                     sic: '6331',
                                     sicDescription: 'Fire, Marine & Casualty Insurance',
                                     insiderTransactionForOwnerExists: 1,
                                     insiderTransactionForIssuerExists: 1,
                                     name: 'BERKSHIRE HATHAWAY INC',
                                     tickers: ['BRK-A', 'BRK-B'],
                                     exchanges: ['NYSE', 'NYSE'],
                                     ein: '470813844',
                                     description: '',
                                     website: '',
                                     investorWebsite: '',
                                     category: 'Large accelerated filer',
                                     fiscalYearEnd: '1231',
                                     stateOfIncorporation: 'DE',
                                     stateOfIncorporationDescription: 'DE',
                                     addresses: {
                                       mailing: {
                                         street1: '3555 FARNAM STREET',
                                         street2: nil,
                                         city: 'OMAHA',
                                         stateOrCountry: 'NE',
                                         zipCode: '68131',
                                         stateOrCountryDescription: 'NE'
                                       },
                                       business: a_kind_of(Hash), # Same as mailing in this case
                                     },
                                     phone: '4023461400',
                                     flags: '',
                                     formerNames: array_including(
                                       hash_including(
                                         name: 'NBH INC',
                                         from: a_kind_of(String),
                                         to: a_kind_of(String)
                                       )
                                     ),
                                     filings: hash_including(
                                       recent: hash_including(
                                         accessionNumber: array_including(
                                           '0001209191-21-056883'
                                         )
                                       ),
                                     )
                                   )
                                 )
    end
  end
end
