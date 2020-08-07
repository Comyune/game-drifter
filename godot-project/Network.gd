extends Node

export (String) var topic_name = "room:default"
const default_socket_url = "ws://localhost:4000/socket"
const game_name = "drifter"

var socket : PhoenixSocket
var channel : PhoenixChannel
var presence : PhoenixPresence

func _ready():
	socket = PhoenixSocket.new(default_socket_url, {})
	
	# Subscribe to Socket events
	socket.connect("on_open", self, "_on_Socket_open")
	socket.connect("on_close", self, "_on_Socket_close")
	socket.connect("on_error", self, "_on_Socket_error")
	socket.connect("on_connecting", self, "_on_Socket_connecting")
	
	# If you want to track Presence
	# presence = PhoenixPresence.new()
	
	# Subscribe to Presence events (sync_diff and sync_state are also implemented)
	# presence.connect("on_join", self, "_on_Presence_join")
	# presence.connect("on_leave", self, "_on_Presence_leave")
	
	# Create a Channel
	channel = socket.channel(topic_name, { game_name = game_name }, presence)
	
	# Subscribe to Channel events
	channel.connect("on_event", self, "_on_Channel_event")
	channel.connect("on_join_result", self, "_on_Channel_join_result")
	channel.connect("on_error", self, "_on_Channel_error")
	channel.connect("on_close", self, "_on_Channel_close")
	
	call_deferred("add_child", socket, true)
	socket.connect_socket()

# Socket events

func _on_Socket_open(payload): print("_on_Socket_open: ", payload)
func _on_Socket_close(payload): print("_on_Socket_close: ", payload)
func _on_Socket_error(payload): print("_on_Socket_error: ", payload)

func _on_Socket_connecting(is_connecting):
	print("3 _on_Socket_connecting: is connecting? ", is_connecting)
	if is_connecting: return
	print("4 Socket is connected, starting to join channel")
	channel.join()

# Channel events

func _on_Channel_event(event, payload, status):
	print("5/7 _on_Channel_event:  ", event, ", ", status, ", ", payload)
	if payload.has('event') and payload.event == "joined":
		var result = channel.push("start", {})
		print("Sent start message. Result:", result)

func _on_Channel_join_result(status, result):
	print("6 _on_Channel_join_result:  ", status, result)

func _on_Channel_error(error):
	print("_on_Channel_error: " + str(error))

func _on_Channel_close(closed):
	print("_on_Channel_close: " + str(closed))

#
# Presence events
#

func _on_Presence_join(joins):
	print("_on_Presence_join: " + str(joins))

func _on_Presence_leave(leaves):
	print("_on_Presence_leave: " + str(leaves))
