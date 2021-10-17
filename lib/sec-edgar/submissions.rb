# frozen_string_literal: true

module SecEdgar
  class Submissions
    include HTTParty
    base_uri 'https://data.sec.gov'

    # Fetch a given entity's current filing(submission) history.
    #
    # @cik [String] An entity's Central Index Key (CIK).
    # Leading zeros are optional - they'll be added when necessary.
    # 
    # 2021-10-17 From https://www.sec.gov/edgar/sec-api-documentation :
    # 
    # data.sec.gov/submissions/
    # Each entity’s current filing history is available at the following URL:
    #
    # https://data.sec.gov/submissions/CIK##########.json
    # Where the ########## is the entity’s 10-digit Central Index Key (CIK),
    # including leading zeros.
    #
    # This JSON data structure contains metadata such as current name, former
    # name, and stock exchanges and ticker symbols of publicly-traded companies.
    # The object’s property path contains at least one year’s of filing or to
    # 1,000 (whichever is more) of the most recent filings in a compact columnar
    # data array. If the entity has additional filings, files will contain an
    # array of additional JSON files and the date range for the filings each one
    # contains.
    #
    def self.fetch(cik:)
      unless ENV['SEC_EDGAR_USER_AGENT'].present?
        raise StandardError, "SEC_EDGAR_USER_AGENT not set!"
      end

      response = get(
        "/submissions/CIK#{cik.rjust(10, '0')}.json",
        headers: {
          'User-Agent' => ENV['SEC_EDGAR_USER_AGENT'],
          'Accept-Encoding' => 'gzip, deflate',
          'Host' => 'data.sec.gov'
        }
      )

      ClientResult.new(response)
    end
  end
end
