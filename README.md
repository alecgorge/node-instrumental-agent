# Instrumental for Node

A node.js agent for instrumentalapp.com. It supports the full [collector protocol](https://instrumentalapp.com/docs/collector/readme).

## Usage

The only settings that should need changing are `api_key` and perhaps `max_queue_size` if you have very frequent/infrequent data.

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

}, function (is_api_key_valid) {
	// optional!
	//
	// this is called everytime the agent connects 
	// to the server to send metrics. it can indicate
	// a successful or unsuccessful connection based on
	// is_api_key_valid.
});

I.increment('metric.name', /* increment_by = 1, timestamp = now */);

I.gauge('metric.name', 82.12, /* timestamp = now */);

I.gauge_absolute('metric.name', 12.12, /* timestamp = now */);

I.notice('This is a notice', /* duration = 0, timestamp = now */);

// this forces the agent to send all current metrics to the server.
// good to call when the server is shutting down or similar
I.flush();
````
