class FoodAdditiveService
  require 'nokogiri'
  require 'open-uri'
  SOURCE_URL = ENV['SOURCE_URL'].freeze

  class << self

    def call(additive_name = nil)
      return unless additive_name.present?

      additive.name = additive_name
      additive.source = "#{ENV['SOURCE_URL']}#{additive.name}"
      additive.about = data.css(".content p").first.content
      additive.category = data.css(".categories a").first.content
      if data.css(".danger a").first.content == "низкая" ||
         data.css(".danger a").first.content == "очень низкая"
            additive.danger = 0
      elsif data.css(".danger a").first.content == "высокая" ||
            data.css(".danger a").first.content == "очень высокая"
            additive.danger = 2
      else
            additive.danger = 1
      end
      additive
    end

    private

    def data
      @data ||= Nokogiri::HTML(open("#{additive.source}"))
    end

    def additive
      @additive ||= FoodAdditive.new
    end
  end
end
