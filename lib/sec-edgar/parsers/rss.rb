module SecEdgar
  module Parsers
    class RSS
      def self.parse_title(title)
        form, remainder = title.split(" - ")
        name, cik, context = remainder.split(" (")
        cik.gsub!(')', '')
        context = context.gsub(')', '').gsub(' ', '_').downcase

        {
          'form' => form,
          'name' => name,
          'cik' => cik,
          'context' => context
        }
      rescue
        nil
      end

      def self.parse_summary(summary)
        summary = summary.gsub("\n ", '').gsub("\n", '')

        _filed_lbl, date_filed, _acc_no_lbl, accession_number, _size_lbl, size = summary.split('</b>').map(&:strip).map{|str| str.split(' <b>')}.flatten

        {
          'date_filed' => date_filed,
          'accession_number' => accession_number,
          'size' => size
        }
      rescue
        nil
      end
    end
  end
end
