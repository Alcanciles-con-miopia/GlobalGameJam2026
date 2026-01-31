extends Node
class_name SoundManager  

@onready var bgm: AudioStreamPlayer2D = $BGM
@onready var sfx: AudioStreamPlayer2D = $SFX

@export_dir var bgm_folder: String = "res://audio/bgm"
@export_dir var sfx_folder: String = "res://audio/sfx"

var bgm_tracks: Dictionary = {}
var sfx_tracks: Dictionary = {}

var current_bgm_name: String = ""
var bgm_volume_db: float = 0.0
var sfx_volume_db: float = 0.0


func _ready() -> void:
	_load_audio()


func _load_audio() -> void:
	bgm_tracks.clear()
	sfx_tracks.clear()

	# --- Cargar BGM ---
	var dir_bgm := DirAccess.open(bgm_folder)
	if dir_bgm:
		dir_bgm.list_dir_begin()
		var file := dir_bgm.get_next()
		while file != "":
			if not dir_bgm.current_is_dir():
				if file.ends_with(".ogg") or file.ends_with(".wav"):
					var path := bgm_folder + "/" + file
					var key := file.get_basename()
					bgm_tracks[key] = ResourceLoader.load(path)
			file = dir_bgm.get_next()
		dir_bgm.list_dir_end()

	# --- Cargar SFX ---
	var dir_sfx := DirAccess.open(sfx_folder)
	if dir_sfx:
		dir_sfx.list_dir_begin()
		var file2 := dir_sfx.get_next()
		while file2 != "":
			if not dir_sfx.current_is_dir():
				if file2.ends_with(".ogg") or file2.ends_with(".wav"):
					var path2 := sfx_folder + "/" + file2
					var key2 := file2.get_basename()
					sfx_tracks[key2] = ResourceLoader.load(path2)
			file2 = dir_sfx.get_next()
		dir_sfx.list_dir_end()



#=== MÚSICA (BGM) ===

func play_bgm(name: String, loop: bool = true) -> void:
	if not bgm_tracks.has(name):
		push_warning("SoundManager: BGM '%s' no encontrado" % name)
		return

	if current_bgm_name == name and bgm.playing:
		return

	current_bgm_name = name
	bgm.stop()
	bgm.stream = bgm_tracks[name]
	if bgm.stream:
		bgm.stream.loop = loop
	bgm.volume_db = bgm_volume_db
	bgm.play()


func stop_bgm() -> void:
	bgm.stop()
	current_bgm_name = ""


func set_bgm_volume_db(db: float) -> void:
	bgm_volume_db = db
	bgm.volume_db = db



#=== EFECTOS (SFX) ===

func play_sfx(name: String, pitch_variation: float = 0.0) -> void:
	if not sfx_tracks.has(name):
		push_warning("SoundManager: SFX '%s' no encontrado" % name)
		return

	sfx.stream = sfx_tracks[name]
	sfx.volume_db = sfx_volume_db
	
	if sfx.stream:
		sfx.stream.loop = false

	if pitch_variation > 0.0:
		var base_pitch := 1.0
		var random_delta := randf_range(-pitch_variation, pitch_variation)
		sfx.pitch_scale = base_pitch + random_delta
	else:
		sfx.pitch_scale = 1.0

	sfx.play()


func set_sfx_volume_db(db: float) -> void:
	sfx_volume_db = db
	sfx.volume_db = db

#SFX específicos de máscaras (Hermenegildo / Susi)
# player_id: 1 = Hermenegildo, 2 = Susi
# "move" "rotate" o "scale"
func play_mask_sfx(player_id: int, action: String) -> void:
	var prefix := ""

	var character := Global.Character.SUSI
	if player_id == 1:
		character = Global.player1_character
	elif player_id == 2:
		character = Global.player2_character

	match character:
		Global.Character.SUSI:
			prefix = "susi"
		Global.Character.HERMENEGILDO:
			prefix = "herme"
		_:
			prefix = "herme"  # fallback

	if prefix == "":
		return

	var key := "%s_%s" % [prefix, action]  # ej "susi_move", "herme_rotate"

	play_sfx(key, 0.05)

func stop_sfx() -> void:
	if sfx.playing:
		sfx.stop()
