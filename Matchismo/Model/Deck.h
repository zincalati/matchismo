//
//  Deck.h
//  Matchismo
//
//  Created by Tyler Louie on 2/6/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

- (void)addCard:(Card *)card atTop:(BOOL)atTop;

- (Card *)drawRandomCard;

@end
