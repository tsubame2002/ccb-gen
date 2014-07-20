#!/usr/bin/ruby
# coding: utf-8

require "./ccbFileMakerConsole"

ccbFileName = ARGV[0]
ccbFile = open(ccbFileName, "r")


DONT_ASSGIN = 0
DOC_ROOT_VAR = 1
class CCNode
	def initialize
		@customClass = ""
		@memberVarAssignmentType = DONT_ASSGIN
		@memberVarAssignmentName = ""
		@baseClass = "Node"
		@chainedSequenceId = 0
		@animationName = ""
	end

	def assign?
		@memberVarAssignmentType.to_i == DOC_ROOT_VAR && @memberVarAssignmentName != ""
	end

	def root?
		if @layerCnt <= 2 && @customClass != "" then
			return true
		else
			return false
		end
	end

	def animation?
		@chainedSequenceId > 0
	end

	def className
		if @customClass.empty?
			return @baseClass
		else
			return @customClass
		end
	end

	def to_s
		return @customClass + @baseClass +" : " + @memberVarAssignmentName + " : " +@memberVarAssignmentType.to_s
	end

	attr_accessor :customClass, :memberVarAssignmentName, :memberVarAssignmentType, :baseClass, :layerCnt, :chainedSequenceId, :animationName
end


module Key
	NO_KEY = 0
	CUSTOM_CLASS = 1
	BASE_CLASS = 2
	ASSIGN_TYPE = 3
	ASSIGN_NAME = 4
	CHAIGNED_SEQUENCE_ID = 5
	ANIMATION_NAME = 6
	def self.all
		self.constants.map{|name| self.const_get(name)}
	end
end

KEY_NAME = {
	Key::NO_KEY => "asdjfkasjdfkajskfjask",
	Key::CUSTOM_CLASS => "customClass",
	Key::BASE_CLASS => "baseClass",
	Key::ASSIGN_TYPE => "memberVarAssignmentType",
	Key::ASSIGN_NAME => "memberVarAssignmentName",
	Key::CHAIGNED_SEQUENCE_ID => "chainedSequenceId",
	Key::ANIMATION_NAME => "name"

}
def parseValue line
	result = line.gsub(/.*<.*>(.*)<\/.*>.*/, '\1')
	result = result.strip
	if result == "CCBFile"
		return "Node"
	else
		return result.gsub(/CC(.*)/, '\1')
	end
end
layerCnt = 0
nodeStack = []
keyId = Key::NO_KEY
nodeArray = []
rootNode = nil

ccbFile.each do |line|
	if /.*<dict>.*/ =~ line then
		layerCnt += 1
		node = CCNode.new
		node.layerCnt = layerCnt
		nodeStack.push node
	elsif /.*<\/dict>.*/ =~ line then
		layerCnt -= 1
		node = nodeStack.pop
		if node.root? then
			rootNode = node
		elsif node.assign? then
			nodeArray.push node
		end
	end
	if keyId != Key::NO_KEY then
		if keyId == Key::CUSTOM_CLASS then
			nodeStack.last.customClass = parseValue(line)
			keyId = Key::NO_KEY
		elsif keyId == Key::ASSIGN_TYPE then
			nodeStack.last.memberVarAssignmentType = parseValue(line)
			keyId = Key::NO_KEY
		elsif keyId == Key::ASSIGN_NAME then
			nodeStack.last.memberVarAssignmentName = parseValue(line)
			keyId = Key::NO_KEY
		elsif keyId == Key::BASE_CLASS then
			nodeStack.last.baseClass = parseValue(line)
			keyId = Key::NO_KEY
		elsif keyId == Key::CHAIGNED_SEQUENCE_ID then
			nodeStack.chainedSequenceId = parseValue(line)
		elsif keyId == Key::ANIMATION_NAME then
			nodeStack.animationName = parseValue(line)
		end
	end
	Key.all.each do |id|
		if /.*<key>#{KEY_NAME[id]}<\/key>.*/ =~ line then
			keyId = id
		end
	end
end

member = {}
includeFiles = ["common"]

nodeArray.each do |node|
	memberName = node.memberVarAssignmentName
	nodeName = node.className
	member[memberName] = nodeName
	unless node.customClass.empty?
		includeFiles.push node.customClass
	end
end
includeFiles.uniq!


console = CcbFileMakerConsole.new
console.member = member
console.className = rootNode.customClass
console.startMenu


