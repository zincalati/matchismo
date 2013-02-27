//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Tyler Louie on 2/6/13.
//  Copyright (c) 2013 Tyler Louie. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipResultsLabel;
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) Deck *deck;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedGameSwitch;
@property (weak, nonatomic) IBOutlet UISlider *flipHistorySlider;
@property (nonatomic) int flipHistoryCurIndex;
@end

@implementation CardGameViewController

- (Deck *)deck {
    if (!_deck) _deck = [[PlayingCardDeck alloc] init];
    
    return _deck;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:self.deck];
        self.flipHistoryCurIndex = 0;
    }
    
    return _game;
}

- (void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    
    // Set card back image
    UIImage *cardBackImage = [UIImage imageNamed:@"cardback.jpg"];
    UIEdgeInsets cardBackInsets = UIEdgeInsetsMake(3,3,3,3);
    // Put together playing cards
    for (UIButton *cardButton in cardButtons) {
        Card *card = [self.deck drawRandomCard];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setImage:cardBackImage forState:UIControlStateNormal];
        [cardButton setImageEdgeInsets:cardBackInsets];
    }
}

- (void)updateUI
{
    // Make sure that UIControlSegmented is in default state if gameMode is in default state (-1)
    if (self.game.currentGameMode == -1) {
        self.segmentedGameSwitch.selectedSegmentIndex = -1;
    }
    // If UIControlSegmented has been set to a game mode, then it will be disabled as soon as game starts playing
    else {
        self.segmentedGameSwitch.enabled = NO;
        self.flipResultsLabel.lineBreakMode = NSLineBreakByWordWrapping;
        self.flipResultsLabel.numberOfLines = 3;    // enable text wrapping
    }
    
    UIImage *transparent = [UIImage imageNamed:@"transparent.png"];
    
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        
        // Card UI states are based on card object states (whether faceUp and whether playable)
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        // Remove the image for the selected/disabled card buttons
        [cardButton setImage:transparent forState:UIControlStateSelected];
        [cardButton setImage:transparent forState:UIControlStateSelected|UIControlStateDisabled];
    }
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips %d",self.flipCount];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
    
    // Draw the flip results history
    self.flipHistorySlider.value = self.flipHistoryCurIndex;    // render slider at current index in flip history based on game play
    self.flipResultsLabel.text = self.game.flipResults;
}

- (void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    //NSLog(@"Flips count is %d",self.flipCount);   // debug
}

- (IBAction)flipCard:(UIButton *)sender
{
    NSLog(@"self.game.currentGameMode is: %d", self.game.currentGameMode);
    if (self.game.currentGameMode > -1) {   // If user has chosen game mode
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
        self.flipCount++;
        self.flipHistorySlider.maximumValue = self.game.flipResultsHistory.count; // Set the max value to the latest count
        self.flipHistoryCurIndex = self.flipHistorySlider.maximumValue;
        [self updateUI];
    }
}

- (IBAction)dealButton:(UIButton *)sender
{
    if (sender.isTouchInside) {
        //NSLog(@"I am selected");
        self.flipCount = 0;
        self.deck = nil;
        self.game = nil;
        
        // Re-enable segmented game switch
        self.segmentedGameSwitch.enabled = YES;
        
        // updateUI based on latest re-dealing
        [self updateUI];
        self.flipResultsLabel.text = @"Let's Play Again!";
    }
}

- (IBAction)gameTypeSwitch:(UISegmentedControl *)sender
{
    [self.game setGameMode:(sender.selectedSegmentIndex+2)];
    
    NSLog(@"Selected segment index is: %@", [sender titleForSegmentAtIndex:[sender selectedSegmentIndex]]);
}

- (IBAction)slideThroughFlipHistory:(UISlider *)sender
{
    if (sender.isTouchInside) {
        NSLog(@"Slider max value: %f",sender.maximumValue);
        NSInteger curSliderVal = (NSInteger)sender.value;
        if (curSliderVal < self.game.flipResultsHistory.count) {
            self.flipHistoryCurIndex = curSliderVal;
            self.flipResultsLabel.text = self.game.flipResultsHistory[curSliderVal];
        }
        //[self updateUI];
        self.flipHistorySlider.minimumTrackTintColor = (self.flipHistorySlider.value < self.flipHistorySlider.maximumValue) ? [UIColor purpleColor] : [UIColor clearColor];
    }
}
@end
