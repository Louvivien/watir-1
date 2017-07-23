require 'watir'
require 'watir-scroll'
require 'dotenv/load'
require 'pp'

class FacebookGroupParser
	attr_reader :member_count

	def initialize
		puts "Enter Facebook Group Members URL to scrap:"
		@group_url = gets.chomp
	end

	def login_to_facebook
		login = ENV["FB_LOGIN"]
		pwd = ENV["FB_PWD"]

		@b = Watir::Browser.new(:firefox)
		@b.goto "https://www.facebook.com/login"

		login_bar = @b.text_field(id:"email")
		login_bar.set(login)

		pwd_bar = @b.text_field(id:"pass")
		pwd_bar.set(pwd)

		submit_button = @b.button(type:"submit")
		submit_button.click
		sleep(1)

		@b.goto @group_url
		sleep(3)
	end

	def show_all_group_members
		@b.scroll.to :bottom
		l = @b.link(text: 'See More')
		while l.exists?
			l.click
			@b.scroll.to :bottom
			sleep(3)
			l = @b.link(text: 'See More')
    	end
	end

	def scrap_group_members
		@member_count = 0
		group_members = []
		div_data = @b.divs(class:"fsl fwb fcb")
		div_data.each do |div|
			member = {}
			@member_count += 1
			member[:name] = div.a.text
			member[:url] = div.a.href
			group_members.push(member)
		end
		return group_members
	end	


	def save_to_json
		data = self.scrap_group_members
		File.open("result.json","w") do |f|
			f.write(data.to_json)
		end
	end


	def perform
		puts "Logging into Facebook..."
		self.login_to_facebook
		puts "Displaying all group members..."
		self.show_all_group_members
		puts "Scrapping all group member names and urls..."
		self.scrap_group_members
		puts "Saving data to result.json file..."
		self.save_to_json
		puts "Deed is done. Closing browser now."
		@b.close
	end
	
end

FacebookGroupParser.new.perform