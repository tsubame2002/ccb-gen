#!/usr/bin/ruby

require_relative "./fileMaker"

class CppMaker < FileMaker

	def initialize config, className, member = [], includeFile = [], superClass = [], method = []
		@fileType = ".cpp"
		@config = config
		@className = className
		@member = member
		@includeFile = includeFile
		@superClass = superClass
		@method = method
	end

	def makeFile
#headerComment
		makeHeaderComment+
#include
		makeInclude+
#public constructor & destructor
		makeConstructor+
		makeDestructor+

#clear & destroy
		makeClear+
		makeDestroy+

#public method
		publicMethod+
#private method
		privateMethod
	end

	def makeInclude
		includeText = "#include \"#{@className}.h\"\n"
		@includeFile["cpp"].each do |value|
			includeText += "#include \"#{value}.h\"\n"
		end
		return includeText
	end

	def makeConstructor
		constructor = "\n"+
		makeMethodComment("Constructor")+
		"#{@className}::#{@className}()\n"+
		"{\n"+
		"\t_clear();\n"+
		"}\n"
	end

	def makeDestructor
		destructor = "\n"+
		makeMethodComment("Destructor")+
		"#{@className}::~#{@className}()\n"+
		"{\n"+
		"\t_destroy();\n"+
		"}\n"
	end

	def publicMethod
		publicMethodText = ""
		@method.each do |key, value|
			if value.key? "public"
				value['public'].each do |m|
					publicMethodText += makeMethod(m)
				end
			end
		end
		return publicMethodText
	end

	def privateMethod
		privateMethodText = ""
		@method.each do |key, value|
			if value.key? "private"
				value['private'].each do |m|
					privateMethodText += makeMethod(m)
				end
			end
		end
		return privateMethodText
	end


	def makeClear
		clear = "\n"+
		makeMethodComment("clear")+
		"void #{@className}::_clear()\n"+
		"{\n"+
		"}\n"
	end

	def makeDestroy
		destroy = "\n"+
		makeMethodComment("destroy")+
		"void #{@className}::_destroy()\n"+
		"{\n"+
		"}\n"
	end
	def makeMethod param, methodContext = ""

		methodText = makeMethodComment(param["name"])
		#return param
		methodText += param["return"] + "\s"
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
end
