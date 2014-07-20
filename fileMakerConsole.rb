#!/usr/bin/ruby

require 'yaml'
require './ccbNodeMaker'
require './ccbNodeHeaderMaker'

CONFIG_FILE_NAME = "config.yml"

FILE_MAKER_TYPE = {
	'CppMaker' => 1,
	'CppHeaderMaker' => 2,
}
START_MENU = {
	'CHANGE_USER_NAME' => 1,
	'CHANGE_PROJECT_NAME' => 2,
	'CREATE_FILE' => 3,
	'EXIT' => 4,
	'MAX' => 5
}

class FileMakerConsole

	def initialize
		@config = {
			'userName' => nil,
			'projectName' => nil,
		}
	end

	def startMenu
		loadConfig
		displayStartMenu
		runMenuItem
	end

	def generateFile
		inputClassName
		chooseMaker
		@maker.generateFile
	end
	def getFileName
		return @className + @fileType
	end

attr_accessor :config, :className, :maker, :member

private
	def displayStartMenu
		system "clear"
		displayStatus
		displayMenu
	end
	def displayMenu
		putsMagenta "[MENU]"
		puts "\s1 : Change User Name"
		puts "\s2 : Change Project Name"
		puts "\s3 : Create File"
		puts "\s4 : Exit"
		puts
		printYellow "Select number : "
	end
	def displayStatus
		putsMagenta "[Status]"
		userName = @config['userName'].nil? ? "not defined" : @config['userName']
		puts "\sUserName : #{@config['userName']}"
		projectName = @config['projectName'].nil? ? "not defined" : @config['projectName']
		puts "\sProjectName : #{@config['projectName']}"
		puts
	end

	def runMenuItem
		_runMenuItem
	end
	def _runMenuItem
		menuId = STDIN.gets
		if menuId  =~ /^[0-9]+$/
			menuId = menuId.to_i
			if 0 < menuId && menuId < START_MENU['MAX']
				case menuId
				when START_MENU['CHANGE_USER_NAME']
					inputUserName
					startMenu
				when START_MENU['CHANGE_PROJECT_NAME']
					inputProjectName
					startMenu
				when START_MENU['CREATE_FILE']
					generateFile
				when START_MENU['EXIT']
				end
			else
				_runMenuItem
			end
		else
			_runMenuItem
		end
	end
	def inputUserName
		printYellow "Enter your name : "
		userName = STDIN.gets
		@config['userName'] = userName.chomp.strip
		syncConfig
		puts "Your Name :#{@config['userName']}"
		puts
	end
	def inputProjectName
		printYellow "Enter project name : "
		projectName = STDIN.gets
		@config['projectName'] = projectName.chomp.strip
		syncConfig
		puts "Project Name : #{@config['projectName']}"
		puts
	end
	def inputClassName
		printYellow "Enter Class Name ex. HogeClass : "
		_inputClassName
	end
	def _inputClassName
		className = STDIN.gets
		if className =~ /^[0-9A-Za-z]+$/
			@className = className.chomp.strip
			puts "Class Name : #{@className}"
			puts
		else
			puts "Enter Class Name using half-width characters"
			_inputClassName
		end
	end
	def chooseMaker
		putsMagenta "[File Type]"
		FILE_MAKER_TYPE.each do |key, value|
			puts "\s#{value} : #{key}"
		end
		puts
		printYellow "Select number : "
		_chooseMaker
	end
	def _chooseMaker
		makerId = STDIN.gets.strip.to_i
		case makerId
		when FILE_MAKER_TYPE['CppMaker']
			@maker = CppMaker.new(@config, @className)
			puts "CppMaker"
		when FILE_MAKER_TYPE['CppHeaderMaker']
			@maker = CppHeaderMaker.new(@config, @className)
			puts "CppHeaderMaker"
		else
			puts "Select file type onece more."
			_chooseMaker
		end
	end

	def loadConfig
		@config = YAML.load_file(CONFIG_FILE_NAME)
	end

	def syncConfig
		open(CONFIG_FILE_NAME, "w") do |f|
			YAML.dump(@config, f)
		end
	end


	def putsYellow comment
		puts "\e[33m" + comment + "\e[0m"
	end
	def printYellow comment
		print "\e[33m" + comment + "\e[0m"
	end
	def putsRed comment
		puts "\e[31m" + comment + "\e[0m"
	end
	def putsMagenta comment
		puts "\e[35m" + comment + "\e[0m"
	end
end
