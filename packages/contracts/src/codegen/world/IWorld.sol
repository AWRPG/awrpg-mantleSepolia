// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

import { IBaseWorld } from "@latticexyz/world/src/codegen/interfaces/IBaseWorld.sol";

import { IErrors } from "./IErrors.sol";
import { IBuilding2System } from "./IBuilding2System.sol";
import { IBuildingSystem } from "./IBuildingSystem.sol";
import { ICombatSystem } from "./ICombatSystem.sol";
import { IItemSystem } from "./IItemSystem.sol";
import { IMiningSystem } from "./IMiningSystem.sol";
import { IMoveSystem } from "./IMoveSystem.sol";
import { IPlayerSystem } from "./IPlayerSystem.sol";
import { IStorageSystem } from "./IStorageSystem.sol";
import { ISwapSystem } from "./ISwapSystem.sol";
import { ITerrainSystem } from "./ITerrainSystem.sol";

/**
 * @title IWorld
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @notice This interface integrates all systems and associated function selectors
 * that are dynamically registered in the World during deployment.
 * @dev This is an autogenerated file; do not edit manually.
 */
interface IWorld is
  IBaseWorld,
  IErrors,
  IBuilding2System,
  IBuildingSystem,
  ICombatSystem,
  IItemSystem,
  IMiningSystem,
  IMoveSystem,
  IPlayerSystem,
  IStorageSystem,
  ISwapSystem,
  ITerrainSystem
{}
