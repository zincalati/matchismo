//
//  Card.h
//  Matchismo
//
//  Created by Tyler Louie on 2/6/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (nonatomic, getter=isFaceUp) BOOL faceUp;
@property (nonatomic, getter=isUnplayable) BOOL unplayable;
@property (strong, nonatomic) NSString *comparisonResults;

- (int)match:(NSArray *)otherCards;
- (NSString *)getContents;

@end
