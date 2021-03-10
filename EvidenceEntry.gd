extends Button

onready var tex_icon = $HBoxContainer/VBoxContainer/bg/Icon
onready var tex_bg = $HBoxContainer/VBoxContainer/bg
onready var lbl_name = $HBoxContainer/VBoxContainer/name

var just_dragged = false

signal combine(first, second)
signal show_popup(evi_name)

func get_drag_data(position):
	var mydata = {"name": lbl_name.text}
	var icon = tex_icon.duplicate()
	var c = Control.new()
	c.add_child(icon)
	icon.rect_position = -0.5 * icon.rect_size
	set_drag_preview(c)
	return mydata

func set_icon(tex: Texture):
	tex_icon.set_texture(tex)

func set_name(string: String):
	lbl_name.set_text(string)

func set_desc(string: String):
	hint_tooltip = string

func can_drop_data(position, data):
	# Check position if it is relevant to you
	# Otherwise, just check data
	return typeof(data) == TYPE_DICTIONARY and data.has("name")

func drop_data(position, data):
	emit_signal("combine", data.name, lbl_name.text)

func _on_pressed():
	if just_dragged:
		just_dragged = get_viewport().gui_is_dragging()
		return
	var icon = tex_icon.duplicate()
	var c = Control.new()
	c.add_child(icon)
	icon.rect_position = -0.5 * icon.rect_size
	force_drag({"name": lbl_name.text}, c)

func _on_button_down():
	just_dragged = get_viewport().gui_is_dragging()
	yield(get_tree().create_timer(0.8), "timeout")
	if not get_viewport().gui_is_dragging():
		emit_signal("show_popup", lbl_name.text)
