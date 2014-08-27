#!/usr/bin/ruby

require_relative "./cppMaker"

class CcbNodeMaker < CppMaker
	@@ccbConfig
	def makeFile
		loadCcbConfig
		loadSuperButton
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
	def loadSuperButton
		@superButtons = []
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
				ccbKey = memberName.sub(/m_/,'')
				superButton = {
					:name => memberName,
					:id   => id,
					:ccbKey => ccbKey
				}
				@superButtons.push superButton
			end
		end
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
			@animation.each do |value|
				unless value == "Default Timeline"
					methodContext += "\tif(strcmp(name, #{parseAnimationDefine(value)}) == 0)\n"
					methodContext += "\t{\n"
					methodContext += "\t}\n"
				end
			end
			if @animation.size > 0
				methodContext += "\tif(m_animationManager != NULL)\n"
				methodContext += "\t{\n"
				methodContext += "\t\tm_animationManager->setDelegate(NULL);\n"
				methodContext += "\t}\n"
			end
		elsif param['name'] == "onResolveCCBCCCallFuncSelector"
			@callback.each do |value|
				methodContext += "\tDIALOG_REGISTER_CALLBACK(this,\s\"#{value}\",\s#{@className}::_callback#{parseUpperCamel(value)});\n"
			end
			if @callback.size > 0
				methodContext += "\treturn NULL;\n"
			end
		end
		return methodContext
	end
	def checkSuperButton param, methodContext
		#check SuperButton
		if(param["name"] == "_setSuperButtonListener")
			@superButtons.each_with_index do |value, i|
				if i == 0
					methodContext += "\tif\s(\sname\s==\sstrstr(name, \"#{value[:ccbKey]}\"))\s{\n"
				else
					methodContext += "\telse\sif\s(\sname\s==\sstrstr(name, \"#{value[:ccbKey]}\"))\s{\n"
				end
				methodContext += "\t\tm_#{value[:name]}\s=\sstatic_cast<SuperButton*>(pNode);\n"
				methodContext += "\t\tm_#{value[:name]}->setListener(this);\n"
				methodContext += "\t\tm_#{value[:name]}->setId(#{defineUpcase(value[:name])});\n"
				methodContext += "\t}"
			end
			methodContext += "\n"
		elsif (param["name"] == "onTap")
			if @superButtons.empty? == false
				methodContext += "\tint\sbuttonId\s=\spButton->getId();\n"
				methodContext += "\tswitch(buttonId)\n"
				methodContext += "\t{\n"
				@superButtons.each do |value|
					methodContext += "\t\tcase #{defineUpcase(value[:name])}:\n"
					methodContext += "\t\tbreak;\n"
				end
				methodContext += "\t}\n"
			end
				
		end
		return methodContext
	end
	def parseAnimationDefine word
		"ANIMATION_" + defineUpcase(word)
	end
	attr_accessor :animation, :callback, :customClasses, :superButtons
end
