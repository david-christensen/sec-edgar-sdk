module SecEdgar
  class ClientResult
    def initialize(response)
      @response = response
    end

    def to_h
      return {
        body: response.body,
        code: response.code,
        headers: response.headers.deep_symbolize_keys
      } if response&.headers["content-type"]&.include?('html')

      return JSON.parse(response.body).deep_symbolize_keys unless response&.headers["content-type"]&.include?('xml')
      
      response&.to_h&.deep_symbolize_keys || {}
    end

    delegate_missing_to :response

    private

    attr_reader :response
  end
end
