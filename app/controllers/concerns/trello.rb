require 'net/http'
require 'uri'
require 'json'

module Trello
    extend ActiveSupport::Concern
    class Trello_API
        attr_accessor :name, :desc, :pos, :due, :due_complete, :id_list, :id_labels

        def initialize(token, api_key)
            @token = token.to_s
            @api_key = api_key.to_s
        end

		#ユーザ情報の取得
		def get_user
			user_id = get_user_id.to_s
	        res = run_api("https://trello.com/1/members/" + user_id +  "?token=" + @token + "&key=" + @api_key)
			puts res.code
			if res.code.to_s != "200" then
				return nil
			end
			return JSON.load(res.body)
		end
	    #ユーザIDの取得
		def get_user_id
			res = run_api("https://trello.com/1/tokens/" + @token + "?key=" + @api_key)
			puts res.code
			if res.code.to_s != "200" then
				return nil
			end
			json_data = JSON.load(res.body)
			if json_data.present? then
				return json_data["idMember"]
			end
			return nil
	    end

		#ボード一覧の取得
	    def get_boards
			user_id = get_user_id.to_s
	        res = run_api("https://trello.com/1/members/" + user_id +  "/boards?token=" + @token + "&key=" + @api_key)
			puts res.code
			if res.code.to_s != "200" then
				return nil
			end
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
	    def get_lists(board_id)
	        res = run_api("https://trello.com/1/boards/" + board_id.to_s +  "/lists?token=" + @token + "&key=" + @api_key)
			puts res.code
			if res.code.to_s != "200" then
				return nil
			end
	        json_data = JSON.load(res.body)
	        list_list = []
	        json_data.each do | list_data |
	            if list_data["closed"].to_s == "false" then
	                list_list << {id:list_data["id"].to_s,name:list_data["name"].to_s,board:board_id}
	            end
	        end
	        return list_list
	    end
	
	    #ラベル一覧の取得
	    def get_labels(board_id)
	        res = run_api("https://trello.com/1/boards/" + board_id.to_s +  "/labels?token=" + @token + "&key=" + @api_key)
			puts res.code
			if res.code.to_s != "200" then
				return nil
			end
	        json_data = JSON.load(res.body)
	        label_list = []
	        json_data.each do | label_data |
	            if label_data["name"].to_s.present? then
	                label_list << {id:label_data["id"].to_s,name:label_data["name"].to_s,board:board_id}
	            end
	        end
	        return label_list
	    end
	
	    #カードの登録
        def set_card
            params = {'name' => @name.to_s, 'desc' => @desc.to_s, 'pos' => @pos.to_s, \
                        'due' => @due, 'dueComplete' => @due_complete, \
                        'idList' => @id_list.to_s, 'idLabels' => @id_labels.to_s, \
                        'token' => @token, 'key' =>  @api_key}
            res = run_api("https://api.trello.com/1/cards", params)
			if res.code.to_s == "200" then
				return true
			end
			return false
	    end
	
	    private
	
	    def run_api(api_url, params=nil)
	        puts api_url
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
end