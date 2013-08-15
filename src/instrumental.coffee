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

	buffer.forEach (v, k) ->
		write_line v

	buffer = []

queue_api = (method, args) ->
	buffer.push(method + " " + args.join(" "))

	if buffer.length > settings.max_queue_size
		connect() if not socket_connected
		write_buffer() if socket_connected

connect = () ->
	socket = net.createConnection port: settings.port, host: settings.hostname
	socket.setEncoding 'ascii'

	socket.on 'connect', () ->
		write_line "hello version 1.0\n" + "authenticate #{settings.api_key}"

	socket.on 'error', (err) ->
		console.log err
		throw err

	socket.on 'close', (had_error) ->
		socket_connected = false
		connect() if had_error

	socket.on 'data', (buffer) ->
		if buffer is "ok\nok\n"
			on_ready() if on_ready

			socket_connected = true
			write_buffer()

		else if (""+buffer).indexOf("fail") > -1
			socket_connected = false
			socket.end()

			throw "Invalid Instrumental App API Key";

module.exports =
	setup: (new_settings, ready = null) ->
		on_ready = ready
		_.extend settings, new_settings

		connect()

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
