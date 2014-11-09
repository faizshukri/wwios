//
//  Score.m
//  Wigly2
//
//  Created by Faiz Shukri on 11/9/14.
//  Copyright (c) 2014 Faiz Shukri. All rights reserved.
//

#import "Score.h"

@implementation Score
-(id) initWithName:(NSString *) name score:(NSString*) score {
    self = [super init];
    if (self) {
        self.name = name;
        self.Score = score;
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)decoder {
    self = [super init];
    if (self) {
        self.name = [decoder decodeObjectForKey:@"name"];
        self.Score = [decoder decodeObjectForKey:@"score"];
    }
    return self;
}
                 
- (void)encodeWithCoder:(NSCoder *)encoder {
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeObject:self.score forKey:@"score"];
}
@end
