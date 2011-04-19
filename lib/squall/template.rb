module Squall
  class Template < Base
    def list
      response = request(:get, '/templates.json')
      response.collect { |temp| temp['image_template'] }
    end

    def make_public(id)
      response = request(:post, "/templates/#{id}/make_public.json")
      response.first[1]
    end

    def download(id)
      response = request(:get, "/templates.json?remote_template_id=#{id}")
    end
  end
end
