require "./fileMakerConsole"
require "./ccbNodeMaker"
require "./ccbNodeHeaderMaker"


CCB_CONFIG_FILE = "ccbConfig.yml"

class CcbFileMakerConsole < FileMakerConsole
	def displayStartMenu
		system "clear"
		displayStatus
		displayClassName
		displayMember
		displayAnimation
		displayCallback
		displayMenu
	end
	def displayClassName
		putsMagenta "[ClassName]"
		puts "\s#{@className}"
		puts
	end
	def displayMember
		putsMagenta "[Member]"
		@member.each do |key, value|
			puts "\s#{value} : #{key}"
		end
		puts
	end
	def displayAnimation
		putsMagenta "[Animation]"
		@animation.each do |value|
			puts "\s#{value}"
		end
		puts
	end
	def displayCallback
		putsMagenta "[AnimationCallBack]"
		@callback.each do |value|
			puts "\s#{value}"
		end
		puts
	end
	def selectSuperClass
		system "clear"
		cnt = 1
		superClassArray = {}
		putsMagenta "[SuperClass]"
		@ccbConfig['superClass'].each do |key, value|
			puts "\s#{cnt} : #{key}"
			superClassArray[cnt] = key
			cnt += 1
		end
		putsRed "\s#{cnt} : OK"
		if @selectedSuperClass.nil?
			@selectedSuperClass = {}
		else
			putsMagenta "[Selected]"
			@selectedSuperClass.each do |key, value|
				puts "\s#{key} : #{value}"
			end
		end
		printYellow "Selet number : "
		selectedNumber = STDIN.gets
		if selectedNumber  =~ /^[0-9]+$/
			selectedNumber = selectedNumber.to_i
			if 0 < selectedNumber && selectedNumber < cnt
				@selectedSuperClass[selectedNumber] = superClassArray[selectedNumber]
				selectSuperClass
			elsif selectedNumber == cnt
					
			end
		end
	end
	def generateFile
		loadCcbConfig

		member = {}
		@member.each do |key, value|
			memberName = "m_" + key
			nodeName = value + "*"
			member[memberName] = nodeName
		end
		selectSuperClass
		method = {}
		includeFiles = {
			'header' => [],
			'cpp' => []
		}
		#superClassList & includeHeader
		superClassList = []
		@selectedSuperClass.each do |key, value|
			superClassList.push value
			if @ccbConfig['superClass'][value]['include'].key? "header"
				@ccbConfig['superClass'][value]['include']["header"].each do |headerInclude|
					includeFiles['header'].push headerInclude
				end
			end
			if @ccbConfig['superClass'][value]['include'].key? "cpp"
				@ccbConfig['superClass'][value]['include']["cpp"].each do |cppInclude|
					includeFiles['cpp'].push cppInclude
				end
			end
		end
		#method
		@selectedSuperClass.each do |key, value|
			@ccbConfig['superClass'][value]['includeClass'].each do |superClassCellName|
				unless method.key? superClassCellName
					method[superClassCellName] = @ccbConfig['method'][superClassCellName]
				end
			end
		end
		# method[value] = @ccbConfig['method'][value]
		ccbNodeMaker = CcbNodeMaker.new(@config, @className, member, includeFiles, superClassList, method)
		ccbNodeMaker.animation = @animation
		ccbNodeMaker.callback = @callback
		ccbNodeHeaderMaker = CcbNodeHeaderMaker.new(@config, @className, member, includeFiles, superClassList, method)
		ccbNodeHeaderMaker.animation = @animation
		ccbNodeHeaderMaker.callback = @callback
		
		ccbNodeMaker.generateFile
		ccbNodeHeaderMaker.generateFile
	end
	def loadCcbConfig
		@ccbConfig = YAML.load_file(CCB_CONFIG_FILE)
	end
	def syncCcbConfig
		open(CCB_CONFIG_FILE, "w") do |f|
			YAML.dump(@ccbConfig, f)
		end
	end

	attr_accessor :ccbConfig, :selectedSuperClass, :animation, :callback
end
