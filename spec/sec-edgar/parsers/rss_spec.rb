require_relative '../../spec_helper'

RSpec.describe SecEdgar::Parsers::RSS do
  describe '.parse_title' do
    subject { described_class.parse_title(title) }

    xcontext 'when title is for a subject with (Group) in the middle' do
      let(:title) { 'F-6EF - Sunny Optical Technology (Group) Co Limited/ADR (0001601992) (Subject)' }

      it 'parses cik' do
        expect(subject['cik']).to eq('0001601992')
        expect(subject['context']).to eq('subject')
        expect(subject['form']).to eq('F-6EF')
        expect(subject['name']).to eq('Sunny Optical Technology (Group) Co Limited/ADR')
      end
    end

    xcontext 'when title has multiple dashes' do
      let(:title) { '"F-6EF - JPMorgan Chase Bank, N.A. - ADR Depositary (0001474274) (Filed by)' }

      it 'parses cik' do
        expect(subject['cik']).to eq('0001474274')
        expect(subject['context']).to eq('filed_by')
        expect(subject['form']).to eq('F-6EF')
        expect(subject['name']).to eq('JPMorgan Chase Bank, N.A. - ADR Depositary')
      end
    end

    context 'when title is for a filer' do
      let(:title) { '6-K - Lloyds Banking Group plc (0001160106) (Filer)' }

      it 'parses cik' do
        expect(subject['cik']).to eq('0001160106')
        expect(subject['context']).to eq('filer')
        expect(subject['form']).to eq('6-K')
        expect(subject['name']).to eq('Lloyds Banking Group plc')
      end
    end
  end
end