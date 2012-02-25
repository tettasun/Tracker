//
//  Title.m
//  Tracker
//
//  Created by 哲太郎 村上 on 12/02/16.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Title.h"
#import "Stage1.h"
#import "CCTransition.h"

@implementation Title
+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Title *layer = [Title node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

-(id) init
{
    
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        CCLabelTTF *label = [CCLabelTTF labelWithString:@"Tracker" fontName:@"Marker Felt" fontSize:40];
        label.position = ccp(160,240);
        [self addChild:label];
        
        CCLabelTTF *label2 = [CCLabelTTF labelWithString:@"tap to start." fontName:@"Marker Felt" fontSize:20];
        label2.position = ccp(160,200);
        [self addChild:label2];
        
            

        
        self.isTouchEnabled = YES;
    }
	return self;
    
}



- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CCTransitionJumpZoom *trans = [CCTransitionJumpZoom transitionWithDuration:1 scene:[Stage1 scene]];    
    [[CCDirector sharedDirector] replaceScene:trans];
    
}


    
@end
