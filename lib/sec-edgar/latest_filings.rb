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
          entry['title_data'] = SecEdgar::Parsers::RSS.parse_title(entry['title'])

          entry['link'] = entry_node.css('link').attr('href').value
          entry['form'] = entry_node.css('category').attr('term').value

          entry['summary'] = entry_node.css('summary').text
          entry['summary_data'] = SecEdgar::Parsers::RSS.parse_summary(entry['summary'])

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

    # Fetch latest filings from SEC EDGAR
    # https://www.sec.gov/about/sec-rss
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
