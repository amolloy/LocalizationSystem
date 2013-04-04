//
//  PluralizationRule.m
//  BabyGrow
//
//  Created by Andy Molloy on 8/25/09.
//  Copyright 2011 Andy Molloy. All rights reserved.
//

#import "PluralizationRule.h"

typedef NSInteger (*pluralFormForQuantity)(NSInteger);
#define DEFINE_RULE(name, func) static NSInteger name(NSInteger n) { return func; }

DEFINE_RULE( OneForm, 0 )
DEFINE_RULE( TwoFormsSingularUsedForOneOnly, n != 1 )
DEFINE_RULE( TwoFormsSingularUsedForZeroAndOne, n > 1 )
DEFINE_RULE( ThreeFormsSpecialCaseForZero, n%10==1 && n%100!=11 ? 0 : n != 0 ? 1 : 2 )
DEFINE_RULE( ThreeFormsSpecialCaseForOneAndTwo, n==1 ? 0 : n==2 ? 1 : 2 )
DEFINE_RULE( ThreeFormsSpecialCaseForNumbersEndingIn00or2_9__0_9, n==1 ? 0 : (n==0 || (n%100 > 0 && n%100 < 20)) ? 1 : 2 )
DEFINE_RULE( ThreeFormsSpecialCaseForNumbersEndingIn1__2_9, n%10==1 && n%100!=11 ? 0 : n%10>=2 && (n%100<10 || n%100>=20) ? 1 : 2 )
DEFINE_RULE( ThreeFormsSpecialCasesForNumbersEndingIn1and2_3_4ExceptThoseEndingIn1__1_4, n%10==1 && n%100!=11 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2 )
DEFINE_RULE( ThreeFormsSpecialCasesFor1and2_3_4, (n==1) ? 0 : (n>=2 && n<=4) ? 1 : 2 )
DEFINE_RULE( ThreeFormsSpecialCaseForOneAndSomeNumbersEndingIn2_3_or4, n==1 ? 0 : n%10>=2 && n%10<=4 && (n%100<10 || n%100>=20) ? 1 : 2 )
DEFINE_RULE( FourFormsSpecialCaseForOneAndAllNumbersEndingIn02_03_or04, n%100==1 ? 0 : n%100==2 ? 1 : n%100==3 || n%100==4 ? 2 : 3 )

static NSInteger InvalidRule(NSInteger n)
{
	NSLog(@"Invalid pluralization rule!");
	return n;
}

@interface PluralizationRuleImpl : NSObject {
	pluralFormForQuantity   mRuleBlock;
	NSInteger               mPluralCount;
}

-(id)initWithLanguage:(NSString*)lang;
-(NSInteger)getPluralFormForQuantity:(NSInteger)n;
-(NSInteger)pluralFormCount;

@end

@implementation PluralizationRuleImpl

-(id)initWithLanguage:(NSString*)lang
{
	if ( ( self = [super init] ) )
	{
		if ([lang compare:@"ja"] == NSOrderedSame ||
			[lang compare:@"ko"] == NSOrderedSame ||
			[lang compare:@"vi"] == NSOrderedSame ||
			[lang compare:@"tr"] == NSOrderedSame )
		{
			mRuleBlock = OneForm;
			mPluralCount = 1;
		}
		else if ([lang compare:@"da"] == NSOrderedSame ||
				 [lang compare:@"nl"] == NSOrderedSame ||
				 [lang compare:@"en"] == NSOrderedSame ||
				 [lang compare:@"fo"] == NSOrderedSame ||
				 [lang compare:@"de"] == NSOrderedSame ||
				 [lang compare:@"no"] == NSOrderedSame ||
				 [lang compare:@"sv"] == NSOrderedSame ||
				 [lang compare:@"et"] == NSOrderedSame ||
				 [lang compare:@"fi"] == NSOrderedSame ||
				 [lang compare:@"el"] == NSOrderedSame ||
				 [lang compare:@"he"] == NSOrderedSame ||
				 [lang compare:@"it"] == NSOrderedSame ||
				 [lang compare:@"pt"] == NSOrderedSame ||
				 [lang compare:@"es"] == NSOrderedSame ||
				 [lang compare:@"eo"] == NSOrderedSame ||
				 [lang compare:@"hu"] == NSOrderedSame )
		{
			mRuleBlock = TwoFormsSingularUsedForOneOnly;
			mPluralCount = 2;
		}
		else if ([lang compare:@"fr"] == NSOrderedSame ||
				 [lang compare:@"pt-BR"] == NSOrderedSame )
		{
			mRuleBlock = TwoFormsSingularUsedForZeroAndOne;
			mPluralCount = 2;
		}
		else if ([lang compare:@"lv"] == NSOrderedSame )
		{
			mRuleBlock = ThreeFormsSpecialCaseForZero;
			mPluralCount = 3;
		}
		else if ([lang compare:@"ga"] == NSOrderedSame )
		{
			mRuleBlock = ThreeFormsSpecialCaseForOneAndTwo;
			mPluralCount = 3;
		}
		else if ([lang compare:@"ro"] == NSOrderedSame )
		{
			mRuleBlock = ThreeFormsSpecialCaseForNumbersEndingIn00or2_9__0_9;
			mPluralCount = 3;
		}
		else if ([lang compare:@"lt"] == NSOrderedSame )
		{
			mRuleBlock = ThreeFormsSpecialCaseForNumbersEndingIn1__2_9;
			mPluralCount = 3;
		}
		else if ([lang compare:@"hr"] == NSOrderedSame ||
				 [lang compare:@"sr"] == NSOrderedSame ||
				 [lang compare:@"ru"] == NSOrderedSame ||
				 [lang compare:@"uk"] == NSOrderedSame )
		{
			mRuleBlock = ThreeFormsSpecialCasesForNumbersEndingIn1and2_3_4ExceptThoseEndingIn1__1_4;
			mPluralCount = 3;
		}
		else if ([lang compare:@"sk"] == NSOrderedSame ||
				 [lang compare:@"cs"] == NSOrderedSame )
		{
			mRuleBlock = ThreeFormsSpecialCasesFor1and2_3_4;
			mPluralCount = 3;
		}
		else if ([lang compare:@"pl"] == NSOrderedSame )
		{
			mRuleBlock = ThreeFormsSpecialCaseForOneAndSomeNumbersEndingIn2_3_or4;
			mPluralCount = 3;
		}
		else if ( [lang compare:@"sl"] == NSOrderedSame )
		{
			mRuleBlock = FourFormsSpecialCaseForOneAndAllNumbersEndingIn02_03_or04;
			mPluralCount = 4;
		}
		else
		{
			mRuleBlock = InvalidRule;
			mPluralCount = -1;
		}
	}
	
	return self;
}

-(NSInteger)getPluralFormForQuantity:(NSInteger)n
{
	return mRuleBlock( n );
}

-(NSInteger)pluralFormCount
{
	return mPluralCount;
}

@end

@implementation PluralizationRule

-(id)initWithLanguage:(NSString*)lang
{
	if ( ( self = [super init] ) )
	{
		impl = [[PluralizationRuleImpl alloc] initWithLanguage:lang];
	}
	
	return self;
}

-(NSInteger)getPluralFormForQuantity:(NSInteger)n
{
	return [impl getPluralFormForQuantity:n];
}

-(NSInteger)pluralFormCount
{
	return [impl pluralFormCount];
}


@end
