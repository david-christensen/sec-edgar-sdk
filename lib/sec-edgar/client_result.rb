module SecEdgar
  class ClientResult
    def initialize(response)
      @response = response
    end

    def to_h
      JSON.parse(response.body).deep_symbolize_keys
    end

    delegate_missing_to :response

    private

    attr_reader :response
  end
end
