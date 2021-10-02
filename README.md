# sec-edgar-sdk
A ruby sdk for data.sec.gov

#### SEC EDGAR API Docs: https://www.sec.gov/edgar/sec-api-documentation

## Installation

The gem can be installed with the following command:

`gem install sec-edgar-sdk`

Or add the gem to your Gemfile:

`gem 'sec-edgar-sdk'`

Running from the command prompt in irb:

`irb -r sec-edgar-sdk`

## Usage

#### SecEdgar::FullTextSearch

Perform Full Text Search queries like:

https://www.sec.gov/edgar/search/

![SEC Edgar Web Search](/documentation/images/FullTextSearchOnSecGov.png)

Similarly...

`search_result = SecEdgar::FullTextSearch.perform(keys_typed: 'BRK')`

When `search_result.success? # true`

Then `search_result.to_h` will look something like:

```ruby
{
  :took => 6,
  :timed_out => false,
  :_shards => {:total => 1, :successful => 1, :skipped => 0, :failed => 0},
  :hits =>
   {
     :total => {:value=>10, :relation=>"eq"},
     :max_score => 845.7282,
     :hits =>
        [
          {
            :_index => "edgar_entity_20211002_040316",
            :_type => "_doc",
            :_id => "1067983",
            :_score => 845.7282,
            :_source =>
            {
              :entity => "BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)",
              :entity_words => "BERKSHIRE HATHAWAY INC (BRK-B, BRK-A)",
              :tickers => "BRK-B, BRK-A",
              :rank => 59925561
            }
          },
          # ...
        ]
    }
}
```

### Tests
`bundle exec rspec`

### Contributing
Bug reports and pull requests are welcome here on GitHub!