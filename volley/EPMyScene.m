//
//  EPMyScene.m
//  volley
//
//  Created by Eduard Pyatnitsyn on 01.11.13.
//  Copyright (c) 2013 Eduard Pyatnitsyn. All rights reserved.
//

#import "EPMyScene.h"
#import <math.h>
#import <CoreMotion/CoreMotion.h>

@implementation EPMyScene{
    NSArray *_playerStayFrames;
    
}

-(void) initPlayer{
    NSArray *color = @[[SKColor redColor]
                       ,[SKColor darkGrayColor]   // 0.333 white
                       ,[SKColor lightGrayColor]  // 0.667 white
                       ,[SKColor grayColor]       // 0.5 white
                       ,[SKColor redColor]        // 1.0, 0.0, 0.0 RGB
                       ,[SKColor greenColor]      // 0.0, 1.0, 0.0 RGB
                       ,[SKColor blueColor]       // 0.0, 0.0, 1.0 RGB
                       ,[SKColor cyanColor]       // 0.0, 1.0, 1.0 RGB
                       ,[SKColor yellowColor]     // 1.0, 1.0, 0.0 RGB
                       ,[SKColor magentaColor]    // 1.0, 0.0, 1.0 RGB
                       ,[SKColor orangeColor]     // 1.0, 0.5, 0.0 RGB
                       ,[SKColor purpleColor]     // 0.5, 0.0, 0.5 RGB
                       ,[SKColor brownColor]];      // 0.6, 0.4, 0.2 RGB
    SKTextureAtlas *playerAnimatedAtlas = [SKTextureAtlas atlasNamed:@"playerBall"];
    NSMutableArray *stayFrames = [NSMutableArray array];
    NSArray *textureName  = [[playerAnimatedAtlas textureNames] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    //Load the animation frames from the TextureAtlas
    for (int i=0; i < playerAnimatedAtlas.textureNames.count; i++) {
        [stayFrames addObject:[playerAnimatedAtlas textureNamed:textureName[i]]];
    }
    _playerStayFrames = stayFrames;
    NSLog(@"%@",_playerStayFrames);
    _player = [SKSpriteNode spriteNodeWithTexture:_playerStayFrames[1]];
    _player.color = color[arc4random() % color.count];
    _player.colorBlendFactor = 0.9;
    _player.scale = 0.4;
    _player.physicsBody.restitution = 0.00002f;
    _player.position = CGPointMake(_player.anchorPoint.x,_player.anchorPoint.y);
    NSLog(@"x: %ld    y: %f      player size: %f",lroundf(_player.size.height/2),_player.position.y - _player.anchorPoint.y,round(_player.size.height/2) - round( _player.anchorPoint.y));
    _player.physicsBody = [SKPhysicsBody bodyWithCircleOfRadius:_player.size.width/2];
    _player.physicsBody.mass = 0.2;
    //[_player runAction:[SKAction repeatActionForever:[SKAction animateWithTextures:_playerStayFrames timePerFrame:0.8f resize:YES restore:YES]]];
    [self addChild:_player];
}



-(void) initStage{
    self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
    //self.physicsWorld.contactDelegate = self;
    self.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(0, 0, _sceneSize.width, _sceneSize.height )];
    _background = [SKSpriteNode spriteNodeWithImageNamed:@"background"];
    _background.position = CGPointMake(_background.size.width/2 + _background.anchorPoint.x, _background.size.height /2 + _background.anchorPoint.y);
    _background.scale = 1.15f;
    [self addChild:_background];
    
    self.ball = [SKSpriteNode spriteNodeWithImageNamed:@"ball"];
    self.ball.scale = 0.5f;
    _ball.physicsBody =  [SKPhysicsBody bodyWithCircleOfRadius:_ball.size.width/2];
    _ball.physicsBody.mass = 0.0002f;
    _ball.physicsBody.restitution = 0.00002;
    self.ball.position = CGPointMake(300,80);
    [self addChild:self.ball];
    
    _steel = [SKSpriteNode spriteNodeWithImageNamed:@"steel.png"];
    [_steel setYScale:1.5];
    _steel.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:_steel.frame.size];
    _steel.physicsBody.mass = 200.0;
    _steel.position = CGPointMake(_sceneSize.width/2, _steel.frame.size.height+_steel.anchorPoint.y);
    [self addChild:_steel];
    
    _restartLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
    _restartLabel.text = @"Restart";
    _restartLabel.color = [SKColor darkGrayColor];
    _restartLabel.colorBlendFactor = 1;
    _restartLabel.fontSize = 12;
    _restartLabel.position = CGPointMake(self.frame.size.width  - _restartLabel.frame.size.width,
                                   self.frame.size.height -17  - _restartLabel.frame.size.height);
    
    [self addChild:_restartLabel];

}




-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _sceneSize = size;
        _matchStart = YES;
        
        NSLog(@"Size: %@", NSStringFromCGSize(size));
        
        
        [self initStage];
        [self initPlayer];
        
    }
    return self;
}





#pragma mark - Jump!

- (void)touchesBegan:(NSSet *) touches withEvent:(UIEvent *)event
{
#warning Добавить обработку коллизий и применение вектора силы на мяч
    for (UITouch *touch in touches) {
        if(false){
        }else{
            _ball.physicsBody.affectedByGravity = YES;
            if(_player.position.y - _player.anchorPoint.y-_player.size.height /2 < 5){
                [_player.physicsBody applyImpulse:CGVectorMake(0, 150)];
            }
        }
    }
    
}

- (void)didMoveToView:(SKView *)view
{
    self.motionManager = [[CMMotionManager alloc] init];
    [self.motionManager startAccelerometerUpdates];
}


-(void)update:(NSTimeInterval)currentTime {
    CMAccelerometerData* data = self.motionManager.accelerometerData;
    [_player.physicsBody applyImpulse:CGVectorMake(-data.acceleration.y*10, 0)];
    if(_player.zRotation != 0 ) _player.zRotation = 0;

    if(_player.position.x  + _player.size.height/2+ _player.anchorPoint.x >= _steel.position.x - _steel.anchorPoint.x  - _player.anchorPoint.x ){
        _player.position = CGPointMake( _steel.position.x - _steel.anchorPoint.x - _player.anchorPoint.x - _player.size.width/2 , _player.position.y);
        [_player.physicsBody applyImpulse:CGVectorMake(-15, 0)];
    }

    if (_matchStart == YES){
        _matchStart = NO;
        [self start];
    }
}

-(void) start{
    _ball.position = CGPointMake(_sceneSize.width/4+_ball.anchorPoint.x , _steel.frame.size.height+_steel.anchorPoint.y - 3 * _ball.anchorPoint.y);
    _ball.physicsBody.affectedByGravity = NO;
}
@end
