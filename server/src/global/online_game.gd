extends Node

#MULTIPLAYER INT
var multiplayer_peer = ENetMultiplayerPeer.new()
func create_server() -> void:
	multiplayer_peer.create_server(Settings.PORT)
	multiplayer.multiplayer_peer = multiplayer_peer

#VARS/SIGNALS
signal HandlePackages(type:String,packages:Array[Dictionary])
var RecivedPackages:Dictionary[String,Array] = {}

signal Call(id:int,information:String)

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
func send_package_all(package:Dictionary) -> void:
	rpc("recive_package",package)

func send_reliable_package_all(package:Dictionary) -> void:
	rpc("recive_reliable_package",package)

func send_package_id(id:int,package:Dictionary) -> void:
	rpc_id(id,"recive_package",package)

func send_reliable_package_id(id:int,package:Dictionary) -> void:
	rpc_id(id,"recive_reliable_package",package)

@rpc("any_peer","unreliable_ordered")
func recive_package(package:Dictionary) -> void:
	if !RecivedPackages.has(package.type):
		RecivedPackages[package.type] = []
	RecivedPackages[package.type].append(package.data)
	
@rpc("any_peer","reliable")
func recive_reliable_package(package:Dictionary) -> void:
	if !RecivedPackages.has(package.type):
		RecivedPackages[package.type] = []
	RecivedPackages[package.type].append(package.data)

#CALLS
func send_call_all(info:String) -> void:
	rpc("recive_call",1,info)

func send_call_id(id:int,info:String) -> void:
	rpc_id(id,"recive_call",1,info)

@rpc("any_peer","reliable")
func recive_call(id:int,info:String) -> void:
	Call.emit(id,info)
