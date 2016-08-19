# JPJCalendar
I made a calendar feature for an app I'm working on, and I thought I'd put the code for it here. It doesn't have terribly much flexibility just yet, but It definitely still has that freshly rolled out smell to it. 

I tried to make this calendar fairly straightforward to implement, which means that there aren't a ton of extra features buillt in just yet. To implement the calendar, all you need to do is drag a standard UIView into the storyboard and change the class to a CalendarView. 
If you'd like to change the appearance of particular cells, you can implement the delegate method 
```swift
shouldShowSecondaryViewForDays(date: BDate)
```
The CalendarView should delegate the View Controller being implemented in. 

