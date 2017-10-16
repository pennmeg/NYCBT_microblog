# ======= ======= ======= SETUP ======= ======= =======
# ======= requires =======
require "sinatra"
require "sinatra/reloader"
require 'sinatra/activerecord'
# ======= models =======
require './models'
# ======= database =======
set :database, "sqlite3:micro_blog.db"
# ======= sessions =======
enable :sessions

# ======= ======= ======= ROUTER ======= ======= =======
# ====== current_user ======
def current_user
	puts "*** current_user ***"
	if session[:user_id]
		@current_user = User.find(session[:user_id])
		puts "@current_user: #{@current_user}"
	else
		@current_user = nil
		puts "@current_user: #{@current_user}"
	end
end

# ======= publish =======
post '/publish_form' do
	puts "\n******* GET: publish_form *******"
	puts "@params.inspect: #{@params.inspect}"
	Post.create(
		user_id: session[:user_id],
		post_content: params[:post_content]
	)
	@post = Post.order("created_at").last
	puts "@post: #{@post.inspect}"
	@posts = Post.all
	puts "@posts: #{@posts.inspect}"
	current_user
	erb :user_profile
end

# ======= default =======
get '/' do
	puts "\n******* / *******"
	erb :home
end

# ======= home =======
get '/home' do
	puts "\n******* home *******"
	erb :home
end

# ======= signin_form =======
get '/signin_form' do
	puts "\n******* GET: signin_form *******"
	erb :signin_form
end

# ======= signin =======
post '/signin' do
	puts "\n******* POST: signin *******"
	puts "@params.inspect: #{@params.inspect}"
	@user = User.where(:username => params[:username]).first   # ===finds if the username entered matches a username in the database
	puts "@user: #{@user.inspect}"
	if @user
		if params[:password] == @user[:password]
			session[:user_id] = @user[:id]
			puts "session[:user_id]: #{session[:user_id].inspect}"
			current_user
			erb :user_profile
		else
			erb :signin_form
		end
	else
			erb :signup_form
	end
end

# ======= signout =======
get '/signout' do
	puts "\n*******GET: signout *******"
	session[:user_id] = nil
	erb :home
end

# ======= signup_form =======
get '/signup_form' do
	puts "\n*******GET: signup_form *******"
	erb :signup_form
end

# ======= signup =======
post '/signup' do
	puts "\n******* POST: signup *******"
	puts "params: #{params.inspect}"
	User.create(
		username: params[:username],
		password: params[:password],
		fname: params[:fname],
		lname: params[:lname],
		email: params[:email],
		membertype: params[:membertype],
		created_at: DateTime.now
	)
	# @user = User.order("created_at").last
	# puts "@user: #{@user.inspect}"
	erb :signin_form
end

# ======= user_profile ========
get '/user_profile' do
	puts "\n******* GET: profile:ID *******"
	puts "@users: #{@users.inspect}"
	current_user
	erb :user_profile
end

# ======= delete_user ========
get '/delete_user_form' do
	puts "\n******* delete_user_form *******"
	puts "params: #{params.inspect}"
	current_user
	erb :delete_user_form
end

# ======= delete_user ========
post '/delete_user' do
	puts "\n******* POST: delete_user *******"
	puts "params: #{params.inspect}"
	current_user
	@current_user = User.find(params[:id]).destroy
	@users = User.all
	erb :home
end


# ======= edit_user ========
get '/edit_user_form' do
	puts "\n******* edit_user_form *******"
	puts "params: #{params.inspect}"
	current_user
	puts "@current_user: #{@current_user.inspect}"
	erb :edit_user_form
end

# ===== update_user ==========
get "/update_user" do
	puts "\n******* update_user *******"
	puts "params: #{params.inspect}"
	User.find(params[:id]).update_attributes(
		username: params[:username],
		password: params[:password],
		fname: params[:fname],
		lname: params[:lname],
		email: params[:email],
		membertype: params[:membertype],
		# created_at: DateTime.now
	)
	current_user
	erb :user_profile
end

# ======= user_list ========
get '/user_list' do
	puts "\n******* user_list *******"
	@users = User.all
	puts "params: #{params.inspect}"
	erb :user_list
end

get '/view_profile' do
	puts "****** user_profile ******"
	@user = User.find(params[:id])
	erb :view_profile
end
