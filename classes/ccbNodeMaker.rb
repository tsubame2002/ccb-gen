#!/usr/bin/ruby

require_relative "./cppMaker"

class CcbNodeMaker < CppMaker
	@@ccbConfig
	def makeFile
		loadCcbConfig
#headerComment
		makeHeaderComment+
#include
		makeInclude+

		animationDefine+
#public constructor & destructor
		makeConstructor+
		makeDestructor+

#clear & destroy
		makeClear+
		makeDestroy+

		animationMethod+
		callbackMethod+

#public method
		publicMethod+
#private method
		privateMethod
	end
	def loadCcbConfig
		@ccbConfig = YAML.load_file(CCB_CONFIG_FILE)
	end
	def makeClear
		clearMehodContext = ""
		@member.each do |key, value|
			clearMehodContext += "\t#{key}\t\s=\sNULL;\n"
		end
		param = {
			'virtual' => 0,
			'return' => "void",
			'name' => '_clear',
			'args' => []
		}
		return makeMethod(param, clearMehodContext)
	end
	def makeDestroy
		destroyMethodContext = ""
		@member.each do |key, value|
			destroyMethodContext += "\tCC_SAFE_RELEASE_NULL(#{key});\n"
		end
		param = {
			'virtual' => 0,
			'return' => "void",
			'name' => '_destroy',
			'args' => []
		}
		makeMethod(param, destroyMethodContext)
	end
	def animationDefine
		defineText = "\n"
		@animation.each do |value|
			unless value == "Default Timeline"
				defineText += "#define\s#{parseAnimationDefine(value)}\s\"#{value}\"\n"

			end
		end
		return defineText
	end
	def animationMethod
		methodText = ""
		@animation.each do |value|
			unless value == "Default Timeline"
				methodContext = "\tm_animationManager\s=\sdynamic_cast<CCBAnimationManager*>(getUserObject());\n"
				methodContext += "\tm_animationManager->runAnimationsForSequenceNamed(#{parseAnimationDefine(value)});\n"
				methodContext += "\tm_animationManager->setDelegate(this);\n"

				param = {
					'virtual' => 0,
					'return' => 'void',
					'name' => "_run" + parseUpperCamel(value),
					'args' => []
				}
				methodText += makeMethod(param, methodContext)
			end
		end
		return methodText
	end
	def callbackMethod
		methodText = ""
		@callback.each do |value|
			param = {
				'virtual' => 0,
				'return' => 'void',
				'name' => "_callback" + parseUpperCamel(value),
				'args' => [{
					'type' => 'Node*',
					'name' => 'pTarget'
					}]
			}
			methodText += makeMethod(param, "")
		end
		return methodText
	end

	def makeMethod param, methodContext = ""
		if param.key?("context")
			methodContext = ymlFilter(param["context"])
		end
		methodContext = checkSuperButton(param, methodContext)
		methodContext = checkAnimation(param, methodContext)
		methodContext = checkRegisterVariable(param, methodContext)
		methodText = makeMethodComment(param["name"])
		#return param
		methodText += ymlFilter(param["return"]) + "\s"
		#ClassName
		methodText += @className + "::"
		#methodName
		methodText += param["name"]

		#param
		methodText += "("
		cnt = 0
		param["args"].each do |value|
			if cnt == 0
				methodText += value["type"] + "\s" + value["name"]
			else
				methodText += ",\s" + value["type"] + "\s" + value["name"]
			end
			cnt += 1
		end
		methodText += ")\n"
		#methodBegin
		methodText += "{\n"

		#methodContext
		methodText += methodContext
		#methodEnd
		methodText += "}\n"
		methodText += "\n"
		return methodText
	end
	def checkRegisterVariable param, methodContext
		if(param['name'] == "onRegisterVariable" || param['name'] == "onAssignCCBMemberVariable")
			if @member.has_value?("SuperButton*")
				methodContext += "\t_setSuperButtonListener(name, pNode);\n\n"
			end
			@member.each do |key, value|
				if value != "SuperButton*"
					ccbKey = key.sub(/m_/,'')
					methodContext += "\tDIALOG_REGISTER_VARIABLE_NODE(this, \"#{ccbKey}\", #{value}, #{key});\n"
				end
			end
			methodContext += "\n\treturn\sfalse;\n"
		end
		if(param['name'] == "onAssignCCBCustomProperty")
			methodContext += "\n\treturn\sfalse;\n"
		end
		return methodContext
	end
	def checkAnimation param, methodContext
		if(param['name'] == "completedAnimationSequenceNamed")
			cnt = 0
			@animation.each do |value|
				unless value == "Default Timeline"
					methodContext += "\tif(strcmp(name, #{parseAnimationDefine(value)}) == 0)\n"
					methodContext += "\t{\n"
					methodContext += "\t}\n"
					cnt += 1
				end
			end
			if cnt > 0
				methodContext += "\tm_animationManager->setDelegate(NULL);\n"
			end
		elsif param['name'] == "onResolveCCBCCCallFuncSelector"
			cnt = 0
			@callback.each do |value|
				methodContext += "\tDIALOG_REGISTER_CALLBACK(this,\s\"#{value}\",\s#{@className}::_callback#{parseUpperCamel(value)});\n"
				cnt += 1
			end
			if cnt > 0
				methodContext += "\treturn NULL;\n"
			end
		end
		elsif param['name'] == "endDialog"
			methodContext += "\tm_animationManager->setDelegate(NULL);\n"
		end
		return methodContext
	end
	def checkSuperButton param, methodContext
		#check SuperButton
		if(param["name"] == "_setSuperButtonListener")
			cnt = 0
			@member.each do |key, value|
				if value == "SuperButton*"
					ccbKey = key.sub(/m_/,'')
					if cnt == 0
						methodContext += "\tif\s(\sname\s==\sstrstr(name, \"#{ccbKey}\"))\s{\n"
					else
						methodContext += "\selse\sif\s(\sname\s==\sstrstr(name, \"#{ccbKey}\"))\s{\n"
					end
						methodContext += "\t\t#{key}\s=\sstatic_cast<SuperButton*>(pNode);\n"
						methodContext += "\t\t#{key}->setListener(this);\n"
						methodContext += "\t\t#{key}->setId();\n"
						methodContext += "\t}"
					cnt += 1
				end
			end
			methodContext += "\n"
		elsif (param["name"] == "onTap")
			hasSuperButton = false
			param["args"].each do |value|
				if value["type"] == "SuperButton*"
					hasSuperButton = true
				end
			end
			if hasSuperButton
				methodContext += "\tint\sbuttonId\s=\spButton->getId();\n"
			end
				
		end
		return methodContext
	end
	def parseAnimationDefine word
		"ANIMATION_" + defineUpcase(word)
	end
	attr_accessor :animation, :callback
end
