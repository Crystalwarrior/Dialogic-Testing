extends Control

func _on_Button_pressed():
	$VBoxContainer/HBoxContainer/ScrollContainer.visible = !$VBoxContainer/HBoxContainer/ScrollContainer.visible
