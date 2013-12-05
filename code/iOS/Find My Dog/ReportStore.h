//
//  ReportStore.h
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractStore.h"
#import "Report.h"

@interface ReportStore : AbstractStore
{
    NSMutableDictionary *pendingReports;
    NSMutableDictionary *savedReports;
}

+ (ReportStore *)defaultStore;

- (void)sendReportWithImage:(UIImage *)image lattitude:(double)lattitude longitude:(double) longitude;
- (void)nextReport;
- (Report *)createReportWithID:(NSString *)reportID lattitude:(double)lattitude longitude:(double)longitude created:(NSTimeInterval)created;
- (NSMutableDictionary *)pendingReports;
- (NSMutableDictionary *)savedReports;
- (void)removeReportWithID:(NSString *)reportID;

@end
