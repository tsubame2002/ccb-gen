
//
//  AgreementInfoPopupUI.h
//  flyingstone
//
//  Created by mkume on 2014/07/21.
//  Copyright (c) 2014年 CROOZ. All rights reserved.
//


#ifndef __flyingstone__AgreementInfoPopupUI__
#define __flyingstone__AgreementInfoPopupUI__

#include "Common.h"
#include "LayerDialog.h"
#include "SuperButton.h"
class AgreementInfoPopupUI : public LayerDialog, public SuperButton::Listener
{
public:
	AgreementInfoPopupUI();
	virtual ~AgreementInfoPopupUI();
public:
	CREATE_FUNC(AgreementInfoPopupUI);

public:
	virtual void update(float dt);
	virtual void beginDialog();
	virtual void endDialog();
	virtual SEL_CallFuncN onRegisterCallFunction(Ref* pTarget, const char* name);
	virtual void completedAnimationSequenceNamed(const char* name);
	virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref* pTarget, const char* name);
	virtual SEL_CallFuncN onResolveCCBCCCallFuncSelector(Ref* pTarget, const char* name);
	virtual cocos2d::extension::Control::Handler onResolveCCBCCControlSelector(Ref* pTarget, const char* name);
	virtual void onTap(SuperButton* pButton, Touch* pTouch);
private:
	void _clear();
	void _destroy();
private:
	void _setSuperButtonListener(const char* name, Node* pNode);
	void _runPopupOpen();
	void _runPopupClose();
private:
	Node*	m_loadingObjNode;
	SuperButton*	m_closeButton;
	SuperButton*	m_returnButton;
	Node*	m_TopLeftOffset;
	Node*	m_BottomRightOffset;
	CCBAnimationManager* m_animationManager;
};

#endif /* defined(__flyingstone__AgreementInfoPopupUI__) */
