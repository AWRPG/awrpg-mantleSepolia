// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0;

import { TileEntity, Moves, Path, PathData } from "@/codegen/index.sol";
import { MapLogic } from "@/libraries/MapLogic.sol";
import { TerrainLogic } from "@/libraries/TerrainLogic.sol";
import { EntityLogic } from "@/libraries/EntityLogic.sol";
import { PathLogic } from "@/libraries/PathLogic.sol";
import { BuildingLogic } from "@/libraries/BuildingLogic.sol";
import { MapLogic } from "@/libraries/MapLogic.sol";
import { Errors } from "@/Errors.sol";
import "@/constants.sol";

uint8 constant MAX_MOVES = 20;
uint32 constant STAMINA_COST = 10;
uint32 constant MOVE_DURATION = 300;

library MoveLogic {
  enum Direction {
    NONE,
    UP,
    DOWN,
    LEFT,
    RIGHT
  }

  function _move(bytes32 host, uint8[] memory moves) internal {
    // TODO: burn stamina
    // uint32 staminaCost = uint32(moves.length) * STAMINA_COST;
    (uint32 fromTileX, uint32 fromTileY) = getMoveFromCoordStrict(host);

    (uint32 toTileX, uint32 toTileY) = getMoveToCoordStrict(host, fromTileX, fromTileY, moves);

    TileEntity.deleteRecord(MapLogic.getCoordId(fromTileX, fromTileY));
    TileEntity.set(MapLogic.getCoordId(toTileX, toTileY), host);

    Path.set(
      host,
      PathData(
        fromTileX,
        fromTileY,
        toTileX,
        toTileY,
        uint40(block.timestamp),
        uint40((moves.length * MOVE_DURATION) / 1000)
      )
    );
    Moves.set(host, combineMoves(moves));
  }

  // for host to move from, host must be on ground & arrived
  function getMoveFromCoordStrict(bytes32 host) internal view returns (uint32 tileX, uint32 tileY) {
    if (!PathLogic.arrived(host)) revert Errors.NotArrived();
    tileX = Path.getToTileX(host);
    tileY = Path.getToTileY(host);
    if (!onGround(host, tileX, tileY)) revert Errors.NotOnGround();
  }

  // combine moves into one uint256; each move is 4 bits; 20 moves = 80 bits;
  function combineMoves(uint8[] memory moves) internal pure returns (uint256) {
    uint256 result = 0;
    for (uint256 i = 0; i < moves.length; i++) {
      result |= uint256(moves[i]) << (4 * i);
    }
    return result;
  }

  // check if the host is on ground
  function onGround(bytes32 host, uint32 tileX, uint32 tileY) internal view returns (bool) {
    return TileEntity.get(MapLogic.getCoordId(tileX, tileY)) == host;
  }

  // // return moves with length = 20
  // function splitMoves(uint256 _moves) internal pure returns (uint8[] memory moves) {
  //   moves = new uint8[](MAX_MOVES);
  //   for (uint256 i = 0; i < MAX_MOVES; i++) {
  //     uint8 move = uint8(_moves >> (4 * i));
  //     if (move == 0) return moves;

  //     moves[i] = uint8(move);
  //   }
  //   return moves;
  // }

  // for host to move to, moves & terrain must be valid
  function getMoveToCoordStrict(
    bytes32 host,
    uint32 fromTileX,
    uint32 fromTileY,
    uint8[] memory moves
  ) internal view returns (uint32 toX, uint32 toY) {
    if (moves.length > MAX_MOVES) revert Errors.ExceedMaxMoves();
    uint64[] memory toTiles = moves2Tiles(moves, fromTileX, fromTileY);
    canArriveOnTileStrict(host, toTiles);
    return split(toTiles[toTiles.length - 1]);
  }

  // check if host can move across a series of toTile coords & arrive on the last one
  function canArriveOnTileStrict(bytes32 host, uint64[] memory toTiles) internal view {
    for (uint256 i = 1; i < toTiles.length - 1; i++) {
      (uint32 _x, uint32 _y) = split(toTiles[i]);
      canMoveAcrossTileStrict(host, _x, _y);
    }
    (uint32 x, uint32 y) = split(toTiles[toTiles.length - 1]);
    canMoveToTileStrict(host, x, y);
  }

  // check if host can move across a tile coord, which is not the destination
  function canMoveAcrossTileStrict(bytes32 host, uint32 tileX, uint32 tileY) internal view {
    if (!TerrainLogic.canMoveToTerrain(host, tileX, tileY)) revert Errors.CannotMoveToTerrain();
    bytes32 tileId = MapLogic.getCoordId(tileX, tileY);
    bytes32 tileEntity = TileEntity.get(tileId);
    // role can be moved across
    if (EntityLogic.isRole(tileEntity)) return;
    // some building can move to
    if (BuildingLogic.canMoveTo(tileEntity)) return;
    revert Errors.CannotMoveAcrossBuilding();
  }

  // check if host can move to a tile coord
  // Rn, cannot move to a tile coord that has an entity on, building or role
  function canMoveToTileStrict(bytes32 host, uint32 tileX, uint32 tileY) internal view {
    if (!TerrainLogic.canMoveToTerrain(host, tileX, tileY)) revert Errors.CannotMoveToTerrain();
    bytes32 tileId = MapLogic.getCoordId(tileX, tileY);
    bytes32 tileEntity = TileEntity.get(tileId);
    if (tileEntity != 0) revert Errors.CannotMoveOnEntity(tileId);
  }

  // convert moves fromX&Y to toTile coords
  function moves2Tiles(uint8[] memory moves, uint32 fromX, uint32 fromY) internal pure returns (uint64[] memory) {
    uint64[] memory toTiles = new uint64[](moves.length);
    uint32 newX = fromX;
    uint32 newY = fromY;
    for (uint256 i = 0; i < moves.length; i++) {
      toTiles[i] = move2Tile(moves[i], newX, newY);
      (newX, newY) = split(toTiles[i]);
    }
    return toTiles;
  }

  // convert 1 move fromX&Y to 1 toTile coord
  function move2Tile(uint8 move, uint32 fromX, uint32 fromY) internal pure returns (uint64) {
    if (move == uint8(Direction.UP)) {
      return combine(fromX, fromY - 1);
    } else if (move == uint8(Direction.DOWN)) {
      return combine(fromX, fromY + 1);
    } else if (move == uint8(Direction.LEFT)) {
      return combine(fromX - 1, fromY);
    } else if (move == uint8(Direction.RIGHT)) {
      return combine(fromX + 1, fromY);
    } else {
      revert Errors.InvalidMove();
    }
  }

  // combine two uint32 into one uint64
  function combine(uint32 x, uint32 y) internal pure returns (uint64) {
    return (uint64(x) << 32) | y;
  }

  // split one uint64 into two uint32
  function split(uint64 xy) internal pure returns (uint32, uint32) {
    uint32 x = uint32(xy >> 32);
    uint32 y = uint32(xy);
    return (x, y);
  }
}
