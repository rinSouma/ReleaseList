require 'net/http'
require 'uri'
require 'json'
require "date"

module Api
  module V1
    class Api::V1::InsertController < ApplicationController
      protect_from_forgery :except => [:index]
      include Common
      def index
        begin
          $GENRE_LIST = {0 => "comic", 1 => "pocket-book"}

          api_key = params[:api_key]
          p_year = params[:year]
          p_month = params[:month]
          genre = params[:genre]

          ####悪用防止のための認証処理が必要####
          if api_key != ENV['RELEASE_LIST_API_KEY'] then
            render status: 200, json: { status: 1, message: "Authentication error" }
            logger.debug("Authentication error")
            return
          end

          #パラメタチェック
          if genre.blank? then
            render status: 200, json: { status: 1, message: "genre is not set" }
            return
          end
          if genre.to_i > 1 and genre.to_i < 0 then
            render status: 200, json: { status: 1, message: "genre is nothing" }
            return
          end
          insert_data = []
          ym = ""
          if p_year.present? then
            ym = p_year.to_s + "/" +  format("%02d", p_month).to_s + "/"
          end
          api_url = URI.escape("https://books.rakuten.co.jp/event/book/" + $GENRE_LIST[genre.to_i] + "/calendar/" + ym.to_s + "js/booklist.json")
          logger.debug(api_url)
          
          uri = URI.parse(api_url)
          https = Net::HTTP.new(uri.host, uri.port)
          https.use_ssl = true
          res = https.start {
            https.get(uri.request_uri)
          }
          logger.debug(res.body)
          json_data = JSON.load(res.body.force_encoding("UTF-8").gsub(/\xEF\xBB\xBF|\xEF\xBF\xBE/,""))
          json_data["list"].each do | book_data |
            #発売日をDate型に変換
            release_day, decision_flg = getDateByJson(p_year, book_data[20])

            logger.debug(book_data[5] + release_day.to_s + decision_flg.to_s)
            insert_data << List.new(id:book_data[3], genre:genre, isbn:book_data[3], title:book_data[5], auther:book_data[7], \
                                    label_name:book_data[10], label_id:book_data[14], release_date:release_day, decision_flg:decision_flg)
          end
          logger.debug(insert_data)
          List.import insert_data, on_duplicate_key_update: [:title, :auther, :label_name, :label_id, :release_date, :decision_flg]
          render status: 200, json: { status: 0, message: "success" }
        rescue=>e
          logger.debug(e.message)
        end
      end

      def getDateByJson(p_year, target_date)
        #発売日をDate型に変換
        #なんか日付のフォーマット変わって落ちてきたので対応
        if target_date.include?("/") then
          y, m, d = target_date.split('/')
          target_date = m.to_s + "月" + d.to_s + "日"
        end
        
        decision_flg = 1
        if p_year.present? then
          target_date, decision_flg = getDate(p_year, target_date)
        else
          month, other = target_date.split('月')
          now = Date.today
          year = now.year
          if now.month > month.to_i then
            year = year + 1
          end
          target_date, decision_flg = getDate(year, target_date)
        end
        puts target_date
        release_day = Date.strptime(target_date, '%Y年%m月%d日')
        return release_day, decision_flg
      end

      def getDate(year, target_date)
        month, other = target_date.split('月')
        other = other.gsub("日", "")
        if other =~ /^[0-9]+$/ then
          return year.to_s + "年" + target_date, 1
        else
          target_day = ""
          case other
          when "上旬" then
            target_day = "10日"
          when "中旬" then
            target_day = "20日"
          else
            target_day = Date.new(year.to_i, month.to_i, -1).day.to_s + "日"
          end
          return year.to_s + "年" + month.to_s + "月" + target_day.to_s, 0
        end
      end
    end
  end
end
