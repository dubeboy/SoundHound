//
//  LocationManagerProtocol.h
//  Songhound
//
//  Created by Divine Dube on 2019/03/20.
//  Copyright © 2019 Divine Dube. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreLocation/CLLocationManagerDelegate.h>

NS_ASSUME_NONNULL_BEGIN

// the cool thing is that this is inheriting from that parent protocol
@protocol LocationManagerProtocol <CLLocationManagerDelegate>
 - (void) reverseGeocoderCoordinates:  (nonnull CLLocationCoordinate2D * )coordinates;
 - (void) onReverseCoordinatesReceived: (nonnull NSString *) fullAddress;
@end

NS_ASSUME_NONNULL_END
