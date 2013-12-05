//
//  ReportStore.m
//  Find My Dog
//
//  Created by José Manuel Rabasco de Damas on 17/09/13.
//  Copyright (c) 2013 Find My Dog. All rights reserved.
//

#import "ReportStore.h"
#import "ConfigurationStore.h"
#import "PetStore.h"
#import "NetworkManager.h"

@implementation ReportStore

static ReportStore *defaultStore = nil;

- (id)init
{
    self = [super init];
    
    if (self) {
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLoadReports:)
                                                     name:@"NetworkManagerDidLoadReportsNotification"
                                                   object:nil];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(didLoadReportImage:)
                                                     name:@"NetworkManagerDidLoadImageReportNotification"
                                                   object:nil];
        
        [self loadFromLocalStorage];
    }
    
    return self;
}

+ (ReportStore *)defaultStore
{
    if (defaultStore == nil)
    {
        defaultStore = [[super alloc] init];
    }
    
    return defaultStore;
}

- (void)loadFromLocalStorage
{
    if (!savedReports && !pendingReports)
    {
        // Load from local storage
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *e = [[model entitiesByName] objectForKey:@"Report"];
        [request setEntity:e];
        
        NSError *error;
        NSArray *result = [context executeFetchRequest:request error:&error];
        
        savedReports = [[NSMutableDictionary alloc] init];
        pendingReports = [[NSMutableDictionary alloc] init];
        
        for (Report *report in result)
        {
            if ([report pending]) {
                [pendingReports setObject:report forKey:[report reportID]];
            } else {
                [savedReports setObject:report forKey:[report reportID]];
            }
        }
    }
}

- (void)sendReportWithImage:(UIImage *)image lattitude:(double)lattitude longitude:(double) longitude
{
    NSData *imageData = UIImageJPEGRepresentation(image, 90);
    
    NetworkManager *proxy = [NetworkManager sharedNetworkManager];
    [proxy sendReportWithImageData:imageData lattitude:lattitude longitude:longitude];
}

- (void)nextReport
{
    // Pending reports?
    if ([pendingReports count] > 0) {
        [self dispatchNextReport];
    }
    else
    {
        [self loadReportsFromServer];
    }
}

- (void)dispatchNextReport
{
    NSArray *keys = [pendingReports allKeys];
    Report *first = [pendingReports objectForKey:[keys objectAtIndex:0]];
    
    // Load image
    NetworkManager *proxy = [NetworkManager sharedNetworkManager];
    [proxy loadReportImageWithID:[first reportID]];
}

- (void)didLoadReportImage:(NSNotification *)notification
{
    NSString *reportID = [[notification userInfo] objectForKey:@"reportID"];
    NSData *data = [[notification userInfo] objectForKey:@"data"];
    
    Report *report = [pendingReports objectForKey:reportID];
    [report setThumbnailData:data];
    [report setThumbnail:[[UIImage alloc] initWithData:[report thumbnailData]]];
    
    // Send notification
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:reportID, @"reportID", nil];
    NSNotification *notif = [NSNotification notificationWithName:@"ReportStoreDidLoadNextReportNotification"
                                                          object:self
                                                        userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notif];
}

- (void)loadReportsFromServer
{
    Configuration *config = [[ConfigurationStore defaultStore] configuration];
    Pet *pet = [[PetStore defaultStore] missingPet];
    if (pet)
    {
        NSDate *current = [[NSDate alloc] init];
        
        NetworkManager *proxy = [NetworkManager sharedNetworkManager];
        [proxy loadReportsWithLattitude:[pet missingLattitude] longitude:[pet missingLongitude] lastCheckTimestamp:[[config lastReportsChecked] timeIntervalSince1970]];
        
        [config setLastReportsChecked:current];
    }
}

- (void)didLoadReports:(NSNotification *)notification
{
    NSArray *array = (NSArray *)[notification userInfo];
    
    for (NSDictionary *item in array)
    {
        NSString *reportID = [item objectForKey:@"id"];
        NSArray *position = [item objectForKey:@"position"];
        NSNumber *longitude = [position objectAtIndex:0];
        NSNumber *lattitude = [position objectAtIndex:1];
        NSNumber *created = [item objectForKey:@"timestamp"];
        
        Report *report = [self createReportWithID:reportID lattitude:[lattitude doubleValue] longitude:[longitude doubleValue] created:[created doubleValue]];
        [pendingReports setObject:report forKey:[report reportID]];
    }
    
    if ([pendingReports count] > 0)
    {
        [self dispatchNextReport];
    }
    else
    {
        // Send notification (no reports)
        NSNotification *notif = [NSNotification notificationWithName:@"ReportStoreNoPendingReportsNotification"
                                                              object:self
                                                            userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notif];
    }
}

- (Report *)createReportWithID:(NSString *)reportID lattitude:(double)lattitude longitude:(double)longitude created:(NSTimeInterval)created
{
    Report *report = [NSEntityDescription insertNewObjectForEntityForName:@"Report"
                                                   inManagedObjectContext:context];
    
    [report setReportID:reportID];
    [report setLattitude:lattitude];
    [report setLongitude:longitude];
    [report setCreated:created];
    [report setPending:YES];
    
    return report;
}

- (NSMutableDictionary *)pendingReports
{
    return pendingReports;
}

- (NSMutableDictionary *)savedReports
{
    return savedReports;
}

- (void)removeReportWithID:(NSString *)reportID
{
    Report *report = [pendingReports objectForKey:reportID];
    [context deleteObject:report];
    [pendingReports removeObjectForKey:reportID];
    [savedReports removeObjectForKey:reportID];
}

@end
