@ccbConfig = {
	'superClass' => {
		'LayerDialog' => {
			'include' => {
				'header' => ['LayerDialog']
			},
			'includeClass' => [
				'Node',
				'LayerDialog',
				'CCBVariableRegister',
				'CCBAnimationRegister',
				'CCBSelectorResolver'
			]
		},
		'SuperButton::Listener' => {
			'include' => {
				'header' => ['SuperButton']
			},
			'includeClass' => [
				'SuperButton::Listener'
			]
		}
	},
	'method' => {
		'Node' => {
			'public' => [
				{
					'virtual' => 1,
					'return' => "void",
					'name' => "update",
					'args' => [
						{'type' => "float", 'name' => 'dt'}
					]
				}
			]
		},
		'SuperButton::Listener' => {
			'public' => [
				{
					'virtual' => 1,
					'return' => "void",
					'name' => "onTap",
					'args' => [
						{'type' => "SuperButton*", 'name' => 'pButton'},
						{'type' => "Touch*", 'name' => 'pTouch'}
					]
				}
			],
			'private' => [
				{
					'virtual' => 0,
					'return' => "void",
					'name' => "_setSuperButtonListener",
					'args' => [
						{'type' => "const char*", 'name' => 'name'},
						{'type' => "Node*", 'name' => 'pNode'}
					]
				}
			]
		},
		'LayerDialog' => {
			'public' => [
				{
					'virtual' => 1,
					'return' => "void",
					'name' => "beginDialog",
					'args' => []
				},
				{
					'virtual' => 1,
					'return' => "void",
					'name' => "endDialog",
					'args' => []
				}
			]
		},
		'CCBSelectorResolver' => {
			'public' => [
				{
					'virtual' => 1,
					'return' => "SEL_MenuHandler",
					'name' => "onResolveCCBCCMenuItemSelector",
					'args' => [
						{'type' => "Ref*", 'name' => 'pTarget'},
						{'type' => "const char*", 'name' => 'name'}
					]
				},
				{
					'virtual' => 1,
					'return' => "SEL_CallFuncN",
					'name' => "onResolveCCBCCCallFuncSelector",
					'args' => [
						{'type' => "Ref*", 'name' => 'pTarget'},
						{'type' => "const char*", 'name' => 'name'}
					]
				},
				{
					'virtual' => 1,
					'return' => "cocos2d::extension::Control::Handler",
					'name' => "onResolveCCBCCControlSelector",
					'args' => [
						{'type' => "Ref*", 'name' => 'pTarget'},
						{'type' => "const char*", 'name' => 'name'}
					]
				}
			],
		},
		'CCBAnimationRegister' => {
			'public' => [
				{
					'virtual' => 1,
					'return' => "SEL_CallFuncN",
					'name' => "onRegisterCallFunction",
					'args' => [
						{'type' => "Ref*", 'name' => 'pTarget'},
						{'type' => "const char*", 'name' => 'name'}
					]
				},
				{
					'virtual' => 1,
					'return' => "void",
					'name' => "completedAnimationSequenceNamed",
					'args' => [
						{'type' => "const char*", 'name' => 'name'}
					]
				}
			],
		},
		'CCBVariableRegister' => {
			'public' => [
				{
					'virtual' => 1,
					'return' => "SEL_MenuHandler",
					'name' => "onRegisterMenuItem",
					'args' => [
						{'type' => "Ref*", 'name' => 'pObject'},
						{'type' => "const char*", 'name' => 'name'}
					]
				},
				{
					'virtual' => 1,
					'return' => "bool",
					'name' => "onRegisterVariable",
					'args' => [
						{'type' => "Ref*", 'name' => 'pTarget'},
						{'type' => "const char*", 'name' => 'name'},
						{'type' => "Node*", 'name' => 'pNode'}
					]
				}
			]
		},
	}
}
