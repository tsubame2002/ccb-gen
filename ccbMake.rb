#!/usr/bin/ruby
# coding: utf-8

require "./ccbFileMakerConsole"

ccbFileName = ARGV[0]
ccbFile = open(ccbFileName, "r")

class Element
	def initialize
		@param = {}
	end
	attr_accessor :nodes, :param
end

def parseValue line
	if /.*<false\/>.*/ =~ line then
		return false
	elsif /.*<true\/>.*/ =~ line then
		return true
	end
	result = line.gsub(/.*<.*>(.*)<\/.*>.*/, '\1')
	result = result.strip
	if result == "CCBFile"
		return "Node"
	else
		return result.gsub(/CC(.*)/, '\1')
	end
end
NON = 0
DIC = 1
ARR = 2

nodeStack = []
nodeStyleStack = []
keyStack = []
arrayStack = []

rootNode = {}

nodeStack.push rootNode
nodeStyleStack.push NON
keyStack.push "main"

layerCnt = 1
nodeStyleCnt = 1
keyStackCnt = 1

ccbFile.each do |line|
	if /.*<plist.*/ =~ line then
		if nodeStyleStack.last == NON
			nodeStyleStack.push DIC
		end
	elsif /.*plist>.*/ =~ line then

	elsif /.*<dict>.*/ =~ line then
		nodeStyleStack.push DIC
		element = {}
		layerCnt += 1
		nodeStack.push element
		nodeStyleCnt += 1
	elsif /.*<\/dict>.*/ =~ line then
		nodeStyleStack.pop
		value = nodeStack.pop
		if nodeStyleStack.last == DIC
			key = keyStack.last
			nodeStack.last[key] = value
			keyStack.pop
			keyStackCnt -= 1
		elsif nodeStyleStack.last == ARR
			arrayStack.last.push value
		end
		layerCnt -= 1
		nodeStyleCnt -= 1
				
	elsif /.*<array>.*/ =~ line then
		nodeStyleStack.push ARR
		nodeStyleCnt += 1
		arr = Array.new
		arrayStack.push arr
	elsif /.*<\/array>.*/ =~ line then
		nodeStyleStack.pop
		nodeStyleCnt -= 1
		arr = arrayStack.pop
		key = keyStack.pop
		keyStackCnt -= 1
		nodeStack.last[key] = arr
	elsif /.*<array\/>.*/ =~ line then
		value = Array.new
		if nodeStyleStack.last == DIC
			key = keyStack.last
			nodeStack.last[key] = value
			keyStack.pop
			keyStackCnt -= 1
		elsif nodeStyleStack.last == ARR
			arrayStack.last.push value
		end
				
	elsif /.*<key>.*/ =~ line then
		keyStack.push parseValue(line)
		keyStackCnt += 1
	else
		value = parseValue(line)
		if nodeStyleStack.last == DIC
			key = keyStack.last
			nodeStack.last[key] = value
			keyStack.pop
			keyStackCnt -= 1
		elsif nodeStyleStack.last == ARR
			arrayStack.last.push value
		end
	end
end
result  = nodeStack.pop['main']


KEY_NAME = {
	:CUSTOM_CLASS => "customClass",
	:BASE_CLASS => "baseClass",
	:ASSIGN_TYPE => "memberVarAssignmentType",
	:ASSIGN_NAME => "memberVarAssignmentName",
	:CHAIGNED_SEQUENCE_ID => "chainedSequenceId",
	:ANIMATION_NAME => "name",
	:CALLBACK_CHANNEL => "callbackChannel"

}
DONT_ASSGIN = 0
DOC_ROOT_VAR = 1
OWNER_VAR = 2

class CcbData
	def initialize
		@member = {}
		@animation = []
		@callback = []
		@loopCnt = 0
	end
	def calcCcbData array
		@loopCnt += 1
		if array.kind_of?(Array)
			array.each do |value|
				if value.kind_of?(Hash)
					calcCcbData(value)
				end
			end
		elsif array.kind_of?(Hash)
			node = {}
			array.each do |key, value|
				case key
				when KEY_NAME[:CUSTOM_CLASS]
					node[KEY_NAME[:CUSTOM_CLASS]] = value
					if @loopCnt <= 2 && value.empty? == false
						@rootClassName = value
					end
				when KEY_NAME[:BASE_CLASS]
					node[KEY_NAME[:BASE_CLASS]] = value
				when KEY_NAME[:ASSIGN_TYPE]
					node[KEY_NAME[:ASSIGN_TYPE]] = value.to_i
				when KEY_NAME[:ASSIGN_NAME]
					node[KEY_NAME[:ASSIGN_NAME]] = value
				when KEY_NAME[:CHAIGNED_SEQUENCE_ID]
					node[KEY_NAME[:CHAIGNED_SEQUENCE_ID]] = value.to_i
				when KEY_NAME[:ANIMATION_NAME]
					node[KEY_NAME[:ANIMATION_NAME]] = value
				when KEY_NAME[:CALLBACK_CHANNEL]
					node[KEY_NAME[:CALLBACK_CHANNEL]] = value
				end
				if value.kind_of?(Hash)
					calcCcbData(value)
				elsif value.kind_of?(Array)
					calcCcbData(value)
				end
			end
			if node.key? KEY_NAME[:ASSIGN_TYPE]
				if node[KEY_NAME[:ASSIGN_TYPE]] != DONT_ASSGIN
					unless node[KEY_NAME[:ASSIGN_NAME]].empty?
						if node[KEY_NAME[:CUSTOM_CLASS]].empty?
								@member[node[KEY_NAME[:ASSIGN_NAME]]] = node[KEY_NAME[:BASE_CLASS]]
						else
							@member[node[KEY_NAME[:ASSIGN_NAME]]] = node[KEY_NAME[:CUSTOM_CLASS]]
						end
					end
				end
			end
			if node.key? KEY_NAME[:CALLBACK_CHANNEL]
				@animation.push node[KEY_NAME[:ANIMATION_NAME]]
				node[KEY_NAME[:CALLBACK_CHANNEL]]['keyframes'].each do |callback|
					@callback.push callback['value'][0]
				end

			end
		end
		@loopCnt -= 1
	end
	attr_accessor :member, :rootClassName, :rootFlg, :animation, :callback
end
ccbData = CcbData.new
ccbData.calcCcbData(result)

console = CcbFileMakerConsole.new

console.member = ccbData.member
console.className = ccbData.rootClassName
console.animation = ccbData.animation
console.callback = ccbData.callback
console.startMenu
