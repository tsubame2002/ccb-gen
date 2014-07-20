
//
//  LeagueUser.cpp
//  flyingstone
//
//  Created by mkume on 2014/07/21.
//  Copyright (c) 2014年 CROOZ. All rights reserved.
//

#include "LeagueUser.h"

#define ANIMATION_HIDE__TROPHY "Hide_Trophy"
#define ANIMATION_FRIEND__PRESENT "Friend_Present"
#define ANIMATION_START "Start"
#define ANIMATION_END "End"
#define ANIMATION_HIDE_USER "Hide_user"
#define ANIMATION_PRESENT_THANKYOU "PresentThankyou"
#define ANIMATION_GET__TROPHY "Get_Trophy"

/**
 * Constructor
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
LeagueUser::LeagueUser()
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
LeagueUser::~LeagueUser()
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
void LeagueUser::_clear()
{
	m_island	 = NULL;
	m_userImage	 = NULL;
	m_levelText	 = NULL;
	m_sheldPotision	 = NULL;
	m_userName	 = NULL;
	m_revengeNode	 = NULL;
	m_textTime	 = NULL;
	m_progressBg	 = NULL;
	m_progressMask	 = NULL;
	m_progressBar	 = NULL;
	m_progressHi	 = NULL;
	m_progressNode	 = NULL;
	m_photoFrame	 = NULL;
	m_trophyLabel	 = NULL;
	m_nodeTrophyNum	 = NULL;
	m_addTrophyNum	 = NULL;
	m_trophy	 = NULL;
	m_smokeStageNode	 = NULL;
	m_smokeEffect1	 = NULL;
	m_smokeEffect2	 = NULL;
	m_smokeEffect3	 = NULL;
	m_thankyouLabel	 = NULL;
	m_marker	 = NULL;
}

/**
 * _destroy
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_destroy()
{
	CC_SAFE_RELEASE_NULL(m_island);
	CC_SAFE_RELEASE_NULL(m_userImage);
	CC_SAFE_RELEASE_NULL(m_levelText);
	CC_SAFE_RELEASE_NULL(m_sheldPotision);
	CC_SAFE_RELEASE_NULL(m_userName);
	CC_SAFE_RELEASE_NULL(m_revengeNode);
	CC_SAFE_RELEASE_NULL(m_textTime);
	CC_SAFE_RELEASE_NULL(m_progressBg);
	CC_SAFE_RELEASE_NULL(m_progressMask);
	CC_SAFE_RELEASE_NULL(m_progressBar);
	CC_SAFE_RELEASE_NULL(m_progressHi);
	CC_SAFE_RELEASE_NULL(m_progressNode);
	CC_SAFE_RELEASE_NULL(m_photoFrame);
	CC_SAFE_RELEASE_NULL(m_trophyLabel);
	CC_SAFE_RELEASE_NULL(m_nodeTrophyNum);
	CC_SAFE_RELEASE_NULL(m_addTrophyNum);
	CC_SAFE_RELEASE_NULL(m_trophy);
	CC_SAFE_RELEASE_NULL(m_smokeStageNode);
	CC_SAFE_RELEASE_NULL(m_smokeEffect1);
	CC_SAFE_RELEASE_NULL(m_smokeEffect2);
	CC_SAFE_RELEASE_NULL(m_smokeEffect3);
	CC_SAFE_RELEASE_NULL(m_thankyouLabel);
	CC_SAFE_RELEASE_NULL(m_marker);
}

/**
 * onRegisterVariable
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
bool LeagueUser::onRegisterVariable(Ref* pTarget, const char* name, Node* pNode)
{
	DIALOG_REGISTER_VARIABLE_NODE(this, "island", Sprite*, m_island);
	DIALOG_REGISTER_VARIABLE_NODE(this, "userImage", Node*, m_userImage);
	DIALOG_REGISTER_VARIABLE_NODE(this, "levelText", FLabelFont*, m_levelText);
	DIALOG_REGISTER_VARIABLE_NODE(this, "sheldPotision", Node*, m_sheldPotision);
	DIALOG_REGISTER_VARIABLE_NODE(this, "userName", FLabelFont*, m_userName);
	DIALOG_REGISTER_VARIABLE_NODE(this, "revengeNode", Node*, m_revengeNode);
	DIALOG_REGISTER_VARIABLE_NODE(this, "textTime", FLabelFont*, m_textTime);
	DIALOG_REGISTER_VARIABLE_NODE(this, "progressBg", Sprite*, m_progressBg);
	DIALOG_REGISTER_VARIABLE_NODE(this, "progressMask", Sprite*, m_progressMask);
	DIALOG_REGISTER_VARIABLE_NODE(this, "progressBar", Sprite*, m_progressBar);
	DIALOG_REGISTER_VARIABLE_NODE(this, "progressHi", Sprite*, m_progressHi);
	DIALOG_REGISTER_VARIABLE_NODE(this, "progressNode", Node*, m_progressNode);
	DIALOG_REGISTER_VARIABLE_NODE(this, "photoFrame", Sprite*, m_photoFrame);
	DIALOG_REGISTER_VARIABLE_NODE(this, "trophyLabel", FLabelFont*, m_trophyLabel);
	DIALOG_REGISTER_VARIABLE_NODE(this, "nodeTrophyNum", Node*, m_nodeTrophyNum);
	DIALOG_REGISTER_VARIABLE_NODE(this, "addTrophyNum", FLabelFont*, m_addTrophyNum);
	DIALOG_REGISTER_VARIABLE_NODE(this, "trophy", Node*, m_trophy);
	DIALOG_REGISTER_VARIABLE_NODE(this, "smokeStageNode", Node*, m_smokeStageNode);
	DIALOG_REGISTER_VARIABLE_NODE(this, "smokeEffect1", Node*, m_smokeEffect1);
	DIALOG_REGISTER_VARIABLE_NODE(this, "smokeEffect2", Node*, m_smokeEffect2);
	DIALOG_REGISTER_VARIABLE_NODE(this, "smokeEffect3", Node*, m_smokeEffect3);
	DIALOG_REGISTER_VARIABLE_NODE(this, "thankyouLabel", FLabelFont*, m_thankyouLabel);
	DIALOG_REGISTER_VARIABLE_NODE(this, "marker", Node*, m_marker);

	return false;
}

/**
 * _runHideTrophy
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_runHideTrophy()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_HIDE__TROPHY);
	m_animationManager->setDelegate(this);
}

/**
 * _runFriendPresent
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_runFriendPresent()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_FRIEND__PRESENT);
	m_animationManager->setDelegate(this);
}

/**
 * _runStart
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_runStart()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_START);
	m_animationManager->setDelegate(this);
}

/**
 * _runEnd
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_runEnd()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_END);
	m_animationManager->setDelegate(this);
}

/**
 * _runHideUser
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_runHideUser()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_HIDE_USER);
	m_animationManager->setDelegate(this);
}

/**
 * _runPresentThankyou
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_runPresentThankyou()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_PRESENT_THANKYOU);
	m_animationManager->setDelegate(this);
}

/**
 * _runGetTrophy
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_runGetTrophy()
{
	m_animationManager = dynamic_cast<CCBAnimationManager*>(getUserObject());
	m_animationManager->runAnimationsForSequenceNamed(ANIMATION_GET__TROPHY);
	m_animationManager->setDelegate(this);
}

/**
 * _callbackUserEffect1
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_callbackUserEffect1(Node* pTarget)
{
}

/**
 * _callbackStageSmokeStart
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_callbackStageSmokeStart(Node* pTarget)
{
}

/**
 * _callbackSmokeEffect1
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_callbackSmokeEffect1(Node* pTarget)
{
}

/**
 * _callbackSmokeEffect2
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_callbackSmokeEffect2(Node* pTarget)
{
}

/**
 * _callbackSmokeEffect3
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::_callbackSmokeEffect3(Node* pTarget)
{
}

/**
 * beginDialog
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::beginDialog()
{
}

/**
 * endDialog
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::endDialog()
{
}

/**
 * update
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
void LeagueUser::update(float dt)
{
}

/**
 * onResolveCCBCCMenuItemSelector
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
SEL_MenuHandler LeagueUser::onResolveCCBCCMenuItemSelector(Ref* pTarget, const char* name)
{
}

/**
 * onResolveCCBCCCallFuncSelector
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
SEL_CallFuncN LeagueUser::onResolveCCBCCCallFuncSelector(Ref* pTarget, const char* name)
{
	DIALOG_REGISTER_CALLBACK(this, "UserEffect1", LeagueUser::_callbackUserEffect1);
	DIALOG_REGISTER_CALLBACK(this, "StageSmokeStart", LeagueUser::_callbackStageSmokeStart);
	DIALOG_REGISTER_CALLBACK(this, "SmokeEffect1", LeagueUser::_callbackSmokeEffect1);
	DIALOG_REGISTER_CALLBACK(this, "SmokeEffect2", LeagueUser::_callbackSmokeEffect2);
	DIALOG_REGISTER_CALLBACK(this, "SmokeEffect3", LeagueUser::_callbackSmokeEffect3);
	return NULL;
}

/**
 * onResolveCCBCCControlSelector
 * 
 * @author mkume
 * @since 2014/07/21
 * 
 **/
cocos2d::extension::Control::Handler LeagueUser::onResolveCCBCCControlSelector(Ref* pTarget, const char* name)
{
}

