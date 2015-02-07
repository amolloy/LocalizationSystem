//
//  LocalizableString.m
//  BabyGrow
//
//  Created by Andy Molloy on 11/29/09.
//  Copyright 2011 Andy Molloy. All rights reserved.
//

#import "LocalizableString.h"

@implementation LocalizableString

-(id)initWithString:(NSString*)string
{
	if ( ( self = [super init] ) )
	{
		NSMutableSet* formatKeys = [NSMutableSet setWithCapacity:1];
		
		NSRange range = NSMakeRange(0, [string length]);
		
		while ( range.location != NSNotFound )
		{
			range = [string rangeOfString:@"[" options:0 range:range];
			
			if ( range.location != NSNotFound )
			{
				NSRange escapeRange = NSMakeRange( range.location - 1, 1 );
				
				if (range.location == 0 ||
					[[string substringWithRange:escapeRange] compare:@"\\"] != NSOrderedSame )
				{
					// Found a key
					++range.location;
					range.length = [string length] - range.location;
					
					NSRange keyEndRange = [string rangeOfString:@"]" options:0 range:range];
					NSRange keyRange = NSMakeRange( range.location, keyEndRange.location - range.location );
					
					NSString* key = [string substringWithRange:keyRange];
					
					[formatKeys addObject:key];
					
					range.location = keyRange.location + keyRange.length;
					range.length = [string length] - range.location;
				}
			}
		}
		
		arguments = [formatKeys allObjects];
		
		NSMutableString* newFormatString = [string mutableCopy];
		
		for ( NSUInteger i = 0; i < [arguments count]; ++i )
		{
			NSString* key = [arguments objectAtIndex:i];
			NSString* keyString = [NSString stringWithFormat:@"[%@]", key];
			
			[newFormatString replaceOccurrencesOfString:keyString
											 withString:[NSString stringWithFormat:@"%%%lu$@", (unsigned long)(i + 1)]
												options:0
												  range:NSMakeRange(0, [newFormatString length])];
		}
		
		formatString = newFormatString;
	}
	
	return self;
}

+(id)localizableStringWithString:(NSString*)string
{
	return [[self alloc] initWithString:string];
}


@end
