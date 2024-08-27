// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { TypeCast } from "@/utils/TypeCast.sol";

// terrain entity ~ 9 types
// terrains: 1) when removed, can award player with stuff;
bytes16 constant RED_MINE = bytes16("RED_MINE");
bytes16 constant TREE = bytes16("TREE");
bytes16 constant ROCK = bytes16("ROCK");
bytes16 constant BUSH = bytes16("BUSH");
bytes16 constant GRASS = bytes16("GRASS");
bytes16 constant GRAVEL = bytes16("GRAVEL");
bytes16 constant SAND = bytes16("SAND");
bytes16 constant WATER = bytes16("WATER");
bytes16 constant YELLOW_MINE = bytes16("YELLOW_MINE");

// building entity
// buildings: 1) to store, to stop, to export, to produce;
// 2) obtained via crafting
// 3) placed on map
bytes16 constant SAFE = bytes16("SAFE");
bytes16 constant FENCE = bytes16("FENCE");
bytes16 constant NODE = bytes16("NODE");
bytes16 constant FOUNDRY = bytes16("FOUNDRY");

// consumable entity ~ erc20
// consumables: 1) when eaten, increase player's stats;
// 2) can be used for crafting
// 2) obtained via defeating enemies or from map
bytes16 constant BERRY = bytes16("BERRY");
bytes16 constant FISH = bytes16("FISH");
// store in custodian when defeating an enemy
bytes16 constant MEAT = bytes16("MEAT");
bytes16 constant RED = bytes16("RED");
bytes16 constant YELLOW = bytes16("YELLOW");

// material entity ~ erc20
// materials: 1) used to build buildings;
// 2) obtained via defeating enemies or from map
bytes16 constant WOOD = bytes16("WOOD");
bytes16 constant SKIN = bytes16("SKIN");
bytes16 constant ROCK_M = bytes16("ROCK_M");
bytes16 constant SAND_M = bytes16("SAND_M");

// weapon entity ~ erc721
// weapons: 1) used to increase dmg; 2) used to destroy buildings & terrain
// 3) can be obtained via crafting
// 4) can be obtained via looting
bytes16 constant HOST = bytes16("HOST");
// player pool
bytes16 constant POOL = bytes16("POOL");
bytes16 constant BLOOD = bytes16("BLOOD");
bytes16 constant SOUL = bytes16("SOUL");
bytes16 constant STAMINA = bytes16("STAMINA");

// terrain
bytes16 constant OCEAN = bytes16("OCEAN");
bytes16 constant FOREST = bytes16("FOREST");
bytes16 constant PLAIN = bytes16("PLAIN");
bytes16 constant MOUNTAIN = bytes16("MOUNTAIN");

function space() view returns (bytes32) {
  return TypeCast.toBytes32(StoreSwitch.getStoreAddress());
}
