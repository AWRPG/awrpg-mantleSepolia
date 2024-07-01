import { Entity, getComponentValue } from "@latticexyz/recs";
import { ClientComponents } from "../mud/createClientComponents";
import { getEntitySpecs, isPoolType } from "./entity";
import { SetupNetworkResult } from "../mud/setupNetwork";
import { Hex, pad } from "viem";
import { encodeEntity } from "@latticexyz/store-sync/recs";
import { getPool } from "../contract/hashes";
import { encodeTypeEntity } from "../utils/encode";

export function canStoreERC721(
  components: ClientComponents,
  entityType: Entity,
  store: Entity
) {
  const { SizeSpecs } = components;
  const size = getComponentValue(SizeSpecs, entityType)?.size;
  return canIncreaseStoredSize(components, store, size ?? 0n);
}

export function canStoreERC20Amount(
  components: ClientComponents,
  resourceType: Entity,
  store: Entity
) {
  const { StoredSize, ContainerSpecs, SizeSpecs } = components;
  const storedSize = getComponentValue(StoredSize, store)?.value ?? 0n;
  const resourceSize = getComponentValue(SizeSpecs, resourceType)?.size;
  const capacity = getEntitySpecs(components, ContainerSpecs, store)?.capacity;
  if (!resourceSize || !capacity) return 0n;
  return (capacity - storedSize) / resourceSize;
}

export function canIncreaseStoredSize(
  components: ClientComponents,
  store: Entity,
  increaseSize: bigint,
  network?: SetupNetworkResult
) {
  if (network) {
    const space = pad(network.worldContract.address) as Hex;
    if (store === space) return true;
  }
  const { ContainerSpecs, StoredSize } = components;
  const storedSize = getComponentValue(StoredSize, store)?.value ?? 0n;
  const capacity = getEntitySpecs(components, ContainerSpecs, store)?.capacity;
  return capacity && capacity >= storedSize + increaseSize;
}

export const getRemainedERC20Amount = (
  components: ClientComponents,
  role: Hex,
  erc20Type: Hex
) => {
  const { StoredSize, ContainerSpecs, SizeSpecs } = components;
  const store = getERC20Store(role, erc20Type) as Entity;
  const storedSize = getComponentValue(StoredSize, store)?.value ?? 0n;
  const erc20TypeEntity = encodeTypeEntity(erc20Type) as Entity;
  const erc20Size = getComponentValue(SizeSpecs, erc20TypeEntity)?.size ?? 1n;
  const capacity =
    getEntitySpecs(components, ContainerSpecs, store)?.capacity ?? 0n;
  return (capacity - storedSize) / erc20Size;
};

// general usage for both pool & role
export const getERC20Capacity = (
  components: ClientComponents,
  role: Hex,
  erc20Type: Hex
): bigint => {
  const store = getERC20Store(role, erc20Type);
  const { ContainerSpecs } = components;
  return (
    getEntitySpecs(components, ContainerSpecs, store as Entity)?.capacity ?? 0n
  );
};

// general usage for both pool & role
export const hasERC20Balance = (
  components: ClientComponents,
  role: Hex,
  erc20Type: Hex,
  amount: bigint
) => {
  return getERC20Balance(components, role, erc20Type) >= amount;
};

// general usage for both pool & role
export const getERC20Balance = (
  components: ClientComponents,
  role: Hex,
  erc20Type: Hex
) => {
  const store = getERC20Store(role, erc20Type);
  return getBalance(components, store as Entity, erc20Type);
};

// general usage for both pool & role
export const getERC20Store = (role: Hex, erc20Type: Hex) => {
  return isPoolType(erc20Type) ? getPool(role, erc20Type) : role;
};

export function getBalance(
  components: ClientComponents,
  store: Entity,
  erc20Type: Hex
) {
  const balanceEntity = getBalanceEntity(erc20Type, store as Hex);
  return getComponentValue(components.Balance, balanceEntity)?.value ?? 0n;
}

export function hasBalance(
  components: ClientComponents,
  store: Entity,
  erc20Type: Hex,
  amount: bigint
) {
  const balance = getBalance(components, store, erc20Type);
  return balance && balance >= amount;
}

export function getBalanceEntity(entityType: Hex, owner: Hex) {
  const entity = encodeEntity(
    { entityType: "bytes16", owner: "bytes32" },
    {
      entityType,
      owner: pad(owner),
    }
  );
  return entity;
}