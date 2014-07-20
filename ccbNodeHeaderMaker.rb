#!/usr/bin/ruby

require "./cppHeaderMaker"

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
		loadCcb+

#public method
		publicMethod+
#private method
		privateMethod+
		animationMethod+
		callbackMethod+
#private member
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
	def loadCcb
		makePublic+
		"\tCREATE_FUNC(#{@className});\n"+
		"\n"
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
	def animationManager
		if @animation.size > 1
			"\tCCBAnimationManager* m_animationManager;\n"
		else
			""
		end
	end
	attr_accessor :animation, :callback
end
