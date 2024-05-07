# frozen_string_literal: true

module SecEdgar
  class FullTextSearch
    include HTTParty
    base_uri 'https://efts.sec.gov'

    # Performs a text search using the EDGAR Full Text Search API
    #
    # @keys_typed [String] The search term to use in the search query.
    # @narrow [Boolean] Whether or not to narrow the search results.
    # The Company Search Page seems to use this control parameter.
    # https://www.sec.gov/edgar/searchedgar/companysearch.html
    #
    def self.perform(keys_typed:, narrow: false)
      unless ENV['SEC_EDGAR_USER_AGENT'].present?
        raise StandardError, "SEC_EDGAR_USER_AGENT not set!"
      end

      response = post(
        '/LATEST/search-index',
        headers: {
          'Content-Type': 'application/json',
          'User-Agent' => ENV['SEC_EDGAR_USER_AGENT'],
          'Accept-Encoding' => 'gzip, deflate',
          'Host' => 'efts.sec.gov'
        },
        body: {
          keysTyped: keys_typed,
          narrow: narrow
        }.compact.to_json
      )

      ClientResult.new(response)
    end
  end
end
