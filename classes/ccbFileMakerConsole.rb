	require_relative "./fileMakerConsole"
require_relative "./ccbNodeMaker"
require_relative "./ccbNodeHeaderMaker"


CCB_CONFIG_FILE = File.expand_path(File.dirname(__FILE__) + "/../conf/ccbConfig.yml")

class CcbFileMakerConsole < FileMakerConsole
	def init
		@animation = []
		@callback = []
		@customClasses = []
	end
	def displayStartMenu
		system "clear"
		displayStatus
		displayMember
		displayAnimation
		displayCallback
		displayMenu
	end
	def displayAnimation
		unless @animation.nil?
			putsMagenta "[Animation]"
			@animation.each do |value|
				puts "\s#{value}"
			end
		end
	end
	def displayCallback
		unless @callback.nil?
			putsMagenta "[AnimationCallBack]"
			@callback.each do |value|
				puts "\s#{value}"
			end
		end
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
		unless isValid?
			startMenu
		end
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
			if @ccbConfig['superClass'][value].key? "include"
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
		end
		customClassNames = []
		@customClasses.each do |value|
			customClassNames.push value["customClass"]
		end
		customClassNames.uniq!
		customClassNames.each do |value|
			includeFiles['cpp'].push value
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
		ccbNodeMaker.customClasses = @customClasses
		ccbNodeHeaderMaker = CcbNodeHeaderMaker.new(@config, @className, member, includeFiles, superClassList, method)
		ccbNodeHeaderMaker.animation = @animation
		ccbNodeHeaderMaker.callback = @callback
		ccbNodeHeaderMaker.customClasses = @customClasses
		
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

	attr_accessor :ccbConfig, :selectedSuperClass, :animation, :callback, :customClasses
end
