
//
//  AgreementInfoPopupUI.cpp
//  flyingstone
//
//  Created by mkume on 2014/07/21.
//  Copyright (c) 2014年 CROOZ. All rights reserved.
//

#include "AgreementInfoPopupUI.h"
#include "UIManager.h"

#define ANIMATION_POPUP_OPEN "PopupOpen"
#define ANIMATION_POPUP_CLOSE "PopupClose"

/**
 * Constructor
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
AgreementInfoPopupUI::AgreementInfoPopupUI()
{
	_clear();
}

/**
 * Destructor
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
AgreementInfoPopupUI::~AgreementInfoPopupUI()
{
	_destroy();
}
/**
 * _clear
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::_clear()
{
	m_loadingObjNode	 = NULL;
	m_closeButton	 = NULL;
	m_returnButton	 = NULL;
	m_TopLeftOffset	 = NULL;
	m_BottomRightOffset	 = NULL;
}

/**
 * _destroy
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::_destroy()
{
	CC_SAFE_RELEASE_NULL(m_loadingObjNode);
	CC_SAFE_RELEASE_NULL(m_closeButton);
	CC_SAFE_RELEASE_NULL(m_returnButton);
	CC_SAFE_RELEASE_NULL(m_TopLeftOffset);
	CC_SAFE_RELEASE_NULL(m_BottomRightOffset);
}

/**
 * onRegisterVariable
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
bool AgreementInfoPopupUI::onRegisterVariable(Ref* pTarget, const char* name, Node* pNode)
{
	_setSuperButtonListener(name, pNode);

	DIALOG_REGISTER_VARIABLE_NODE(this, "loadingObjNode", Node*, m_loadingObjNode);
	DIALOG_REGISTER_VARIABLE_NODE(this, "TopLeftOffset", Node*, m_TopLeftOffset);
	DIALOG_REGISTER_VARIABLE_NODE(this, "BottomRightOffset", Node*, m_BottomRightOffset);

	return false;
}

/**
 * _runPopupOpen
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::_runPopupOpen()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_POPUP_OPEN);
	m_animationManager->setDelegate(this);
}

/**
 * _runPopupClose
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::_runPopupClose()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_POPUP_CLOSE);
	m_animationManager->setDelegate(this);
}

/**
 * update
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::update(float dt)
{
}

/**
 * beginDialog
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::beginDialog()
{
}

/**
 * endDialog
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::endDialog()
{
}

/**
 * onRegisterCallFunction
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
SEL_CallFuncN AgreementInfoPopupUI::onRegisterCallFunction(Ref* pTarget, const char* name)
{
}

/**
 * completedAnimationSequenceNamed
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::completedAnimationSequenceNamed(const char* name)
{
	if(strcmp(name, ANIMATION_POPUP_OPEN) == 0)
	{
	}
	if(strcmp(name, ANIMATION_POPUP_CLOSE) == 0)
	{
	}
	m_animationManager->setDelegate(NULL);
}

/**
 * onResolveCCBCCMenuItemSelector
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
SEL_MenuHandler AgreementInfoPopupUI::onResolveCCBCCMenuItemSelector(Ref* pTarget, const char* name)
{
}

/**
 * onResolveCCBCCCallFuncSelector
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
SEL_CallFuncN AgreementInfoPopupUI::onResolveCCBCCCallFuncSelector(Ref* pTarget, const char* name)
{
}

/**
 * onResolveCCBCCControlSelector
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
cocos2d::extension::Control::Handler AgreementInfoPopupUI::onResolveCCBCCControlSelector(Ref* pTarget, const char* name)
{
}

/**
 * onTap
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::onTap(SuperButton* pButton, Touch* pTouch)
{
	int buttonId = pButton->getId();
}

/**
 * _setSuperButtonListener
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void AgreementInfoPopupUI::_setSuperButtonListener(const char* name, Node* pNode)
{
	if ( name == strstr(name, "closeButton")) {
		m_closeButton = static_cast<SuperButton*>(pNode);
		m_closeButton->setListener(this);
		m_closeButton->setId();
	} else if ( name == strstr(name, "returnButton")) {
		m_returnButton = static_cast<SuperButton*>(pNode);
		m_returnButton->setListener(this);
		m_returnButton->setId();
	}
}

