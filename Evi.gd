extends PanelContainer

func get_drag_data(position):
	var mydata = {"name": $VBoxContainer/name.text}
	var icon = $VBoxContainer/bg/Icon.duplicate()
	var c = Control.new()
	c.add_child(icon)
	icon.rect_position = -0.5 * icon.rect_size
	set_drag_preview(c)
	return mydata
