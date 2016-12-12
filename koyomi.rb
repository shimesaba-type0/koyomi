# coding: utf-8
#

require 'open-uri'
require 'csv'
require 'nokogiri'

master_url = 'https://moonlabo.com/cgi-bin/cln/cln_clm.cgi?OpDv=usd'

# urls = [1910, 1920, 1930, 1940, 1950, 1960, 1970, \
#         1980, 1990, 2000, 2010, 2020, 2040]

url = master_url + '1910'
charset = nil
html = open(url) do |f|
  charset = f.charset
  f.read
end

tbody = Nokogiri::HTML.parse(html, nil, charset)
# p tbody
month_count = 0
tbody.xpath('//*[@id="col_main"]/article[2]/div/table/tbody').each do |node|
  #puts node.search('tr').text
  current_month = ""
  node.search("tr").each do |tr|
    #puts tr.search("td").text
    tds = tr.search("td")

    # this is test part ###############
    #puts "length = #{tds.length}"
    #puts "tds[1] = #{tds[1].text}"
    #tds.each do |m|
    #  puts m.text
    #end
    ####################################

    if tds.length == 9 or tds.length == 10 then
      #puts "length = #{tds.length}"
      #puts "current_month = #{current_month}"
      #puts "tds[1] = #{tds[1].text}"
      if tds[1].text != current_month then
        puts "-------------------------------------"
        puts "#{tds[0].text}.#{tds[1].text}.#{tds[2].text}"
        puts "-------------------------------------"
    #    #puts tds.map |m| m.text
    #    csv << tds.map |m| m.text
        #datalists = CSV.open()
        #  datalists.puts [tds[0].text, tds[1].text, tds[2].text]
        #datalists.close
        month_count = month_count + 1
      end
    else
      abort
    end
    current_month = tds[1].text
  end
end

puts month_count


# html = url
# tbody = Nokogiri::HTML.parse(html, '//*[@id="col_main"]/article[2]/div/table/tbody')
# puts tbody


# urls.each do | url_base |
#   url = master_url + url_base.to_s
#   html = url.fetch
#   tbody = Nokogiri::HTML.parse(html, '//*[@id="col_main"]/article[2]/div/table/tbody')
#   current_month = ""
#   puts tbody
#   #tbody.search("/tr").each | tr | do
#   #  tds = tr.search("/td")
#   #  if tds.length == 9 or tds.length == 10
#   #    if tds[1]! == current_month
#   #      csv << tds.map |m| m.value
#   #    end
#   #  else
#   #    abort
#   #  end
#   #end
# end

