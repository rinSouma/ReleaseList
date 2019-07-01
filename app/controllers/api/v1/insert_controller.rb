require 'net/http'
require 'uri'
require 'json'
require "date"

module Api
  module V1
    class Api::V1::InsertController < ApplicationController
      def index
        begin
          api_key = params[:api_key]
          year = params[:year]
          month = params[:month]

          insert_data = []
          uri = URI.parse('https://books.rakuten.co.jp/event/book/comic/calendar/2019/05/js/booklist.json')
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          res = https.start {
            https.get(uri.request_uri)
          }
          json_data = JSON.load(res.body.force_encoding("UTF-8").gsub(/\xEF\xBB\xBF|\xEF\xBF\xBE/,""))
          json_data["list"].each do | book_data |
            #発売日をDate型に変換
            target_date = book_data[20]
            if year.present? then
              target_date = year.to_s + "年" + target_date
            else
              month, other = target_date.split('月')
              now = Date.today
              year = now.year
              if now.month > month.to_i then
                year = year + 1
              end
              other = other.gsub("日", "")
              if other =~ /^[0-9]+$/ then
                target_date = year.to_s + "年" + target_date
              else
                target_day = ""
                case other
                when "上旬" then
                  target_day = "1日"
                when "中旬" then
                  target_day = "15日"
                else
                  target_day = Date.new(year, month, -1).to_s + "日"
                end
                target_date = year.to_s + "年" + month.to_s + "月" + target_day
              end
            end
            release_day = Date.strptime(target_date, '%Y年%m月%d日')
#            insert_data << list.new(isbn:book_data[3], title:book_data[5], auther:book_data[7], label_name:book_data[10], label_id:book_data[14], release_date:release_day)
            puts book_data[5] + target_date
          end
          puts "complete"
        rescue=>e
          logger.debug(e.message)
        end
      end
    end
  end
end