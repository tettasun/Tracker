//
//  Stage1.m
//  Balloon
//
//  Created by 哲太郎 村上 on 12/02/11.
//  Copyright 2012年 __MyCompanyName__. All rights reserved.
//

#import "Stage1.h"
#import "SimpleAudioEngine.h"
#import "Title.h"




// enums that will be used as tags
enum {
	kTagcollisionMap = 1,
	kTagBatchNode = 1,
	kTagAnimation1 = 1,
};


@implementation Stage1

+(CCScene *) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Stage1 *layer = [Stage1 node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
    
    state = 1;
    startFlg = NO;
    dy = 0;
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init])) {
        
        [[SimpleAudioEngine sharedEngine] preloadEffect:@"bomb2.caf"];
        
		// enable touches
		self.isTouchEnabled = YES;
		
		// enable accelerometer
		self.isAccelerometerEnabled = YES;
		
        CCSprite *zone = [CCSprite spriteWithFile:@"zone.png"];
        zone.position = ccp(160,50);
        [self addChild:zone];
        
		CGSize screenSize = [CCDirector sharedDirector].winSize;
		CCLOG(@"Screen width %0.2f screen height %0.2f",screenSize.width,screenSize.height);
		
        
        
        collisionMap = [CCTMXTiledMap tiledMapWithTMXFile:@"background.tmx"];
        colLayer = [collisionMap layerNamed:@"collision"];
        objLayer = [collisionMap layerNamed:@"objective"];
        //colLayer.visible = NO;
        
        
        player = [Player spriteWithFile:@"player.png"];
        player.position = ccp(160,OFFSET);
        [player setParticle];
        [self addChild:player];
        [player setParticle];
        
        [self addChild:collisionMap z:-1 tag:1]; 
        
        score = 0;
        scoreLabel = [CCLabelTTF labelWithString:@"" fontName:@"Marker Felt" fontSize:20];
        scoreLabel.position = ccp(280,460);
        [self addChild:scoreLabel];
        
        [self schedule: @selector(tick:)];
        
        
        
        
	}
	return self;
    
    
}

- (void)updateScore:(int)point
{
    score = score + point;
    scoreLabel.string = [NSString stringWithFormat:@"%d",score];
    
}

-(void) draw
{
	// Default GL states: GL_TEXTURE_2D, GL_VERTEX_ARRAY, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	// Needed states:  GL_VERTEX_ARRAY, 
	// Unneeded states: GL_TEXTURE_2D, GL_COLOR_ARRAY, GL_TEXTURE_COORD_ARRAY
	glDisable(GL_TEXTURE_2D);
	glDisableClientState(GL_COLOR_ARRAY);
	glDisableClientState(GL_TEXTURE_COORD_ARRAY);
	
	//world->DrawDebugData();
	
	// restore default GL states
	glEnable(GL_TEXTURE_2D);
	glEnableClientState(GL_COLOR_ARRAY);
	glEnableClientState(GL_TEXTURE_COORD_ARRAY);
    
}

// Add new method
- (CGPoint)tileCoordForPosition:(CGPoint)position {
    int x = position.x / collisionMap.tileSize.width;
    int y = ((collisionMap.mapSize.height * collisionMap.tileSize.height) - position.y) / collisionMap.tileSize.height;
    return ccp(x, y);
}
-(void)handleCollision
{
    if (state != 1) {
        return;
    }
    
    CGPoint realP = ccp(player.position.x,player.position.y - colLayer.position.y);
    
    CGPoint tileCoord = [self tileCoordForPosition:realP];
    int tileGid = [colLayer tileGIDAt:tileCoord];
    if (tileGid) {
        NSLog(@"coll");
        [self gameOver];
        /*
         NSDictionary *properties = [collisionMap propertiesForGID:tileGid];
         if (properties) {
         NSString *collision = [properties valueForKey:@"Collidable"];
         if (collision && [collision compare:@"True"] == NSOrderedSame) {
         NSLog(@"coll");
         return;
         }
         }
         */
    }
    int tileGid2 = [objLayer tileGIDAt:tileCoord];
    if (tileGid2) {
        NSLog(@"clear");
        [self gameClear];
        
    }
}

-(void) tick: (ccTime) dt
{
    int x = 0;
//    static int count = 0;
//    
//    if (count > 30){
//        
//        if (dy > 300) {
//            dy = dy + 1;
//        }else {
//            dy = dy - 1;
//            
//        }
//        count = 0;
//    }
//    count++;
    if (startFlg == YES && state == 1) {
        dy = dy -SPEED;
        [self updateScore:SPEED];
    //    self.position = ccp(x,dy);
        colLayer.position = ccp(x,dy);
        objLayer.position = ccp(x,dy);

        
    }
    
    
    [self handleCollision];
}


- (void)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    
            
    // 一番目のタッチを得る
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    // タッチした場所を得る
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    if (location.y < 100) {
        
        startFlg = YES;
        
    }
    
}

- (void)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    // 一番目のタッチを得る
    UITouch *touch = [[touches allObjects] objectAtIndex:0];
    
    // タッチした場所を得る
    CGPoint location = [self convertTouchToNodeSpace: touch];
    
    
    if (location.y < 100) {

        if (state == 1 ){
            player.position = ccp(location.x,location.y+OFFSET);
            
        }
        
    }
    
    
    
}

- (void)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self gameOver];
}

- (void)gameClear{
    
    
    state = 2;
    CCLabelTTF *label = [CCLabelTTF labelWithString:@"GAME CLEARED" fontName:@"Marker Felt" fontSize:40];
    label.position = ccp(160,240);
    [self addChild:label];
    colLayer.visible = NO;
    
    [[SimpleAudioEngine sharedEngine] playEffect:@"warp.caf"];
    [self performSelector:@selector(reset) withObject:nil afterDelay:1];
}


- (void)gameOver{
    
    if (state ==2 ) {
        
    }else{
        
        id act_move = [CCMoveTo actionWithDuration: 0.5 position:ccp(160,240)];
        id scl_move = [CCScaleTo actionWithDuration:0.5 scale:3 ];

        CCSequence *sq = [CCSequence actions:act_move,scl_move, nil];
        
        [scoreLabel runAction:sq];
        
        
         AudioServicesPlaySystemSound(kSystemSoundID_Vibrate); 
        
        state = 0;
        
        colLayer.visible = NO;
        CCParticleSystem *particle = [CCParticleSystemQuad particleWithFile:@"gameover.plist"];
        
        [self addChild:particle];
        particle.position = player.position;
        
        player.position = ccp(160,-1000);
        
        
        [[SimpleAudioEngine sharedEngine] playEffect:@"bomb2.caf"];
        
        [self performSelector:@selector(reset) withObject:nil afterDelay:3];
    }
    
    
    
}

- (void)reset{
   // AudioServicesRemoveSystemSoundCompletion(kSystemSoundID_Vibrate);
    
    CCTransitionJumpZoom *trans = [CCTransitionJumpZoom transitionWithDuration:1 scene:[Title scene]];
    [[CCDirector sharedDirector] replaceScene:trans];}
@end
