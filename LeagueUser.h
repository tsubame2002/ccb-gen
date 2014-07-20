
//
//  LeagueUser.h
//  flyingstone
//
//  Created by mkume on 2014/07/21.
//  Copyright (c) 2014年 CROOZ. All rights reserved.
//


#ifndef __flyingstone__LeagueUser__
#define __flyingstone__LeagueUser__

#include "Common.h"
#include "SuperButton.h"
class LeagueUser : public SuperButton
{
public:
	LeagueUser();
	virtual ~LeagueUser();
public:
	CREATE_FUNC(LeagueUser);

public:
	virtual void beginDialog();
	virtual void endDialog();
	virtual void update(float dt);
	virtual SEL_MenuHandler onResolveCCBCCMenuItemSelector(Ref* pTarget, const char* name);
	virtual SEL_CallFuncN onResolveCCBCCCallFuncSelector(Ref* pTarget, const char* name);
	virtual cocos2d::extension::Control::Handler onResolveCCBCCControlSelector(Ref* pTarget, const char* name);
private:
	void _clear();
	void _destroy();
private:
	void _runHideTrophy();
	void _runFriendPresent();
	void _runStart();
	void _runEnd();
	void _runHideUser();
	void _runPresentThankyou();
	void _runGetTrophy();
	void _callbackUserEffect1(Node* pTarget);
	void _callbackStageSmokeStart(Node* pTarget);
	void _callbackSmokeEffect1(Node* pTarget);
	void _callbackSmokeEffect2(Node* pTarget);
	void _callbackSmokeEffect3(Node* pTarget);
private:
	Sprite*	m_island;
	Node*	m_userImage;
	FLabelFont*	m_levelText;
	Node*	m_sheldPotision;
	FLabelFont*	m_userName;
	Node*	m_revengeNode;
	FLabelFont*	m_textTime;
	Sprite*	m_progressBg;
	Sprite*	m_progressMask;
	Sprite*	m_progressBar;
	Sprite*	m_progressHi;
	Node*	m_progressNode;
	Sprite*	m_photoFrame;
	FLabelFont*	m_trophyLabel;
	Node*	m_nodeTrophyNum;
	FLabelFont*	m_addTrophyNum;
	Node*	m_trophy;
	Node*	m_smokeStageNode;
	Node*	m_smokeEffect1;
	Node*	m_smokeEffect2;
	Node*	m_smokeEffect3;
	FLabelFont*	m_thankyouLabel;
	Node*	m_marker;
	CCBAnimationManager* m_animationManager;
};

#endif /* defined(__flyingstone__LeagueUser__) */
