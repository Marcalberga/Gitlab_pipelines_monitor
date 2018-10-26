# Gitlab pipelines monitor
## Processing
Processing sketch that monitors all your pipelines in gitlab. This sketch opens a monitor to all pipelines on all projects user has acces to on that gitlab instance.

The sketch will automatically adapt to a 4 x N table of pipelines.

Make sure you have Processing3.x installed on your computer.

Open the sketch with processing IDE and add your custom values:
```java
// CUSTOM VALUES

// add your user private token from gitlab
String privateToken = "privateToken";
// add the url for your gitlab instance, ie: http://gitlab.example.com
String gitlabUrl = "https://myGitlab.com";
// add the refresh rate in seconds, how often will this sketch check for status
int refreshRate = 15;
// Sets need to verify certificate on https connections
boolean sslVerify = false;
// Sets connection to arduino
boolean arduino = true;
// Sets the COMM port to use when communication to arduino
int commElement = 2; // 2 on mac

// END CUSTOM VALUES
```
Run the sketch, and you're done!

## Arduino
check which `com` ports you can access from processing using `println(Serial.list()[i]` and choose which one you will use for communication with arduino. TIP: on OSX, USB com is `Serial.list()[2]`.

### Arduino wiring
Materials:
 - arduino (testef in UNO)
 - 4x 10Ω resistance
 - 2x green led (or 1x blue led, better)
 - 1x red led
 - 1x buzzer
 - wiring
 
 ![arduino_wiring](https://github.com/merciberga/Gitlab_pipelines_monitor/blob/master/gitlab_sketch.png?raw=true)


Do a check on arduino's code and upload it to your plaque.

Run the processing sketch and you're done!

