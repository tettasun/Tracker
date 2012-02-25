//
//  Player.h
//  Turrets
//
//  Created by 哲太郎 村上 on 12/02/13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "cocos2d.h"

@interface Player : CCSprite {
    CCSprite *mySprite;
}
- (id)initWithX:(float)x;
- (void)update;
- (void)setParticle;
@end
