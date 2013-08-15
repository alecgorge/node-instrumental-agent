net = require 'net'
_	= require 'underscore'

settings = 
	api_key 		: false
	hostname 		: 'instrumentalapp.com'
	port 			: 8000
	timeout			: 10000
	max_queue_size	: 100

buffer = []
on_ready = null
socket = false
socket_connected = false

write_line = (line) ->
	socket.write line + "\n"

write_buffer = () ->
	return if buffer.length is 0

	c = buffer.slice 0
	connect ->
		socket.end c.join("\n")+"\n"
	buffer = []

queue_api = (method, args) ->
	buffer.push(method + " " + args.join(" "))

	if buffer.length > settings.max_queue_size
		write_buffer()

connect = (cb = null) ->
	socket = net.createConnection port: settings.port, host: settings.hostname
	socket.setEncoding 'ascii'

	socket.on 'connect', () ->
		write_line "hello version 1.0\n" + "authenticate #{settings.api_key}"

	socket.on 'error', (err) ->

	socket.on 'close', (had_error) ->
		socket_connected = false

	socket.on 'data', (buffer) ->
		if buffer is "ok\nok\n"
			on_ready(true) if on_ready
			cb() if cb

			socket_connected = true
			write_buffer()

		else if buffer is "ok\nfail\n"
			on_ready(false) if on_ready
			socket_connected = false
			socket.end()

module.exports =
	setup: (new_settings, ready = null) ->
		on_ready = ready
		_.extend settings, new_settings

	flush: () -> write_buffer()

	increment: (metric, increment_by = 1, timestamp = null) ->
		timestamp = Math.round(+new Date()/1000) if timestamp is null
		queue_api "increment", [metric, increment_by, timestamp]

	gauge: (metric, measurement, timestamp = null) ->
		timestamp = Math.round(+new Date()/1000) if timestamp is null
		queue_api "gauge", [metric, increment_by, timestamp]

	gauge_absolute: (metric, measurement, timestamp = null) ->
		timestamp = Math.round(+new Date()/1000) if timestamp is null
		queue_api "gauge_absolute", [metric, increment_by, timestamp]

	notice: (event, duration = 0, timestamp = null) ->
		timestamp = Math.round(+new Date()/1000) if timestamp is null
		queue_api "notice", [timestamp, duration, event]
