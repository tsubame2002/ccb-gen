#!/usr/bin/ruby

require_relative "./fileMaker"

class CppHeaderMaker < FileMaker

	def initialize config, className, member = [], includeFile = [], superClass = [], method = []
		@fileType = ".h"
		@config = config
		@className = className
		@member = member
		@includeFile = includeFile
		@superClass = superClass
		@method = method
	end

	def makeFile
		header+
#include
		includeFiles+
#class start
		classStart+
#public constructor & destructor
		makePublic+
		makeConstructor+
		makeDestructor+

#public method
		publicMethod+
#private method
		privateMethod+
#private member
		privateMember+

#class end
		classEnd+
#includeGuardEnd
		makeIncludeGuardEnd
	end

	def header
		makeHeaderComment+
		makeIncludeGuardStart
	end
	def includeFiles
		includeText = ""
		@includeFile["header"].each do |value|
			includeText += "#include \"#{value}.h\"\n"
		end
		return includeText

	end
	def classStart
		classStartText = "class #{@className}"
		i = 0
		@superClass.each do |className|
			if i == 0
				classStartText += " : public #{className}"
			else
				classStartText += ", public #{className}"
			end
			i += 1
		end
		classStartText += "\n{\n"
		return classStartText
	end

	def privateMethod
		privateMethod = ""
		privateMethod += makePrivate
		privateMethod += makeClear
		privateMethod += makeDestroy
		privateMethod += makePrivate
		@method.each do |key, value|
			if value.key? "private"
				value['private'].each do |m|
					privateMethod += makeMethod(m)
				end
			end
		end
		return privateMethod
	end
	
	def publicMethod
		publicMethodText = ""
		publicMethodText += makePublic

		@method.each do |key, value|
			if value.key? "public"
				value['public'].each do |m|
					publicMethodText += makeMethod(m)
				end
			end
		end
		return publicMethodText
	end
	def privateMember
		makePrivate+
		makeMember
	end

	def makeIncludeGuardStart
		"\n"+
		"#ifndef __#{@config['projectName']}__#{@className}__\n"+
		"#define __#{@config['projectName']}__#{@className}__\n"+
		"\n"
	end

	def makeConstructor
		return "\t#{@className}();\n"
	end
	def makeDestructor
		return "\tvirtual ~#{@className}();\n"
	end

	def makeClear
		return "\tvoid _clear();\n"
	end
	def makeDestroy
		return "\tvoid _destroy();\n"
	end

	def makeMember
		members = ""
		member.each do |key, value|
			members += "\t#{value}\t#{key};\n"
		end
		return members
	end

	def classEnd
		return "};\n"
	end

	def makeIncludeGuardEnd
		"\n"+
		"#endif /* defined(__#{@config['projectName']}__#{@className}__) */\n"
	end

	def makeMethod param
		methodText = "\t"
		#virtual
		if param["virtual"] == 1
			methodText += "virtual\s"
		end
		#return param
		methodText += param["return"] + "\s"
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
		methodText += ");\n"
		return methodText
	end

private
	def makePublic
		"public:\n"
	end
	def makePrivate
		"private:\n"
	end
end
