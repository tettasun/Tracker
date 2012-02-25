//
//  Player.m
//  Turrets
//
//  Created by 哲太郎 村上 on 12/02/13.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Player.h"


@implementation Player

- (void)setParticle
{
    CCParticleSystem *particle = [CCParticleSystemQuad particleWithFile:@"player.plist"];
    
    [self addChild:particle];
    particle.position = ccp(25,25);   
}





- (void)update
{
    
    
    self.position = ccp(self.position.x,self.position.y + 10);
    
    
}


@end
