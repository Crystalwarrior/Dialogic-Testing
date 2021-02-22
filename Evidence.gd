extends Control


onready var itemlist = $Evidence/List/VBoxContainer/Container/ItemList
onready var closeup = $Evidence/Closeup
onready var evi_name = $Evidence/Closeup/HBoxContainer/VBoxContainer/PanelContainer/Name
onready var evi_desc = $Evidence/Closeup/HBoxContainer/VBoxContainer/ColorRect/Description
onready var image = $Evidence/Closeup/HBoxContainer/Image


var evidence_list = []
var current_selected = -1

signal present(evi_id)

func _ready():
	closeup.set_visible(false)
	var badge_icon = preload("res://evidence/badge.png")
	add_evidence("Badge", "This is my badge. You are not welcome in my badge.", badge_icon)
	var list_icon = preload("res://evidence/list.png")
	add_evidence("List", "It lists the numerous reason why you suck.", list_icon)
	var envelope_icon = preload("res://evidence/envelope.png")
	add_evidence("Autopsy Report", "It describes in vivid detail how the witness is still alive.", envelope_icon)


func add_evidence(name, description, icon):
	var evidence = {
		"name": name,
		"description": description,
		"icon": icon,
	}
	evidence_list.append(evidence)
	itemlist.add_icon_item(evidence.icon)


func open_evidence(idx):
#	print(evidence_list[idx])
	closeup.set_visible(true)
	var evidence = evidence_list[idx]
	evi_name.set_text(evidence.name)
	evi_desc.set_text(evidence.description)
	image.set_texture(evidence.icon)


func _on_ItemList_item_selected(index):
	open_evidence(index)
	current_selected = index
	$PresentButton.set_disabled(false)


func _on_ItemList_nothing_selected():
	pass
	#deselect_evidence()


func deselect_evidence():
	closeup.set_visible(false)
	itemlist.unselect_all()
	current_selected = -1
	$PresentButton.set_disabled(true)


func get_current_evidence():
	if current_selected == -1:
		return
	return evidence_list[current_selected]


func set_current_evidence(index):
	if index > evidence_list.length():
		return
	current_selected = index
#	itemlist.unselect_all()
	itemlist.select(index)
	return evidence_list[index]


func _on_PresentButton_pressed():
	emit_signal("present", current_selected)
