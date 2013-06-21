module Squall
  # OnApp Template
  class Template < Base
    # Public: Lists available templates.
    #
    # Returns an Array.
    def list
      response = request(:get, '/templates.json')
      response.collect { |temp| temp['image_template'] }
    end

    # Public: Make a Template public so that it can be downloaded via a HTTP
    # URL.
    #
    # id - ID of template
    #
    # Returns a Hash.
    def make_public(id)
      response = request(:post, "/templates/#{id}/make_public.json")
      response.first[1]
    end
  end
end
