extends Node

#MULTIPLAYER INT
var multiplayer_peer = ENetMultiplayerPeer.new()
func create_client() -> void:
	multiplayer_peer.create_client(Settings.IP_ADDRESS,Settings.PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

#VARS/SIGNALS
signal HandlePackages(type:String,packages:Array[Dictionary])
var RecivedPackages:Dictionary[String,Array] = {}

signal Call(information:String)

#PACKAGE HANDELING
func update() -> void:
	for Type:String in RecivedPackages:
		for Package:Dictionary in RecivedPackages[Type]:
			if Package.has("KILL"):
				RecivedPackages[Type].erase(Package)
		if RecivedPackages[Type].is_empty():
			RecivedPackages.erase(Type)
	for Type:String in RecivedPackages:
		HandlePackages.emit(Type,RecivedPackages[Type])

#PACKAGES
func send_package(package:Dictionary) -> void:
	rpc_id(1,"recive_package",package)

func send_reliable_package(package:Dictionary) -> void:
	rpc_id(1,"recive_reliable_package",package)

@rpc("authority","unreliable_ordered")
func recive_package(package:Dictionary) -> void:
	if !RecivedPackages.has(package.type):
		RecivedPackages[package.type] = []
	RecivedPackages[package.type].append(package.data)
	
@rpc("authority","reliable")
func recive_reliable_package(package:Dictionary) -> void:
	if !RecivedPackages.has(package.type):
		RecivedPackages[package.type] = []
	RecivedPackages[package.type].append(package.data)

#CALLS
func send_call(info:String) -> void:
	rpc_id(1,"recive_call",multiplayer.get_unique_id(),info)

@rpc("authority","reliable") #no id needed for client
func recive_call(_id:int,info:String) -> void:
	Call.emit(info)
