extends Control

onready var dialog
var input_next: String = 'ui_right'
var input_previous: String = 'ui_left'

var is_testimony = false
var index = -1
var testimony_name = ""
# This is the list of text statements.
var testimony = []
# This is the list of timelines to open in Dialogic for the presses.
var press_timelines = []

func _ready():
	dialog = Dialogic.start("intro")
	add_child(dialog)
	move_child(dialog, 0)
	dialog.connect("dialogic_signal", self, "_on_dialogic_signal")


func _input(event):
	if not is_testimony:
		return
	if event.is_action_pressed(input_next):
		index = (index + 1) % testimony.size()
		dialog.update_text("[color=lime]" + testimony[index] + "[/color]")
	elif event.is_action_pressed(input_previous):
		if index <= 0:
			return
		index -= 1
		dialog.update_text("[color=lime]" + testimony[index] + "[/color]")
	elif event.is_action_pressed("ui_up"):
		# Valid press index
		if index >= 0 and index < testimony.size() and press_timelines[index] != null:
			press(index)


func press(id):
	index = (index + 1) % testimony.size()
	is_testimony = false
	dialog.queue_free()
	print(press_timelines)
	dialog = Dialogic.start(press_timelines[id])
	add_child(dialog)
	move_child(dialog, 0)
	dialog.connect("dialogic_signal", self, "_on_dialogic_signal")


func _on_dialogic_signal(value):
	var params = value.split(' ', true, 2)
	print(params)
	if params[0] == "testimony":
		if params.size() < 1:
			print("Invalid 'testimony' signal length - please pass 'clear', 'name', 'add', 'set', 'start' or 'return'.")
			return
		if params[1] == "clear":
			testimony.clear()
			press_timelines.clear()
			testimony_name = ""
			is_testimony = false
		elif params[1] == "name":
			testimony_name = params[2].trim_suffix('"').trim_prefix('"')
		elif params[1] == "add":
			var index = testimony.size()
			var text = params[2]
			var split = params[2].split(' ', true, 1)
			if split[0].is_valid_integer():
				index = int(split[0])
				text = split[1]
				var statement = text.trim_suffix('"').trim_prefix('"')
				testimony.insert(index, statement)
			elif split[0] == "press":
				split = split[1].split(' ', true, 1)
				text = split[0]
				if split[0].is_valid_integer():
					index = int(split[0])
					text = split[1]
				var timeline = text.trim_suffix('"').trim_prefix('"')
				press_timelines.resize(index)
				press_timelines.insert(index-1, timeline)
			else:
				var statement = text.trim_suffix('"').trim_prefix('"')
				testimony.insert(index, statement)
		elif params[1] == "set":
			var index = testimony.size()
			var text = params[2]
			var split = params[2].split(' ', true, 1)
			if split[0].is_valid_integer():
				index = int(split[0])
				text = split[1]
				var statement = text.trim_suffix('"').trim_prefix('"')
				testimony[index] = statement
			elif split[0] == "press":
				split = split[1].split(' ', true, 1)
				if split[0].is_valid_integer():
					index = int(split[0])
					text = split[1]
				var timeline = text.trim_suffix('"').trim_prefix('"')
				press_timelines[index] = timeline
		elif params[1] == "start":
			if dialog:
				dialog.queue_free()
			dialog = Dialogic.start("")
			add_child(dialog)
			move_child(dialog, 0)
			dialog.input_next = ""
			if testimony_name != "":
				index = -1
				dialog.update_text("[center][color=#FF8800]" + testimony_name + "[/color][/center]")
			else:
				index = 0
				dialog.update_text("[color=lime]" + testimony[index] + "[/color]")
			is_testimony = true
		elif params[1] == "return":
			if dialog:
				dialog.queue_free()
			dialog = Dialogic.start("")
			add_child(dialog)
			move_child(dialog, 0)
			dialog.input_next = ""
			if index <= -1:
				index = 0
			if index >= testimony.size():
				index = testimony.size() - 1
			dialog.update_text("[color=lime]" + testimony[index] + "[/color]")
			is_testimony = true


func _on_Button_pressed():
	$Evidence.visible = !$Evidence.visible


func _on_Evidence_present(evi_id):
	$Evidence.visible = false
	# "Autopsy Report" presented on "Your Mom"
	if evi_id == 2 and index == 2:
		dialog.queue_free()
		dialog = Dialogic.start("outro")
		add_child(dialog)
		move_child(dialog, 0)
		dialog.connect("dialogic_signal", self, "_on_dialogic_signal")
