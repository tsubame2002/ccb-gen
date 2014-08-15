#!/usr/bin/ruby

require_relative "./cppHeaderMaker"

class CcbNodeHeaderMaker < CppHeaderMaker
	@@ccbConfig
	def makeFile
		loadCcbConfig

		header+
#include
		"#include \"Common.h\"\n"+
		includeFiles+
#class start
		classStart+
#public constructor & destructor
		makePublic+
		makeConstructor+
		makeDestructor+
		createFunc+

#public method
		publicMethod+
#private method
		privateMethod+
		animationMethod+
		callbackMethod+
#private member
		privateEnum+
		privateMember+
		animationManager+

#class end
		classEnd+
#includeGuardEnd
		makeIncludeGuardEnd
	end
	def loadCcbConfig
		@ccbConfig = YAML.load_file(CCB_CONFIG_FILE)
	end
	def createFunc
		if @method.key? "Node"
			makePublic+
			"\tCREATE_FUNC(#{@className});\n"+
			"\n"
		else
			""
		end
	end
	def animationMethod
		methodText = ""
		@animation.each do |value|
			unless value == "Default Timeline"
				methodText += "\tvoid\s_run" + parseUpperCamel(value) + "();\n"
			end
		end
		return methodText
	end
	def callbackMethod
		methodText = ""
		@callback.each do |value|
			methodText += "\tvoid _callback" + parseUpperCamel(value) + "(Node* pTarget);\n"
		end
		return methodText
	end
	def privateEnum
		privateEnum = ""
		enumList = []
		@customClasses.each do |value|
			if value["customClass"] == "SuperButton"
				memberName = value["memberVarAssignmentName"]
				customProperties = value["customProperties"]
				id = ""
				customProperties.each do |property|
					if(property["name"] == "id")
						id = property["value"]
					end
				end
				param = {:key => defineUpcase(memberName), :value => id}
				enumList.push param
			end
		end
		enumList.uniq!
		if enumList.empty? == false
			privateEnum += "enum {\n"
			enumList.each do |value|
				privateEnum += "\t#{value[:key]} = #{value[:value]}\n"
			end
			privateEnum += "}\n"
		end
	end
	def animationManager
		if @animation.size > 1
			"\tCCBAnimationManager* m_animationManager;\n"
		else
			""
		end
	end
	attr_accessor :animation, :callback, :customClasses
end
