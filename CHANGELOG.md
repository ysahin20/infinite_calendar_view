# [2.2.1 - 01 Dev 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.2.1)

- [bug] show column with only one column
- [demo] improve multi column 2 demo

# [2.2.0 - 30 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.2.0)

- [improve] add colum index to drag and drop for multi-columns
- [improve] add column in slot events https://github.com/pickywawa/infinite_calendar_view/issues/6
- [bug] start of week in month view https://github.com/pickywawa/infinite_calendar_view/issues/7
- [change] remove heightPerMinute in DragEventWidget (no necessary)

# [2.1.0 - 29 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.1.0)

- [change] add custom round border to DefaultEventWidget with default value = 3
- [change] add column and day in offsetTimes builder
- [improve] paint offsetTimes per columns
- [demo] add on day multi column view, with custom header (avatar) and custom offsetTimes

# [2.0.6 - 24 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.0.6)

- [bug] no replace multi day events in replaceDayEvents

# [2.0.4 - 21 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.0.4)

- [bug] https://github.com/pickywawa/infinite_calendar_view/issues/5
- [bug] rename uuid to uniqueId

# [2.0.3 - 20 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.0.3)

- [demo] month correction

# [2.0.2 - 19 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.0.2)

- [bug] wheel scroll bug on web
- [bug] pointer scroll support on web
- [bug] drag and drop on calendar not full width
- [improve] change vertical scroll during drag and drop
- [documentation] improve multi column demo
- [documentation] web demo

# [2.0.1 - 16 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.0.1)

- [improve] Complete Line Painter stroke option
- [documentation] Complete readme

# [2.0.0 - 16 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/2.0.0)

- [change] Fusion between Event and fullDayEvent
- [new] New view : infinite month view !
- [new] Multi days events management
    - generate and add unique id in each event
    - multi day events in month view
    - delete and update methode in controller to remove multi day event yet
- [new] Focused day saved in controller
    - easy shared focusedDay between views
    - init one callback (for update AppBar for example)
    - use controller focusedDay by default if intitialDay is not defined
- Add full day event in list details view yet (with fusion between Event and fullDayEvent)
- [improve] Complete DefaultDetailEvent
- [improve] InkWell in DefaultDetailEvent and DefaultDayEvent for beautiful tap
- [improve] Scroll in FullDayEvents for unlimited full day events
- [example] Show month in AppBar
- [example] Month Example
- [example] One Day + Table Calendar Example

# [1.1.5 - 7 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/1.1.5)

- Multi days events bug with multi columns

# [1.1.4 - 3 Jan 2025](https://github.com/pickywawa/infinite_calendar_view/tree/1.1.4)

- Multi days events management (range)

# [1.1.3 - 3 Dec 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.1.3)

- Readme preview gif

# [1.1.2 - 3 Dec 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.1.2)

- [bug] Event size when pinch to zoom
- [bug] DefaultDayEvent overflow text when pinch to zoom
- [new] First and end line in column painter
- [new] Preview gifs

# [1.1.1 - 21 Nov 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.1.1)

- [bug] Rebuild day list header when day events change
- [new] add tablet screenshot

# [1.1.0 - 21 Nov 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.1.0)

- [new] Multiple column per day
- [new] Add day events in events list builder and rebuild when day events change
- [bug] Sync build of day events /list events when events are already in controller

# [1.0.3 - 14 Nov 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.0.3)

- Add full day event builder
- Bug on full day event default font size
- Add full day event example

# [1.0.2 - 10 Nov 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.0.2)

- Pub dev publish warning corrections

# [1.0.1 - 10 Nov 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.0.1)

- Pub dev publish warning corrections

# [1.0.0 - 10 Nov 2024](https://github.com/pickywawa/infinite_calendar_view/tree/1.0.0)

- Initial release
- Updated `README.md` file.
- Added license information in package files.
- Updated project description in `pubspec.yaml`
- Updated documentation.