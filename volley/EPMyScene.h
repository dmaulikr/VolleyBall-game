//
//  EPMyScene.h
//  volley
//

//  Copyright (c) 2013 Eduard Pyatnitsyn. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import <CoreMotion/CoreMotion.h>

@interface EPMyScene : SKScene
@property (nonatomic) SKSpriteNode * player;
@property (nonatomic) SKSpriteNode * ball;
@property (nonatomic) SKSpriteNode * steel;
@property (nonatomic) SKSpriteNode * background;

@property (nonatomic) BOOL matchStart;
@property (nonatomic) CGSize sceneSize;
@property (strong) CMMotionManager* motionManager;

-(void) start;
-(void) initPlayer;
-(void) initStage;
@end
