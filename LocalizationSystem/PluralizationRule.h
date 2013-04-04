//
//  PluralizationRule.h
//  BabyGrow
//
//  Created by Andy Molloy on 8/25/09.
//  Copyright 2011 Andy Molloy. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PluralizationRuleImpl;

@interface PluralizationRule : NSObject {
	PluralizationRuleImpl*  impl;
}

-(id)initWithLanguage:(NSString*)lang;
-(NSInteger)getPluralFormForQuantity:(NSInteger)n;
-(NSInteger)pluralFormCount;

@end
