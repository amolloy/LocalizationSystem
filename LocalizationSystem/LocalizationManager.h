//
//  LocalizationTools.h
//  BabyGrow
//
//  Created by Andy Molloy on 8/25/09.
//  Copyright 2011 Andy Molloy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ASMLocalizedString(...) [[LocalizationManager localizationManager] stringForArgs:__VA_ARGS__, nil]

@class PluralizationRule;

@interface LocalizationManager : NSObject

+(id)localizationManager;

-(NSString*)stringForKey:(NSString*)key;
-(NSString*)stringForKey:(NSString*)key variables:(NSDictionary*)variables;
-(NSString*)stringForKey:(NSString*)key variables:(NSDictionary*)variables pluralKey:(NSString*)pluralKey;
-(NSString*)stringForArgs:(NSString*)key, ... NS_REQUIRES_NIL_TERMINATION;

-(NSInteger)pluralFormCount;

@end
