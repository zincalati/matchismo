//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Tyler Louie on 2/9/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// Designated Initializer
- (id)initWithCardCount:(NSUInteger)cardCount
              usingDeck:(Deck *)deck;

- (Card *)cardAtIndex:(NSUInteger)index;

- (void)flipCardAtIndex:(NSUInteger)index;

- (void)setGameMode:(NSInteger)selectedGameIndex;

@property (nonatomic, readonly) NSInteger currentGameMode;

@property (nonatomic, readonly) int score;

@property (nonatomic, readonly) NSString *flipResults;

@property (nonatomic, readonly) NSMutableArray *flipResultsHistory;

@end
