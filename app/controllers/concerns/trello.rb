require 'net/http'
require 'uri'
require 'json'

module Trello
    extend ActiveSupport::Concern
    #ユーザIDの取得
    def get_user_id(token)
        res = run_api("https://trello.com/1/tokens/" + token + "?key=" + ENV['TRELLO_API_KEY'])
        json_data = JSON.load(res.body)
        return json_data["idMember"]
    end
    #ボード一覧の取得
    def get_boards(token)
        user_id = get_user_id(token)
        res = run_api("https://trello.com/1/members/" + user_id +  "/boards?token=" + token + "&key=" + ENV['TRELLO_API_KEY'])
        json_data = JSON.load(res.body)
        board_list = []
        json_data.each do | board_data |
            if board_data["closed"].to_s == "false" then
                board_list << {id:board_data["id"].to_s,name:board_data["name"].to_s}
            end
        end
        return board_list
    end

    #リスト一覧の取得
    def get_lists(token, board_id)

    end

    #ラベル一覧の取得
    def get_labels(token, board_id)

    end

    #カードの登録
    def set_card(token, in_data)

    end

    private

    def run_api(api_url, params=nil)
        logger.debug(api_url)
        uri = URI.parse(api_url)
        https = Net::HTTP.new(uri.host, uri.port)
        https.use_ssl = true
        #postパラメタの有無で処理を変える
        if params.present? then
            req = Net::HTTP::Post.new(uri.path)
            req.set_form_data(params)
            res = https.start {
                https.request(req)
            }
            return res
        else
            res = https.start {
                https.get(uri.request_uri)
            }
            return res
        end
    end
end