import { Entity, getComponentValue, Component } from "@latticexyz/recs";
import { Hex } from "viem";
import { ClientComponents } from "../mud/createClientComponents";
import { encodeTypeEntity } from "../utils/encode";
import { BLOOD, HOST, STAMINA } from "../contract/constants";
import { POOL_TYPES } from "../constants";

export function getEntitySpecs<
  S extends ClientComponents[keyof ClientComponents]["schema"],
>(components: ClientComponents, specsComponent: Component<S>, entity: Entity) {
  const entityType = getComponentValue(components.EntityType, entity)
    ?.value as Hex;
  const specs = getComponentValue(
    specsComponent,
    encodeTypeEntity(entityType ?? "") as Entity
  );

  return specs;
}

export function isPoolType(entityType: Hex) {
  return POOL_TYPES.includes(entityType);
}

export function isBuilding(components: ClientComponents, entity: Entity) {
  return (
    getEntitySpecs(components, components.BuildingSpecs, entity) !== undefined
  );
}

export function isRole(components: ClientComponents, entity: Entity) {
  const entityType = getComponentValue(components.EntityType, entity)
    ?.value as Hex;
  return entityType === HOST;
}
