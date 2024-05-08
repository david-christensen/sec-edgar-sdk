module SecEdgar
  module Parsers
    class RSS
      def self.parse_title(title)
        form_end = title.index(' - ')
        form = title[0..form_end].strip
        remainder = title[form_end+3..-1]

        context_start = remainder.rindex('(')
        context_end = remainder.rindex(')')
        context = remainder[context_start+1..context_end-1].gsub(' ', '_').downcase
        
        remainder = remainder[0..context_start-1].strip

        cik_start = remainder.rindex('(')
        cik_end = remainder.rindex(')')
        cik = remainder[cik_start+1..cik_end-1]

        name = remainder[0..cik_start-1].strip

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
