// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

/**
 * @title ISwapSystem
 * @author MUD (https://mud.dev) by Lattice (https://lattice.xyz)
 * @dev This interface is automatically generated from the corresponding system contract. Do not edit manually.
 */
interface ISwapSystem {
  function setSwapRatio(bytes16 fromType, bytes16 toType, bytes32 host, uint16 num, uint16 denom) external;

  function swapERC20(bytes16 fromType, bytes16 toType, bytes32 from, bytes32 to, uint128 amount) external;
}