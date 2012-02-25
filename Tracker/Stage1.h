//
//  Stage1.h
//  Turrets
//
//  Created by 哲太郎 村上 on 12/02/12.
//  Copyright __MyCompanyName__ 2012年. All rights reserved.
//


// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"
#import "Player.h"

#define SPEED 4
#define OFFSET 200

// Stage1
@interface Stage1 : CCLayer
{

    Player *player;
    CCTMXTiledMap *collisionMap;
    CCTMXLayer *colLayer;
    CCTMXLayer *objLayer;
    
    CCLabelTTF *scoreLabel;
    int score;
    
    int dy;
    BOOL state;
    BOOL startFlg;
}

// returns a CCScene that contains the Stage1 as the only child
+(CCScene *) scene;
- (void)gameClear;
- (void)gameOver;
@end
