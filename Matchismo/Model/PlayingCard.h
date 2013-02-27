//
//  PlayingCard.h
//  Matchismo
//
//  Created by Tyler Louie on 2/8/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+ (NSArray *)validSuits;
+ (NSUInteger)maxRank;

@end
