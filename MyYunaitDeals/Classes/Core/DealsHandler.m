//
//  DealsHandler.m
//  MyYunaitDeals
//
//  Created by Francisco Sevillano on 30/06/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "Deal.h"
#import "DealsHandler.h"

#define SERVER_URL @"46.137.100.85"

#define NEARBY_DEALS_TAG 0
#define MY_DEALS_TAG 1
#define CREATE_EVENT_TAG  2

@implementation DealsHandler

@synthesize connection;
@synthesize delegate;

- (void)getNearbyDeals {
  
  self.connection = [[[HttpConnection alloc]initWithDelegate:self]autorelease];
  self.connection.tag = NEARBY_DEALS_TAG;
  NSDictionary *parameters = [NSDictionary dictionaryWithObjectsAndKeys:@"40.0",@"lat",@"-3.2",@"long", nil];
  NSString *url = [NSString stringWithFormat:@"http://%@/%@",SERVER_URL,@"yunait/deals"];
  NSLog(@"%@",url);

 [self.connection requestUrl:url params:parameters method:Get content:nil headers:nil];  
  
  /*Deal *deal1 = [[Deal alloc]init];
  deal1.title = @"Oferta1";
  deal1.description = @"Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass.";
  deal1.daysLeft = @"5";
  deal1.ident = @"0";
  deal1.imageURL = @"http://media.yunait.com.s3.amazonaws.com/o/30/305463/ficha_viaja-sin-preocupaciones-este-verano-por-menos-de-150noche-10-noches-de-hotel-para-2-con-tutaloncom-2.jpg";
  
  Deal *deal2 = [[Deal alloc]init];
  deal2.title = @"Oferta2";
  deal2.description = @"Normally, both your asses would be dead as fucking fried chicken, but you happen to pull this shit while I'm in a transitional period so I don't wanna kill you, I wanna help you. But I can't give you this case, it don't belong to me. Besides, I've already been through too much shit this morning over this case to hand it over to your dumb ass.";
  deal2.daysLeft = @"6";
  deal2.ident = @"1";
  deal2.imageURL = @"http://media.yunait.com.s3.amazonaws.com/o/30/305463/ficha_viaja-sin-preocupaciones-este-verano-por-menos-de-150noche-10-noches-de-hotel-para-2-con-tutaloncom-2.jpg";
  
  [self.delegate dealsReceived:[NSArray arrayWithObjects:deal1,deal2, nil]];*/
} 

- (void)getMyDeals {
  /*self.connection = [[[HttpConnection alloc]initWithDelegate:self]autorelease];
  self.connection.tag = NEARBY_DEALS_TAG;
  NSString *url = [NSString stringWithFormat:@"http://%@/%@/%@",SERVER_URL,@"algo",@"algo"];
  NSLog(@"%@",url);
  [self.connection requestUrl:url params:nil method:Get content:nil headers:nil];*/
  
  
  Deal *deal1 = [[Deal alloc]init];
  deal1.title = @"Oferta1";
  deal1.daysLeft = @"5";
  deal1.ident = @"0";
  deal1.imageURL = @"http://media.yunait.com.s3.amazonaws.com/o/30/305463/ficha_viaja-sin-preocupaciones-este-verano-por-menos-de-150noche-10-noches-de-hotel-para-2-con-tutaloncom-2.jpg";

  Deal *deal2 = [[Deal alloc]init];
  deal2.title = @"Oferta2";
  deal2.daysLeft = @"6";
  deal2.ident = @"1";
  deal2.imageURL = @"http://media.yunait.com.s3.amazonaws.com/o/30/305463/ficha_viaja-sin-preocupaciones-este-verano-por-menos-de-150noche-10-noches-de-hotel-para-2-con-tutaloncom-2.jpg";
}

- (void)createEventWithName:(NSString*)name 
                   location:(NSString*)location 
                       date:(NSDate*)date {
  
  self.connection = [[[HttpConnection alloc]initWithDelegate:self]autorelease];
  self.connection.tag = CREATE_EVENT_TAG;
  NSString *url = [NSString stringWithFormat:@"http://%@/%@",SERVER_URL,@"event"];
  NSLog(@"%@",url);
  
  AppDelegate *appDelegate  = (AppDelegate*)[UIApplication sharedApplication].delegate;
  NSString *facebookAuth = [NSString stringWithFormat:@"%@ %@",@"Bearer",appDelegate.facebook.accessToken];
  
  NSDictionary *headers = 
  [NSDictionary dictionaryWithObjectsAndKeys:facebookAuth,HTTP_AUTHORIZATION_HEADER, nil];
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
	[dateFormatter setDateFormat:@"YYYY-MM-dd"];
  
  NSString *dateString = [dateFormatter stringFromDate:date];
  
  NSString *nameParameter = [NSString stringWithFormat:@"%@=%@",@"name",name];
  NSString *locationParameter = [NSString stringWithFormat:@"%@=%@",@"location",location];
  NSString *eventDateParameter = [NSString stringWithFormat:@"%@=%@",@"event_date",dateString];
  
  NSString *body = [NSString stringWithFormat:@"%@&%@&%@",nameParameter,locationParameter,eventDateParameter];
  
  [self.connection requestUrl:url params:nil method:Post content:body headers:headers];
  
}


- (void)connection:(HttpConnection*)incomingConnection 
   requestFinished:(NSData *) result 
      withEncoding:(NSStringEncoding) encoding {
#if DEBUG
	NSString *dataReceived = [[NSString alloc] initWithData:result encoding:NSUTF8StringEncoding];
	NSLog(@"%@", dataReceived);
	[dataReceived release];
#endif
  
  if (incomingConnection.tag == CREATE_EVENT_TAG) {
    [self.delegate eventCreated];
  }
  else if (incomingConnection.tag == NEARBY_DEALS_TAG) {
    [self.delegate dealsReceived:nil];
  }
}

- (void)connection:(HttpConnection*)connection
     requestFailed:(Result) error { 
  
} 

@end
