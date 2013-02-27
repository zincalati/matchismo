//
//  Card.m
//  Matchismo
//
//  Created by Tyler Louie on 2/6/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
            score = 1;
        }
    }
    
    return score;
}

- (NSString *)getContents { return self.contents; }

- (NSString *)getComparisonResults { return self.comparisonResults; }

@end
