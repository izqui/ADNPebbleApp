# ADNPebbleApp

I built this app in the **app.net hackathon** held June 8th in San Francisco.
![Hackathon](http://d366upiihda498.cloudfront.net/wp-content/uploads/2013/06/2013-06-08-21.14.12.jpg)

##Installation

In order to make the app work, you will need to install an iOS app in your device (compilation required).
######Pebble side
To run the app in your pebble you can compile it yourself or just use [this link](http://builds.cloudpebble.net/b/7/b7bf5e4c5e5c4367b0b63d12d9b9af80/watchface.pbw) to download the latest binary.

######iPhone side
As I use CocoaPods to manage dependencies, you'll need to open the .xcworkspace file.
You will need to compile the app using xCode. It works great in iOS 7. It requires ADN Passport app in order to login. 

##Usage
ADNPebble is a really simple app. At the moment you can only do two things: Post one of the messages you previously wrote in the iOS app (thinking about adding some kind of Pebble input in the future) and check your profile for your username, followers and following.  

No read stream option yet. In the works.

##Acknowledgements
I use [AFNetworking](afnetworking.com) for as HTTP library, ADNLogin for communicating with ADN Passport and [CloudPebble](http://cloudpebble.net) as IDE and compilation. 

Part of the code communicating with the Pebble was written by [Javi Soto](http://twitter.com/javi) in his [JSPebbleReminders](https://github.com/JaviSoto/JSPebbleReminders)
