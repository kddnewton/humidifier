# frozen_string_literal: true

module Humidifier
  class Upgrade
    URL = 'https://docs.aws.amazon.com/AWSCloudFormation/latest' \
          '/UserGuide/cfn-resource-specification.html'

    file = 'CloudFormationResourceSpecification.json'
    PATH = File.expand_path(File.join('..', '..', file), __dir__)

    def perform
      require 'net/http'
      require 'nokogiri'

      response = Net::HTTP.get_response(uri).body
      parsed = JSON.parse(response)

      File.write(PATH, JSON.pretty_generate(parsed))
      parsed['ResourceSpecificationVersion']
    end

    def self.perform
      new.perform
    end

    private

    def page
      Net::HTTP.get_response(URI.parse(URL)).body
    end

    def uri
      Nokogiri::HTML(page).css('table tr').detect do |tr|
        name = tr.at_css('td:first-child p')
        next if !name || name.text.strip != 'US East (N. Virginia)'

        break URI.parse(tr.at_css('td:nth-child(3) p a').attr('href'))
      end
    end
  end
end
