//
//  PlayingCard.m
//  Matchismo
//
//  Created by Tyler Louie on 2/8/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

#define UNIT_WIN_SCORE 1

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    PlayingCard *other1 = nil;
    
    switch (otherCards.count) {
        case 1:
        {
            other1 = otherCards[0];
            
            if ([other1.suit isEqualToString:self.suit]) {
                score = UNIT_WIN_SCORE * 2;     // 2-card 2/2 suit match
                NSLog(@"2-card, 2/2 suit match");
            } else if (other1.rank == self.rank) {
                score = UNIT_WIN_SCORE * 4;     // 2-card 2/2 rank match
                NSLog(@"2-card, 2/2 rank match");
            }
            self.comparisonResults = [NSString stringWithFormat:@"%@ & %@",other1.contents,self.contents];
        }
        break;
        case 2:
        {
            other1 = otherCards[0];
            PlayingCard *other2 = otherCards[1];
            
            // Check rank matches (harder)
            if (self.rank == other1.rank) {
                if (self.rank == other2.rank) {
                    score = UNIT_WIN_SCORE * 6;     // 3-card 3/3 rank match
                    self.comparisonResults = [NSString stringWithFormat:@"%@ & %@ & %@",other1.contents,other2.contents,self.contents];
                    NSLog(@"3-card, 3/3 rank match");
                    break;
                }
                else {
                    score = UNIT_WIN_SCORE * 3;     // 3-card 2/3 rank match
                    self.comparisonResults = [NSString stringWithFormat:@"%@ & %@",self.contents,other1.contents];
                    NSLog(@"3-card, 2/3 rank match");
                }
            }
            else if (self.rank == other2.rank) {
                score = UNIT_WIN_SCORE * 3;     // 3-card 2/3 rank match
                self.comparisonResults = [NSString stringWithFormat:@"%@ & %@",self.contents,other2.contents];
                NSLog(@"3-card, 2/3 rank match");
            }
            else if (other1.rank == other2.rank) {
                score = UNIT_WIN_SCORE * 3;     // 3-card 2/3 rank match
                self.comparisonResults = [NSString stringWithFormat:@"%@ & %@",other1.contents,other2.contents];
                NSLog(@"3-card, 2/3 rank match");
            }
            
            // Check suit matches (easier)
            else if ([self.suit isEqualToString:other1.suit]) {
                if ([self.suit isEqualToString:other2.suit]) {
                    score = UNIT_WIN_SCORE * 5;     // 3-card 3/3 suit match
                    self.comparisonResults = [NSString stringWithFormat:@"%@ & %@ & %@",other1.contents,other2.contents,self.contents];
                    NSLog(@"3-card, 3/3 suit match");
                    break;
                }
                else {
                    score = UNIT_WIN_SCORE * 1;     // 3-card 2/3 suit match
                    self.comparisonResults = [NSString stringWithFormat:@"%@ & %@",self.contents,other1.contents];
                    NSLog(@"3-card, 2/3 suit match");
                }
            }
            else if ([self.suit isEqualToString:other2.suit]) {
                score = UNIT_WIN_SCORE * 1;     // 3-card 2/3 suit match
                self.comparisonResults = [NSString stringWithFormat:@"%@ & %@",self.contents,other2.contents];
                NSLog(@"3-card, 2/3 suit match");
            }
            else if ([other1.suit isEqualToString:other2.suit]) {
                score = UNIT_WIN_SCORE * 1;     // 3-card 2/3 suit match
                self.comparisonResults = [NSString stringWithFormat:@"%@ & %@",other1.contents,other2.contents];
                NSLog(@"3-card, 2/3 suit match");
            }
            else {
                self.comparisonResults = [NSString stringWithFormat:@"%@ & %@ & %@",other1.contents,other2.contents,self.contents];
            }
        }
        break;
        default:
            break;
    }
    
    return score;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit;   // because we provide setter AND getter
                            // @synthesize automatically created by compiler normally

+ (NSArray *)validSuits     // class method aka helper method, signified by +
{
    return @[@"♥",@"♦",@"♠",@"♣"];
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [self rankStrings].count-1; }

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
