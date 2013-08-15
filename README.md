# Instrumental for Node

A node.js agent for instrumentalapp.com. It supports the full [collector protocol](https://instrumentalapp.com/docs/collector/readme).

## Usage

````javascript
I = require('instrumental')
I.setup({
	// from here: https://instrumentalapp.com/docs/setup
	api_key			: "your_api_key", 		 
	
	// optional, default shown
	hostname 		: 'instrumentalapp.com', 
	
	// optional, default shown
	port 			: 8000,					 
	
	// optional, default shown. disconnect from the server
	// after this many milliseconds.
	timeout			: 10000,				 
	
	// optional, default shown. metrics will only be sent
	// to the server when this many have been queued,
	// reconnecting if necessary.
	max_queue_size	: 100,					 

}, function () {
	// the agent is fully setup and authenticated.
	// you can start registering metrics before this point however
	// and they will be buffered and sent once everything is connected.
});

I.increment('metric.name', /* increment_by = 1, timestamp = now */);
I.gauge('metric.name', 82.12, /* timestamp = now */);
I.gauge_absolute('metric.name', 12.12, /* timestamp = now */);
I.notice('This is a notice', /* duration = 0, timestamp = now */);
````
