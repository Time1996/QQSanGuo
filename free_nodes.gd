extends Node

signal freeig_orphans

func free_orphaned_nodes():
	emit_signal("freeig_orphans")
	pass
