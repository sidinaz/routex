## 1.0.4
### Important!  
#### `RoutexNavigator` behaviour change.
Before this version behaviour was if Flutter framework calls returned WidgetBuilder function n times to redraw screen, handlers will be executed same number of times.
This is not case anymore.  
New behaviour is to call handlers once per RoutexNavigator methods call, so 1 call to RoutexNavigator (get, push, etc. methods) is 1 call to all handlers, and Flutter can recall provided WidgetBuilder functions n times, but handlers will be executed only once.
This can be very important and useful, for example, if we push screen once we know that we create objects only once, so Flutter calls of WidgetBuilder function will not affect our state - objects created in handlers.  
Be aware of differences between get and push methods, push is used explicitly with some event, and get is used mainly in widget tree by framework.  
With RoutexNavigator.get call inside Widget tree only guarantee for some objects to be only once initialized is initState method inside `State<T>` class, and for RoutexNavigator.push calls objects created inside handlers will also be initialized only once.  
## 1.0.3
* Description update
## 1.0.2
* Description update
## 1.0.1
* First version
