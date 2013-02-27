//
//  Deck.m
//  Matchismo
//
//  Created by Tyler Louie on 2/6/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import "Deck.h"

@interface Deck()
@property (strong, nonatomic) NSMutableArray *cards;    // of Card
@end

@implementation Deck

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (void)addCard:(Card *)card atTop:(BOOL)atTop
{
    if (atTop) {
        [self.cards insertObject:card atIndex:0];
    } else {
        [self.cards addObject:card];
    }
}

- (Card *)drawRandomCard
{
    Card *randomCard = nil;
    
    if (self.cards.count) {                                 // if there are cards in the deck
        unsigned index = arc4random() % self.cards.count;   // choose a random card
        randomCard = self.cards[index];                     
        [self.cards removeObjectAtIndex:index];             // draw the card and remove from deck
    }
    
    return randomCard;
}

@end
