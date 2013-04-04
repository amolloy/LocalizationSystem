//
//  LocalizableString.h
//  BabyGrow
//
//  Created by Andy Molloy on 11/29/09.
//  Copyright 2011 Andy Molloy. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface LocalizableString : NSObject {
	NSString*   formatString;
	NSArray*    arguments;
}

-(id)initWithString:(NSString*)string;
+(id)localizableStringWithString:(NSString*)string;

@end
