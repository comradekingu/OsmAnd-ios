//
//  OAGPXDatabase.m
//  OsmAnd
//
//  Created by Alexey Kulish on 15/02/15.
//  Copyright (c) 2015 OsmAnd. All rights reserved.
//

#import "OAGPXDatabase.h"
#import "OAGPXTrackAnalysis.h"
#import "OsmAndApp.h"

#define kDbName @"gpx.db"

@implementation OAGPX
@end


@interface OAGPXDatabase ()
    
@property (nonatomic) NSString *dbFilePath;

@end

@implementation OAGPXDatabase

@synthesize gpxList;

+ (OAGPXDatabase *)sharedDb
{
    static OAGPXDatabase *_sharedDb = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedDb = [[OAGPXDatabase alloc] init];
    });
    return _sharedDb;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.dbFilePath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:kDbName];
        [self load];
    }
    return self;
}

-(void)addGpxItem:(NSString *)fileName title:(NSString *)title desc:(NSString *)desc bounds:(OAGpxBounds)bounds analysis:(OAGPXTrackAnalysis *)analysis
{
    NSMutableArray *res = [NSMutableArray arrayWithArray:gpxList];
    
    OAGPX *gpx = [[OAGPX alloc] init];
    gpx.bounds = bounds;
    gpx.gpxFileName = fileName;
    
    if (title)
        gpx.gpxTitle = title;
    else
        gpx.gpxTitle = [fileName stringByDeletingPathExtension];

    if (desc)
        gpx.gpxDescription = desc;
    else
        gpx.gpxDescription = @"";

    gpx.importDate = [NSDate date];
    
    gpx.totalDistance = analysis.totalDistance;
    gpx.totalTracks = analysis.totalTracks;
    gpx.startTime = analysis.startTime;
    gpx.endTime = analysis.endTime;
    gpx.timeSpan = analysis.timeSpan;
    gpx.timeMoving = analysis.timeMoving;
    gpx.totalDistanceMoving = analysis.totalDistanceMoving;
    gpx.diffElevationUp = analysis.diffElevationUp;
    gpx.diffElevationDown = analysis.diffElevationDown;

    gpx.avgElevation = analysis.avgElevation;
    gpx.minElevation = analysis.minElevation;
    gpx.maxElevation = analysis.maxElevation;
    gpx.maxSpeed = analysis.maxSpeed;
    gpx.avgSpeed = analysis.avgSpeed;
    gpx.points = analysis.points;

    gpx.wptPoints = analysis.wptPoints;
    gpx.metricEnd = analysis.metricEnd;
    gpx.locationStart = analysis.locationStart;
    gpx.locationEnd = analysis.locationEnd;

    [res addObject:gpx];
    
    gpxList = res;
}

-(void)removeGpxItem:(NSString *)fileName
{
    NSMutableArray *arr = [NSMutableArray arrayWithArray:gpxList];
    for (OAGPX *item in arr) {
        if ([item.gpxFileName isEqualToString:fileName]) {
            
            [arr removeObject:item];
            break;
        }
    }
    gpxList = arr;
    
    OsmAndAppInstance app = [OsmAndApp instance];
    [[NSFileManager defaultManager] removeItemAtPath:[app.gpxPath stringByAppendingPathComponent:fileName] error:nil];
}

-(BOOL)containsGPXItem:(NSString *)fileName
{
    for (OAGPX *item in gpxList) {
        if ([item.gpxFileName isEqualToString:fileName]) {
            return YES;
        }
    }
    return NO;
}

-(void) load
{
    NSMutableArray *res = [NSMutableArray array];
    NSArray *dbContent = [NSArray arrayWithContentsOfFile:self.dbFilePath];
    
    for (NSDictionary *dict in dbContent) {

        OAGPX *gpx = [[OAGPX alloc] init];
        OAGpxBounds bounds;
        bounds.center = CLLocationCoordinate2DMake([dict[@"center_lat"] doubleValue], [dict[@"center_lon"] doubleValue]);
        bounds.topLeft = CLLocationCoordinate2DMake([dict[@"top_left_lat"] doubleValue], [dict[@"top_left_lon"] doubleValue]);
        bounds.bottomRight = CLLocationCoordinate2DMake([dict[@"bottom_right_lat"] doubleValue], [dict[@"bottom_right_lon"] doubleValue]);
        gpx.bounds = bounds;
        
        for (NSString *key in dict) {
            
            id value = dict[key];
            
            if ([key isEqualToString:@"gpxFileName"]) {
                gpx.gpxFileName = value;
            } else if ([key isEqualToString:@"gpxTitle"]) {
                gpx.gpxTitle = value;
            } else if ([key isEqualToString:@"gpxDescription"]) {
                gpx.gpxDescription = value;
            } else if ([key isEqualToString:@"importDate"]) {
                gpx.importDate = value;
            } else if ([key isEqualToString:@"totalDistance"]) {
                gpx.totalDistance = [value floatValue];
            } else if ([key isEqualToString:@"totalTracks"]) {
                gpx.totalTracks = [value integerValue];
            } else if ([key isEqualToString:@"startTime"]) {
                gpx.startTime = [value longValue];
            } else if ([key isEqualToString:@"endTime"]) {
                gpx.endTime = [value longValue];
            } else if ([key isEqualToString:@"timeSpan"]) {
                gpx.timeSpan = [value longValue];
            } else if ([key isEqualToString:@"timeMoving"]) {
                gpx.timeMoving = [value longValue];
            } else if ([key isEqualToString:@"totalDistanceMoving"]) {
                gpx.totalDistanceMoving = [value floatValue];
            } else if ([key isEqualToString:@"diffElevationUp"]) {
                gpx.diffElevationUp = [value doubleValue];
            } else if ([key isEqualToString:@"diffElevationDown"]) {
                gpx.diffElevationDown = [value doubleValue];
            } else if ([key isEqualToString:@"avgElevation"]) {
                gpx.avgElevation = [value doubleValue];
            } else if ([key isEqualToString:@"minElevation"]) {
                gpx.minElevation = [value doubleValue];
            } else if ([key isEqualToString:@"maxElevation"]) {
                gpx.maxElevation = [value doubleValue];
            } else if ([key isEqualToString:@"maxSpeed"]) {
                gpx.maxSpeed = [value floatValue];
            } else if ([key isEqualToString:@"avgSpeed"]) {
                gpx.avgSpeed = [value floatValue];
            } else if ([key isEqualToString:@"points"]) {
                gpx.points = [value integerValue];
            } else if ([key isEqualToString:@"wptPoints"]) {
                gpx.wptPoints = [value integerValue];
            } else if ([key isEqualToString:@"metricEnd"]) {
                gpx.metricEnd = [value doubleValue];
            } else if ([key isEqualToString:@"locationStart"]) {
                OAGpxWpt *wpt = [[OAGpxWpt alloc] init];
                wpt.position = CLLocationCoordinate2DMake([value[@"position_lat"] doubleValue], [value[@"position_lon"] doubleValue]) ;
                wpt.name = value[@"name"];
                wpt.desc = value[@"desc"];
                wpt.elevation = [value[@"elevation"] doubleValue];
                wpt.time = [value[@"time"] longValue];
                wpt.comment = value[@"comment"];
                wpt.type = value[@"type"];
                wpt.speed = [value[@"speed"] doubleValue];
                gpx.locationStart = wpt;
            } else if ([key isEqualToString:@"locationEnd"]) {
                OAGpxWpt *wpt = [[OAGpxWpt alloc] init];
                wpt.position = CLLocationCoordinate2DMake([value[@"position_lat"] doubleValue], [value[@"position_lon"] doubleValue]) ;
                wpt.name = value[@"name"];
                wpt.desc = value[@"desc"];
                wpt.elevation = [value[@"elevation"] doubleValue];
                wpt.time = [value[@"time"] longValue];
                wpt.comment = value[@"comment"];
                wpt.type = value[@"type"];
                wpt.speed = [value[@"speed"] doubleValue];
                gpx.locationEnd = wpt;
            }
            
        }
        
        NSString *path = [[OsmAndApp instance].gpxPath stringByAppendingPathComponent:gpx.gpxFileName];
        if ([[NSFileManager defaultManager] fileExistsAtPath:path])
            [res addObject:gpx];
    }
    
    gpxList = res;
}

-(void) save
{
    NSMutableArray *dbContent = [NSMutableArray array];
    
    for (OAGPX *gpx in gpxList) {
        
        NSMutableDictionary *d = [NSMutableDictionary dictionary];
        
        [d setObject:gpx.gpxFileName forKey:@"gpxFileName"];
        [d setObject:gpx.gpxTitle forKey:@"gpxTitle"];
        [d setObject:gpx.gpxDescription forKey:@"gpxDescription"];
        [d setObject:gpx.importDate forKey:@"importDate"];
        
        [d setObject:@(gpx.bounds.center.latitude) forKey:@"center_lat"];
        [d setObject:@(gpx.bounds.center.longitude) forKey:@"center_lon"];
        [d setObject:@(gpx.bounds.topLeft.latitude) forKey:@"top_left_lat"];
        [d setObject:@(gpx.bounds.topLeft.longitude) forKey:@"top_left_lon"];
        [d setObject:@(gpx.bounds.bottomRight.latitude) forKey:@"bottom_right_lat"];
        [d setObject:@(gpx.bounds.bottomRight.longitude) forKey:@"bottom_right_lon"];
        
        [d setObject:@(gpx.totalDistance) forKey:@"totalDistance"];
        [d setObject:@(gpx.totalTracks) forKey:@"totalTracks"];
        [d setObject:@(gpx.startTime) forKey:@"startTime"];
        [d setObject:@(gpx.endTime) forKey:@"endTime"];
        [d setObject:@(gpx.timeSpan) forKey:@"timeSpan"];
        [d setObject:@(gpx.timeMoving) forKey:@"timeMoving"];
        [d setObject:@(gpx.totalDistanceMoving) forKey:@"totalDistanceMoving"];
        [d setObject:@(gpx.diffElevationUp) forKey:@"diffElevationUp"];
        [d setObject:@(gpx.diffElevationDown) forKey:@"diffElevationDown"];

        [d setObject:@(gpx.avgElevation) forKey:@"avgElevation"];
        [d setObject:@(gpx.minElevation) forKey:@"minElevation"];
        [d setObject:@(gpx.maxElevation) forKey:@"maxElevation"];
        [d setObject:@(gpx.maxSpeed) forKey:@"maxSpeed"];
        [d setObject:@(gpx.avgSpeed) forKey:@"avgSpeed"];
        [d setObject:@(gpx.points) forKey:@"points"];

        [d setObject:@(gpx.wptPoints) forKey:@"wptPoints"];
        [d setObject:@(gpx.metricEnd) forKey:@"metricEnd"];
        
        if (gpx.locationStart) {
            NSMutableDictionary *wpt = [NSMutableDictionary dictionary];
            [wpt setObject:@(gpx.locationStart.position.latitude) forKey:@"position_lat"];
            [wpt setObject:@(gpx.locationStart.position.longitude) forKey:@"position_lon"];
            [wpt setObject:gpx.locationStart.name forKey:@"name"];
            [wpt setObject:gpx.locationStart.desc forKey:@"desc"];
            [wpt setObject:@(gpx.locationStart.elevation) forKey:@"elevation"];
            [wpt setObject:@(gpx.locationStart.time) forKey:@"time"];
            [wpt setObject:gpx.locationStart.comment forKey:@"comment"];
            [wpt setObject:gpx.locationStart.type forKey:@"type"];
            [wpt setObject:@(gpx.locationStart.speed) forKey:@"speed"];
            [d setObject:wpt forKey:@"locationStart"];
        }
        
        if (gpx.locationEnd) {
            NSMutableDictionary *wpt = [NSMutableDictionary dictionary];
            [wpt setObject:@(gpx.locationStart.position.latitude) forKey:@"position_lat"];
            [wpt setObject:@(gpx.locationStart.position.longitude) forKey:@"position_lon"];
            [wpt setObject:gpx.locationStart.name forKey:@"name"];
            [wpt setObject:gpx.locationStart.desc forKey:@"desc"];
            [wpt setObject:@(gpx.locationStart.elevation) forKey:@"elevation"];
            [wpt setObject:@(gpx.locationStart.time) forKey:@"time"];
            [wpt setObject:gpx.locationStart.comment forKey:@"comment"];
            [wpt setObject:gpx.locationStart.type forKey:@"type"];
            [wpt setObject:@(gpx.locationStart.speed) forKey:@"speed"];
            [d setObject:wpt forKey:@"locationEnd"];
        }
        
        [dbContent addObject:d];
    }
    
    [dbContent writeToFile:self.dbFilePath atomically:YES];
}

@end
