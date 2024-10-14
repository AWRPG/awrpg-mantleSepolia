import { Entity, HasValue } from "@latticexyz/recs";
import { Hex, hexToString } from "viem";
import { useMUD } from "../../MUDContext";
import { useBalance } from "../../logics/container";
import { ERC20_TYPES } from "../../constants";
import { useComponentValue, useEntityQuery } from "@latticexyz/react";
import EntityName from "../EntityName";
import { useEquipmentInfo, useHostEquipments } from "../../logics/equipment";
import { WEAPON } from "../../contract/constants";
import { EntityPools } from "./Pool";
import { useInSpace } from "../../logics/drop";

/**
 * display whatever in role's bag, FT, NFT, equipped NFT; canDrop & isPlayer is checked and passed down
 */
export function Bag({ host }: { host: Entity }) {
  const { components, network } = useMUD();
  const { Owner, Commander } = components;
  const canDrop = useInSpace(components, network, host);
  const isPlayer =
    useComponentValue(Commander, host)?.value === network.playerEntity;
  const erc20Whitelist = ERC20_TYPES;
  const erc721Entities = useEntityQuery([HasValue(Owner, { value: host })]);
  const equippedEntities = useHostEquipments(components, host);
  return (
    <div className="flex flex-col space-y-0 text-sm">
      <div className="text-lg">Bag:</div>
      {erc20Whitelist.map((erc20Type, index) => (
        <FTItem
          key={index}
          host={host}
          erc20Type={erc20Type}
          canDrop={canDrop}
          isPlayer={isPlayer}
        />
      ))}
      {erc721Entities.map((erc721Entity, index) => (
        <NFTItem
          key={index}
          host={host}
          entity={erc721Entity}
          canDrop={canDrop}
          isPlayer={isPlayer}
        />
      ))}
      <div className="text-lg pt-4">Equipment:</div>
      {equippedEntities.map((equippedEntity, index) => (
        <EquippedItem
          key={index}
          host={host}
          entity={equippedEntity}
          canDrop={canDrop}
          isPlayer={isPlayer}
        />
      ))}
    </div>
  );
}

/**
 * display role's FT item; if isPlayer, may drop or consume;
 * @note: dropERC20 can drop more than 1n, but consumeERC20 can only consume 1n per tx
 */
export function FTItem({
  host,
  erc20Type,
  canDrop = false,
  isPlayer = false,
}: {
  host: Entity;
  erc20Type: Hex;
  canDrop?: boolean;
  isPlayer?: boolean;
}) {
  const { components, systemCalls } = useMUD();
  const { dropERC20, consumeERC20 } = systemCalls;
  const balance = useBalance(components, host, erc20Type);
  if (!balance || balance === 0n) return null;
  return (
    <div className="flex flex-row">
      <span>
        {hexToString(erc20Type)}x{Number(balance)}
      </span>
      {isPlayer && canDrop && (
        <button
          className="ml-2 px-2 bg-blue-500 text-white text-sm rounded hover:bg-blue-700"
          onClick={() => dropERC20(host as Hex, erc20Type, 1n)}
        >
          Drop x1
        </button>
      )}
      {isPlayer && (
        <button
          className="ml-2 px-2 bg-blue-500 text-white text-sm rounded hover:bg-blue-700"
          onClick={() => consumeERC20(host as Hex, erc20Type)}
        >
          Consume x1
        </button>
      )}
    </div>
  );
}

/**
 * display NFT item; if isPlayer, may drop or equip
 * @note: only equip as WEAPON, can add options to equip as ARMOR
 */
export function NFTItem({
  host,
  entity,
  canDrop = false,
  isPlayer = false,
}: {
  host: Entity;
  entity: Entity;
  canDrop?: boolean;
  isPlayer?: boolean;
}) {
  const { components, systemCalls } = useMUD();
  const { equip, dropERC721 } = systemCalls;
  // const isEquipped = useIsEquipped(components, host, entity);
  return (
    <div className="flex flex-row space-x-2">
      <EntityName entity={entity} />
      <EntityPools entity={entity} />
      {isPlayer && canDrop && (
        <button
          className="ml-2 px-2 bg-blue-500 text-white text-sm rounded hover:bg-blue-700 self-start"
          onClick={() => dropERC721(entity as Hex)}
        >
          Drop
        </button>
      )}
      {isPlayer && (
        <button
          className="ml-2 px-2 bg-blue-500 text-white text-sm rounded hover:bg-blue-700 self-start"
          onClick={() => equip(entity as Hex, WEAPON)}
        >
          Equip as {hexToString(WEAPON)}
        </button>
      )}
    </div>
  );
}

/**
 * display equipped nft item; if isPlayer, can unequip
 */
export function EquippedItem({
  host,
  entity,
  canDrop = false,
  isPlayer = false,
}: {
  host: Entity;
  entity: Entity;
  canDrop?: boolean;
  isPlayer?: boolean;
}) {
  const { components, systemCalls } = useMUD();
  const { unequip } = systemCalls;
  const info = useEquipmentInfo(components, entity);
  if (!info) return null;
  return (
    <div className="flex flex-row space-x-2">
      <span className="font-bold">{hexToString(info.equipType)}:</span>
      <EntityName entity={entity} />
      <EntityPools entity={entity} />
      {isPlayer && (
        <button
          className="ml-2 px-2 bg-blue-500 text-white text-sm rounded hover:bg-blue-700 self-start"
          onClick={() => unequip(host as Hex, info.equipType)}
        >
          Unequip
        </button>
      )}
    </div>
  );
}