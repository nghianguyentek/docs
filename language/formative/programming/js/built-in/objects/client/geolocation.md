# Geolocation
## Methods
### getCurrentPosition
```
undefined getCurrentPosition(
    PositionCallback successCallback,
    optional PositionErrorCallback? errorCallback = null,
    optional PositionOptions options = {}
);
```
where
- [PositionCallback](#positionCallback)
- [PositionErrorCallback](#PositionErrorCallback)
- [PositionOptions](#PositionOptions)
### watchPosition
```
long watchPosition (
    PositionCallback successCallback,
    optional PositionErrorCallback? errorCallback = null,
    optional PositionOptions options = {}
);
```
where
- [PositionCallback](#positionCallback)
- [PositionErrorCallback](#PositionErrorCallback)
- [PositionOptions](#PositionOptions)
### clearWatch
```
undefined clearWatch(long watchId);
```
## PositionCallback
```
undefined (
  GeolocationPosition position
);
```
where
- [GeolocationPosition](#GeolocationPosition)
## GeolocationPosition
```
{
  readonly attribute GeolocationCoordinates coords;
  readonly attribute EpochTimeStamp timestamp;
};
```
where
- [GeolocationCoordinates](#GeolocationCoordinates)
- [EpochTimeStamp](#EpochTimeStamp)
## GeolocationCoordinates
```
{
  readonly attribute double accuracy;
  readonly attribute double latitude;
  readonly attribute double longitude;
  readonly attribute double? altitude;
  readonly attribute double? altitudeAccuracy;
  readonly attribute double? heading;
  readonly attribute double? speed;
};
```
where
- The accuracy attribute denotes the accuracy level of the latitude and longitude coordinates in meters (e.g., 65 meters).
- The latitude and longitude attributes are geographic coordinates specified in decimal degrees.
- The altitude attribute denotes the height of the position, specified in meters above the WGS84 ellipsoid.
- The altitudeAccuracy attribute represents the altitude accuracy in meters (e.g., 10 meters).
- The heading attribute denotes the direction of travel of the hosting device and is specified in degrees, where 0° ≤ heading < 360°, counting clockwise relative to the true north.
-  The speed attribute denotes the magnitude of the horizontal component of the hosting device's current velocity in meters per second.
## EpochTimeStamp
A EpochTimeStamp represents the number of milliseconds from a given time to 01 January, 1970 00:00:00 UTC, excluding leap seconds.
## PositionErrorCallback
```
undefined (
  GeolocationPositionError positionError
);
```
where
- [GeolocationPositionError](#GeolocationPositionError)
## GeolocationPositionError
```
{
  const unsigned short PERMISSION_DENIED = 1;
  const unsigned short POSITION_UNAVAILABLE = 2;
  const unsigned short TIMEOUT = 3;
  readonly attribute unsigned short code;
  readonly attribute DOMString message;
};
```
## PositionOptions
```
{
  boolean enableHighAccuracy = false;
  [Clamp] unsigned long timeout = 0xFFFFFFFF;
  [Clamp] unsigned long maximumAge = 0;
}
```
where
- The enableHighAccuracy member provides a hint that the application would like to receive the most accurate location data. The intended purpose of this member is to allow applications to inform the implementation that they do not require high accuracy geolocation fixes and, therefore, the implementation MAY avoid using geolocation providers that consume a significant amount of power (e.g., GPS).
  - *The enableHighAccuracy member can result in slower response times or increased power consumption. The user might also disable this capability, or the device might not be able to provide more accurate results than if the flag wasn't specified.*
- The timeout member denotes the maximum length of time, expressed in milliseconds, before acquiring a position expires.
  - *The time spent waiting for the document to become visible and for obtaining permission to use the API is not included in the period covered by the timeout member. The timeout member only applies when acquiring a position begins.*
  - *An options.timeout value 0 can cause immediate failures.*
- The maximumAge member indicates that the web application is willing to accept a cached position whose age is no greater than the specified time in milliseconds. 