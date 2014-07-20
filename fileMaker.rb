#!/usr/bin/ruby
class FileMaker

	def generateFile
		fileName = getFileName
		output = open(fileName, "w")
		output.write(makeFile)
		output.close
	end


attr_accessor :config, :className, :fileType, :member, :includeFile, :superClass, :method

private
	def getFileName
		return @className + @fileType
	end
	def makeFile
		makeHeaderComment
	end

	def makeHeaderComment
		now = Time.now
		return "\n"+
		"//\n"+
		"//  #{@className+@fileType}\n"+
		"//  #{@config['projectName']}\n"+
		"//\n"+
		"//  Created by #{@config['userName']} on #{now.strftime("%Y/%m/%d.")}\n"+
		"//  Copyright (c) #{now.strftime("%Y")}年 CROOZ. All rights reserved.\n"+
		"//\n"+
		"\n"
	end

	def makeMethodComment methodName
		now = Time.now
		methodComment = 
		"/**\n"+
		" * #{methodName}\n"+
		" * \n"+
		" * @author #{@config['userName']}\n"+
		" * @since #{now.strftime("%Y/%m/%d")}\n"+
		" * \n"+
		" **/\n"
	end
	def uCaseOnlyFirst word
		word.strip!
		return word.gsub(/^[A-Za-z]/){|w| w.upcase}
	end
	def parseUpperCamel word
		word = uCaseOnlyFirst(word)
		word = word.gsub(/_[a-z]/){|w| w.upcase}
		word = word.gsub(/_/){|w| ""}
	end
	def defineUpcase word
		word.strip!
		word = word.gsub(/^[A-Za-z]/){|w| w.downcase}
		word = word.gsub(/[A-Z]/){|w| "_" + w}
		word = word.upcase
	end
end
