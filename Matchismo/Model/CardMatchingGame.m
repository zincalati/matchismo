//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Tyler Louie on 2/9/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()  // private properties (Class Extension)
@property (strong, nonatomic) NSMutableArray *cards;   // of Card, can't express in Obj-C
@property (readwrite, nonatomic) int score;    // Make private implementation of score writeable
@property (readwrite, nonatomic) NSString *flipResults;    // Make private implementation of flipResults writeable
@property (readwrite, nonatomic) NSInteger currentGameMode;
@property (strong, nonatomic) NSMutableArray *flippedCards; // of Card, for flipCardAtIndex
@property (readwrite, nonatomic) NSMutableArray *flipResultsHistory; // of NSString, for tracking flip history
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (NSMutableArray *)flippedCards
{
    if (!_flippedCards) _flippedCards = [[NSMutableArray alloc] init];
    return _flippedCards;
}

- (NSMutableArray *)flipResultsHistory
{
    if (!_flipResultsHistory) _flipResultsHistory = [[NSMutableArray alloc] init];
    return _flipResultsHistory;
}

- (id)initWithCardCount:(NSUInteger)cardCount usingDeck:(Deck *)deck
{
    self = [super init];    // Calling designated init of superclass
    if (self) {             // If successful init
        for (int i=0; i<cardCount; i++){        // Loop through specified count of Cards
            Card *card = [deck drawRandomCard];
            if (!card) self = nil;
            else self.cards[i] = card;
        }
        self.currentGameMode = -1;      // set to -1 to initialize before game segment chosen
        NSLog(@"self.currentGameMode is: %d", self.currentGameMode);
    }
    
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    // Make sure requested index is within range of our deck
    return (index < self.cards.count) ? self.cards[index] : nil;
}

#define MATCH_BONUS 4
#define MISMATCH_PENALTY 3
#define FLIP_COST 1

// This is where the guts of the game are played!
- (void)flipCardAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];      // get card
    
    // Declare local vars for playing
    int matchScore = 0;
    
    // If card is playable...
    if (!card.isUnplayable) {
        
        // ...and card is face down and being flipped up
        if (!card.isFaceUp) {
            
            // Get the flip results and add to the history
            self.flipResults = [NSString stringWithFormat:@"Flipped up %@",card.contents];
            [self.flipResultsHistory addObject:self.flipResults];
            NSLog(@"Flip Results History for UI Slider now has %d items",self.flipResultsHistory.count);
            
            // Since we're flipping a card up, check to see if we have enough face up cards to calculate match
            if (self.currentGameMode == self.flippedCards.count+1) {
                
                // We have the right # of cards for the game, check the score results
                matchScore = [card match:self.flippedCards];
                
                // If there's a match...
                if (matchScore) {
                    
                    // ...cards become unplayable, we add to our score and update the game state
                    for (Card *c in self.flippedCards) {
                        c.unplayable = YES;
                    }
                    card.unplayable = YES;
                    self.score += matchScore * MATCH_BONUS;
                    self.flipResults = [NSString stringWithFormat:@"Matched %@\nfor %d points!",card.comparisonResults,(matchScore * MATCH_BONUS)];
                    matchScore = 0;
                    [self.flippedCards removeAllObjects];
                    NSLog(@"flippedCards is empty? %@", self.flippedCards);
                }
                
                // If there's no match...
                else {
                    
                    // ...decrement score for bad guess
                    self.score -= MISMATCH_PENALTY;
                    self.flipResults = [NSString stringWithFormat:@"%@ don't match!\n%d point penalty!",card.comparisonResults,MISMATCH_PENALTY];
                    
                    // ...and clean up state of already flippedCards
                    for (Card *c in self.flippedCards) {
                        c.faceUp = NO;
                    }
                    [self.flippedCards removeAllObjects];
                    
                    // ...and add current card to flippedCards
                    [self.flippedCards addObject:card];
                }
            }
            // If we don't have enough cards for match, add card to flippedCards
            else [self.flippedCards addObject:card];
            NSLog(@"Flipped cards count: %d", self.flippedCards.count);
            // Round over, only decrement score if card wasn't faceUp already
            self.score -= FLIP_COST;
        }
        // Otherwise, current card is faceUp and we're flipping down, so remove the card from flippedCards
        else {
            [self.flippedCards removeObject:card];
        }
        card.faceUp = !card.isFaceUp;   // toggle whether it is faceUp or not
    }
}

- (void)setGameMode:(NSInteger)selectedGameIndex
{
    self.currentGameMode = selectedGameIndex;
}

@end
