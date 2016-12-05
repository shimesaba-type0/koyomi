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
tbody.xpath('//*[@id="col_main"]/article[2]/div/table/tbody').each do |node|
  #puts node.search('tr').text
  #current_month = ""
  node.search("tr").each do |tr|
    puts tr
    puts tr.search("td").text
    #tds = tr.search("td")
    #if tds.length == 9 or tds.length == 10 then
    #  if tds[1] != current_month then
    #    tds.map |m| m.value
    #    #csv << tds.map |m| m.value
    #  end
    #else
    #  abort
    #end
  end
end

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

