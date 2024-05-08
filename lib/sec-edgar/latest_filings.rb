# frozen_string_literal: true

module SecEdgar
  class LatestFilings
    include HTTParty
    base_uri 'https:/www.sec.gov'


    class Parser::Atom < HTTParty::Parser
      SupportedFormats.merge!({"application/atom+xml" => :atom})
  
      protected
  
      # perform atom parsing on body
      def atom
        # Parse the body content using Nokogiri
        xml_doc = Nokogiri::XML(body)

        # Initialize an empty array to store parsed entries
        entries = []

        # Extract each entry from the Atom feed
        xml_doc.css('entry').each do |entry_node|
          entry = {}
          entry['title'] = entry_node.css('title').text

          begin
            form, remainder = entry['title'].split(" - ")
            name, cik, context = remainder.split(" (")
            cik.gsub!(')', '')
            context = context.gsub(')', '').gsub(' ', '_').downcase

            entry['title_data'] = {
              'form' => form,
              'name' => name,
              'cik' => cik,
              'context' => context
            }
          rescue
            entry['title_data'] = nil
          end

          entry['link'] = entry_node.css('link').attr('href').value
          entry['form'] = entry_node.css('category').attr('term').value

          entry['summary'] = entry_node.css('summary').text

          begin
            summary = entry['summary'].gsub("\n ", '').gsub("\n", '')
  
            _filed_lbl, date_filed, _acc_no_lbl, accession_number, _size_lbl, size = entry['summary'].split('</b>').map(&:strip).map{|str| str.split(' <b>')}.flatten
  
            entry['summary_data'] = {
              'date_filed' => date_filed,
              'accession_number' => accession_number,
              'size' => size
            }
          rescue
            entry['summary_data'] = nil
          end

          entry['updated'] = entry_node.css('updated').text
          entry['id'] = entry_node.css('id').text
          entries << entry
        end

        # Return the parsed feed
        {
          'title' => xml_doc.css('title').first&.text,
          'author' => {
            'name' => xml_doc.css('author name').text,
            'email' => xml_doc.css('author email').text,
          },
          'entries' => entries,
          'updated' => xml_doc.css('updated').first&.text
        }
      end
    end
  
    parser Parser::Atom

    # Fetch a given entity's current filing(submission) history.
    #
    # @cik [String] An entity's Central Index Key (CIK).
    # Leading zeros are optional - they'll be added when necessary.
    # CIK=&type=&company=&dateb=&owner=include&start=2000&count=100&output=atom
    # 
    # 2021-10-17 https://www.sec.gov/about/sec-rss
    def self.fetch(cik: nil, type: nil, company: nil, dateb: nil, owner: 'include', start: 0, count: 100, output: 'atom')
      unless ENV['SEC_EDGAR_USER_AGENT'].present?
        raise StandardError, "SEC_EDGAR_USER_AGENT not set!"
      end

      options = {
        query: {
          action: 'getcurrent',
          CIK: cik,
          type: type,
          company: company,
          dateb: dateb,
          owner: owner,
          start: start,
          count: count,
          output: output
        },
        headers: {
          'User-Agent' => ENV['SEC_EDGAR_USER_AGENT'],
          'Host' => 'www.sec.gov'
        }
      }

      response = get("https://www.sec.gov/cgi-bin/browse-edgar", options)

      ClientResult.new(response)
    end
  end
end
