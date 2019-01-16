require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
    students_info = []
    doc = Nokogiri::HTML(open(index_url))

    doc.css(".student-card").each do |student_card|
      student_hash = {}
      student_hash[:name] = student_card.css("h4").text
      student_hash[:location] = student_card.css("p").text
      student_hash[:profile_url] = student_card.css("a").attribute("href").value
      students_info << student_hash
    end
    students_info
  end

  def self.scrape_profile_page(profile_url)
    doc = Nokogiri::HTML(open(profile_url))
    social_hash = {}

    doc.css(".social-icon-container a").each do |container|
      if container.css("img").attribute("src").text.include?("rss")
        social_hash[:blog] = container.attributes["href"].value
      else
        link = container.attributes["href"].value
        social_hash[:twitter] = link if link.include?("twitter")
        social_hash[:linkedin] = link if link.include?("linkedin")
        social_hash[:github] = link if link.include?("github")
        #binding.pry
      end
      social_hash[:profile_quote] = doc.css(".profile-quote").text
      social_hash[:bio] = doc.css(".description-holder p").text
    end
    social_hash

  end

end

#Scraper.scrape_profile_page("fixtures/student-site/students/ryan-johnson.html")
