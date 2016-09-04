# require "csv"
require_relative "user"
require 'csv'
require 'pry'

class Session
attr_reader :authorized_username

  def initialize
    @authorized_username = nil
    @input_pw_fail = nil
    @authentications = []
    @pw_attempts = 0
  end

  def prepare_database
    csv_scrape("testusers.csv")
  end

  def has_account?
    print "Do you have already have an account? (Y/N) "
    have_account = yes_no_initial
    if have_account == 'y'
      return true
    else
      return false
    end
  end

  def username_auth
    print "Please enter a username: "
    typed_username = gets.chomp.downcase
    return match_username?(typed_username)
  end

  def create_account
    print "Please choose a username: "
    new_username = gets.chomp.downcase
    print "Please choose password: "
    new_password = gets.chomp.downcase
    CSV.open("./testusers.csv", "ab") do |csv|
      csv << [new_username, new_password ]
    end
  end

  def failed_username
    print "Sorry that is not a valid username. Would you like to try again? "
    input_user_fail = gets.chomp.downcase
    if input_user_fail == "y"
      return true
    else
      return false
    end
  end

  def failed_password
    puts "Sorry, we could not access your account please try again later."
  end

  def pw_validated?
    while @pw_attempts < 3 && !@password_match
      if @pw_attempts == 0
        print "Please enter password: "
      else
        print "Sorry, that password is incorrect, please enter your password: "
      end
      typed_password = gets.chomp.downcase
      @pw_attempts += 1
      @password_match = match_password?(typed_password)
    end
    return @password_match
  end

  def login
    puts "You are now logged in!"
  end

  private

  def csv_scrape(test_file)
    CSV.foreach(test_file, headers: true, header_converters: :symbol ) do |row|
      user_info = row.to_hash
      @authentications << User.new(user_info[:username], user_info[:password])
    end
  end

  def yes_no_initial
    answer = gets.chomp.downcase
    while answer != 'y' && answer != 'n'
      puts "Please type Y or N."
      answer = gets.chomp.downcase
    end
    return answer
  end

  def match_username?(typed_username)
    @authorized_username = @authentications.find { |userobj| userobj.username == typed_username }
  end

  def match_password?(typed_password)
    @authorized_username.password == typed_password
  end

end
