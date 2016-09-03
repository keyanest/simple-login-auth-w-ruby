# require "csv"
require_relative "user"
require 'csv'
require 'pry'

class Session

  def initialize
    @username = nil
    @password = nil
    @input_init = nil
    @input_user_fail = nil
    @input_pw_fail = nil
    @authorized_user = nil
    @authentications =[]
    @new_username = nil
    @new_password = nil
  end

  def csv_scrape(test_file)
    CSV.foreach(test_file, headers: true, header_converters: :symbol ) do |row|
      user_info = row.to_hash
      @authentications << User.new(user_info[:username], user_info[:password])
    end
  end

  def run_auth
    puts "Do you have already have an account? (Y/N)"
    @input_init = gets.chomp.downcase
    yes_no_initial
  end

  def yes_no_initial
    if @input_init != "y" && @input_init != "n"
      puts "Please type Y or N."
    elsif @input_init == "n"
      puts "Please create account."
      create_account
    elsif @input_init == 'y'
      username_auth
    end
  end

  def create_account
    puts "Please choose a username."
    @new_username = gets.chomp.downcase
    puts "Please choose password."
    @new_password = gets.chomp.downcase
    CSV.open("./testusers.csv", "ab") do |csv|
      csv << [@new_username, @new_password ]
    end
  end

  def username_auth
    print "Please enter a username:"
    @username = gets.chomp.downcase
    @authorized_user = @authentications.find { |userobj| userobj.username == @username }
    if @authorized_user
      pw_authorization
    else
      print "Sorry that is not a valid username. Would you like to try again?"
      @input_user_fail = gets.chomp.downcase
      if @input_user_fail == "y"
        username_auth
      else
        create_account
      end
    end
  end

  def pw_authorization
    pw_attempts = 0
    print "Please enter password:"
    @password = gets.chomp.downcase
    pw_attempts += 1
    if @authorized_user.password == @password
      puts "You are now logged in!"
    else
      if pw_attempts < 3
        puts "Sorry, that password is incorrect, Would you like to try again?"
        @input_pw_fail = gets.chomp.downcase
        if @input_pw_fail == 'y'
          pw_authorization
        else
          create_account
        end
      else
        puts "Sorry, we could not access your account please try again later."
      end
    end
  end
end
