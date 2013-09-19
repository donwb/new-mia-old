require "rubygems"
require "sinatra"
require "mongo"
require "json/ext"
require "sinatra/reloader" if development?

include Mongo

configure do
	db = MongoClient.new("ds045588.mongolab.com", 45588).db('mia')
	auth = db.authenticate('miauser', 'mia1234')
	puts auth
	set :db, db
	set :environment, :development
end

helpers do
	def object_id val
		BSON::ObjectId.from_string(val)
	end

	def find_by_id id
		id = object_id(id) if String === id

		
		settings.db['homes'].find_one(:_id => id).to_json
	end

	def find_all
		settings.db['homes'].find.to_a.to_json
	end
end


get "/" do
    send_file File.expand_path('index.html', settings.public_folder)
end

get "/listings" do
	content_type :json
	find_all

end

get "/listing/:id" do
	content_type :json
	find_by_id(params[:id])
end



#miauser/mia1234
