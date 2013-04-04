//
//  LocalizationTools.m
//  BabyGrow
//
//  Created by Andy Molloy on 8/25/09.
//  Copyright 2011 Andy Molloy. All rights reserved.
//

#import "LocalizationManager.h"
#import "PluralizationRule.h"

#ifdef CONFIGURATION_Debug
#define FAIL_FAST 1
#else
#define FAIL_FAST 0
#endif

@interface LocalizationManager ()
@property (nonatomic, strong) PluralizationRule* pluralizationRule;
@end

@implementation LocalizationManager

+(id)localizationManager
{
	static LocalizationManager* sLocalizationManager = nil;
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		sLocalizationManager = [[LocalizationManager alloc] init];
	});
	
	return sLocalizationManager;
}

-(id)init
{
	if ( ( self = [super init] ) )
	{
		NSString* loc = [[NSLocale preferredLanguages] objectAtIndex:0];
		self.pluralizationRule = [[PluralizationRule alloc] initWithLanguage:loc];
	}
	
	return self;
}

-(NSString*)stringForKey:(NSString*)key
{
	return [self stringForKey:key variables:nil pluralKey:nil];
}

-(NSString*)stringForKey:(NSString*)key variables:(NSDictionary*)variables
{
	return [self stringForKey:key variables:variables pluralKey:nil];
}

-(NSString*)stringForKey:(NSString*)key variables:(NSDictionary*)variables pluralKey:(NSString*)pluralKey
{
	NSString* realKey = key;
	
	if ( pluralKey )
	{
		NSNumber* quantity = [variables objectForKey:pluralKey];
		realKey = [NSString stringWithFormat:@"%@_%@", key, [self pluralKeyPostfixForQuantity:[quantity integerValue]]];
	}
	
	NSString* string = [[NSBundle mainBundle] localizedStringForKey:realKey value:nil table:nil];
	
	if ( !string )
	{
#if FAIL_FAST
		@throw [NSException exceptionWithName:@"Key not found!" reason:[NSString stringWithFormat:@"No string for key '%@'", key] userInfo:nil];
#endif
		string = realKey;
	}
	
	if ( variables )
	{
		NSMutableString* s = [string mutableCopy];
		
		for ( NSString* variable in [variables allKeys] )
		{
			NSString* varString = [NSString stringWithFormat:@"[%@]", variable];
			[s replaceOccurrencesOfString:varString
							   withString:[[variables objectForKey:variable] description]
								  options:0
									range:NSMakeRange(0, [s length]) ];
		}
		
		string = s;
	}
	
	NSString* accessibilityKey = [realKey stringByAppendingString:@"_ACCESSIBILITY_LABEL"];
	NSString* accessibilityLabel = [[NSBundle mainBundle] localizedStringForKey:accessibilityKey value:nil table:nil];;
	
	if ( accessibilityLabel )
	{
		string.accessibilityLabel = accessibilityLabel;
	}
	
	return string;
}

-(NSString*)stringForArgs:(NSString*)key, ...
{
	va_list args;
    va_start(args, key);

	NSString* comment = va_arg(args, NSString*);
	NSDictionary* vars = nil;
	if (comment)
	{
		vars = va_arg(args, NSDictionary*);
	}
	NSString* pluralKey = nil;
	if (vars)
	{
		pluralKey = va_arg(args, NSString*);
	}
	va_end(args);
	
	return [self stringForKey:key
					variables:vars
					pluralKey:pluralKey];
}

-(NSInteger)pluralFormCount
{
	return [self.pluralizationRule pluralFormCount];
}

-(NSString*)pluralKeyPostfixForQuantity:(NSInteger)quantity
{
	NSInteger pf = [self.pluralizationRule getPluralFormForQuantity:quantity];
	return [NSString stringWithFormat:@"%d", pf];
}

@end
