module Squall
  class Template < Base
    def list
      response = request(:get, '/templates.json')
      response.collect { |temp| temp['image_template'] }
    end
  end
end
