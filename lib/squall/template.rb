module Squall
  # OnApp Template
  class Template < Base
    # Return a list of available Templates
    def list
      response = request(:get, '/templates.json')
      response.collect { |temp| temp['image_template'] }
    end

    # Make a Template public so that it can be downloaded
    # via a HTTP url
    def make_public(id)
      response = request(:post, "/templates/#{id}/make_public.json")
      response.first[1]
    end

    # Download a Template image
    def download(id)
      response = request(:get, "/templates.json?remote_template_id=#{id}")
    end
  end
end
