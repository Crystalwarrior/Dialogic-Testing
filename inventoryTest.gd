extends Control

onready var evi_template = preload("res://EvidenceEntry.tscn")
onready var evi_container = $VBoxContainer/EvidenceContainer/ScrollContainer/Evidences

func _ready():
	$EvidenceDialog.popup_centered()
	update_evidence(Data.evidence)

func update_evidence(list: Array):
	var length = list.size()
	if evi_container.get_child_count() < length:
		for i in length:
			var evi_entry = evi_template.instance()
			evi_entry.connect("combine", self, "_on_evidence_combine")
			evi_entry.connect("show_popup", self, "_on_evidence_popup")
			evi_container.add_child(evi_entry)
	for i in evi_container.get_child_count():
		var child = evi_container.get_child(i)
		if i >= length:
			child.queue_free()
			continue
		var evidence = list[i]
		child.set_icon(evidence.icon)
		child.set_name(evidence.name)
		child.set_desc(evidence.desc)

func _on_Button_pressed():
	evi_container.visible = !evi_container.visible

func _on_PresentButton_pressed():
	var icon = $EvidenceDialog/HBoxContainer/VBoxContainer/bg/Icon.duplicate()
	var c = Control.new()
	c.add_child(icon)
	icon.rect_position = -0.5 * icon.rect_size
	force_drag({"name": $EvidenceDialog/HBoxContainer/VBoxContainer/name.text}, c)
	$EvidenceDialog.visible = false

func _on_evidence_popup(evi_name):
	for evi in Data.evidence:
		if evi.name == evi_name:
			$EvidenceDialog/HBoxContainer/VBoxContainer/bg/Icon.texture = evi.icon
			$EvidenceDialog/HBoxContainer/VBoxContainer/name.text = evi.name
			$EvidenceDialog/HBoxContainer/desc.text = evi.desc
			$EvidenceDialog.popup_centered()
			break

func _on_evidence_combine(first, second):
	print("Combining %s with %s" % [first, second])
