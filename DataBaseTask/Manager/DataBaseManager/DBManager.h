//
//  DBManager.h
//  DataBaseTask
//
//  Created by Dzmitry Tarelkin on 7/9/18.
//  Copyright © 2018 Dzmitry Tarelkin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ManagerLayerForCoreDataAndSQLite.h"


@interface DBManager : NSObject <ManagerDataBaseProtocol>
- (instancetype)initWithDataBaseFileName:(NSString*)dbFilename;

@end
