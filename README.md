Ubret
============

To build:

    cake build

To watch files for changes and build:

    cake watch

To build and serve built files: 

    cake -s watch

Specify Port, default is 3001:

    cake -s -p [PORT] watch

## Usage
The easiest way to use the Ubret Library is to just include the hosted version on your site. 

    <script src="http://ubret.s3.amazonaws.com/ubret_library/lib/index.js"></script>

if you're running the server

    <script src="http://localhost:3001/lib/index.js"></script>

To load tools you'll just need to pass an array of tool names, and a callback to be executed after the tools load. 

    Ubret.ToolLoader(["Table", "Histogram"], -> console.log 'Tools are loaded")

Because that loading method is super slow there are three provided minified tool sets that can also be loaded. 

    Ubret.ToolsetLoader("galaxy_zoo", -> console.log 'Tools are loaded')

The tool sets are 

* `galaxy_zoo` with Table, Histogram, Scatterplot, Spectra, SubjectViewer, Map, and Statistics
* `navigator` with Histogram and Scatterplot
* `spacewarp` with SpacewarpViewer

## API Documentation

### Base Tool
All methods in base tool return `@` so they can be chained together.

#### Constructor
All methods documented be below can also be triggered when a tool is created, by passing them in as the keys of an object. Hence:

    new Ubret.Table
      selector: 'table-1'
      data: [{stuff: "is here"}, {stuff: "is also here"}]
      height: 50
      width: 150

is equivalent to 

    new Ubret.Table().selector('table-1')
      .data([{stuff: "is here"}, {stuff: "is also here"}]
      .height(50).width(150)

You're free to use whichever style you prefer, but any tools should support both methods of manipulating a tool. 

#### @selector(selector=null)
Creates a new HTML node and assigns it to `@el` and sets its id to the value of selector. It also creates a new d3 node at `@d3el`. Triggers the `'selector'` event with the d3 node. 

#### @height(height=0, triggerEvent=true)
Sets `@opts.height` to height and triggers `'height'` event. 

#### @width(width=0, triggerEvent=true)
Sets `@opts.width` to width and triggers `'width'` event.

#### @data(data=[], triggerEvent=true)
Sets `@opts.data` to data sorted by each datum's `uid`. Also will call `@keys` with the keys that should be displayed in tools. Triggers the the `'data'` event with the result of `@childData()`

#### @keys(keys=[], triggerEvent=true)
Sets `@opts.keys` with the kinds of keys that be displayed in the tools. Triggers the `'keys'` event. 

#### @selectIds(ids=[], triggerEvent=true)
If ids is an Array, sets `@opts.selectedIds` to the value of ids. Otherwise it appends ids to the end of `@opts.selectedIds`. Triggers `'selection'` event. 

#### @filters(filters=[], triggerEvent=true)
Appends filters, a predicate function that can be passed to Underscore's `_.filter` function, to the end of `@opts.filters`. Triggers a `'data'` event with `@preparedData()` if data has been passed to the tool. Triggers the `'add-filters'` event. 

#### @fields(fields=[], triggerEvent=true)
Appends fields, an object containing a field name and a function that returns the value of the new field, to the end of `@opts.fields`. Triggers a `'data'` event with `@preparedData()` if data has been passed to the tool. Triggers the `'add-fields'` event. 

#### @settings(settings, triggerEvent=true)
Accepts settings as an object. For each key/value pair in settings, it tests whether `@[setting_key]` is a function and calls it with the value of the pair if that is the case. Otherwise sets `@opts[setting_key] = setting_value`. In both cases it triggers as a `'setting:key_name'` event for each key/value pair, and a `'settings'` event when it has finished with all settings. 

#### @parentTool(tool=null, triggerEvent=true)
Removes any current parent tool if one exists, and unbinds the parentTool's events. Sets `@opts.parentTool` to the new parentTool, and sets up event listeners on the parent tool. Triggers the `'bound-to'` event. 

#### @preparedData()
Returns the tool's data with all fields and new fiels applied to it. It is memoized, so subsequent calls, when the data, filters and fields haven't changed, do not result in recalculation. You should always use a call to this function instead of using `@opts.data` (unless you've got a good reason not to). 

#### @removeParentTool
Remove the current parentTool and unbinds its event events, if a parent tool exists. 

#### @childData
Returns `@preparedData()`. Override in a tool to only provide a subset of a tool's data to child tools. 

### Ubret.Events
A very small probably incorrect API for handling events in tools. 

If you want to specify events your Tool in one easy go

    events:
      'event_name' : 'some callbacks'
      'other_event' : 'some more callbacks'

#### @on(event, callbacks)
Accepts event as either the name of an event, or as an object of events and their associated callbacks. Callbacks can be a single function or a string of function names. When multiple callbacks are supplied they will always be executed in the order they were specified. 

#### @trigger(event, args...)
Calls any callbacks associated with the event with the supplied arguments. 

#### @unbind(event=null)
Removes all callbacks for a specified event. If event is null it removes, all events from the object. 

### Ubret.Paginated
A small helper object for dealing tools that need pagination. Include in your tool by running `_.extend @, Ubret.Paginated` in the tools constructor. 

You'll also need to implement two methods in your tool: `perPage`, which can either be a constant or a function that returns that number of items per page, `pageSort`, which accepts a single argument of an array of data, and returns it sorted. 

#### @currentPageData()
Returns the page items for the current Page. If the current Page is outside the bounds of the tool's data set. It resets the page number to one that is. 

#### @page(number)
Accepts an integer page number and returns the items for that page. Pages are zero-index because they should be. 

### Ubret.Sequential
A sub-object of Paginated that sets `perPage` to 1 and has a default `pageSort` that returns object that have been selected if there are selections, and all items otherwise. Include in your tool by running `_.extend @, Ubret.Sequential`.

### Ubret.Ajax(method, url)
Makes an AJAX request to the specified URL and returns an `Ubret.Promise`.

### Ubret.Get(url)
Wrapper for `Ubret.Ajax('GET', url)`.

### Ubret.Post(url)
Wrapper for `Ubret.Ajax('POST', url)`.

### Ubret.Promise
An implementation of the [Promise/A+ Spec](http://promises-aplus.github.com/promises-spec/). Ubret.Ajax returns a promise. 

#### @then(successCb, failCb)
Either callback is optional. It returns another promise that will be fulfilled after the then returns. 

## Examples
The Table tool, and the Spectra Tool, should be fairly well documented. 

## License
The Ubret Library is licensed under an MIT-style license. See COPYING
