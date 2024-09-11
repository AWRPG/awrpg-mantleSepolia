import {
  Entity,
  getComponentValue,
  HasValue,
  runQuery,
} from "@latticexyz/recs";
import { ClientComponents } from "../mud/createClientComponents";
import {
  decodeTypeEntity,
  encodeTypeEntity,
  splitBytes32,
} from "../utils/encode";
import { Hex } from "viem";
import { CostInfoType, getCostsInfo, hasCosts } from "./cost";
import { unixTimeSecond } from "../utils/time";

export const getBuildingStakeOuputTypes = (
  components: ClientComponents,
  building: Entity
) => {
  const { StakeSpecs, EntityType } = components;
  const type = getComponentValue(EntityType, building)?.value as Hex;
  const outputTypes = [
    ...runQuery([HasValue(StakeSpecs, { buildingType: type })]),
  ];
  console.log("outputTypes", outputTypes, type);
  return outputTypes.map(
    (outputType) => decodeTypeEntity(outputType as Hex) as Hex
  );
};

export const hasStakeInputs = (
  components: ClientComponents,
  role: Hex,
  stakeType: Hex
) => {
  const inputs = getStakeInputs(components, stakeType);
  if (inputs.length === 0) return false;
  return hasCosts(components, role, inputs as Hex[]);
};

export const getStakeInputs = (
  components: ClientComponents,
  stakeType: Hex
) => {
  const typeEntity = encodeTypeEntity(stakeType) as Entity;
  const inputs =
    getComponentValue(components.StakeSpecs, typeEntity)?.inputs ?? [];
  return inputs;
};

// get whether role has stake inputs
export const getStakeInputsInfo = (
  components: ClientComponents,
  stakeType: Hex,
  role: Hex
) => {
  const inputs = getStakeInputs(components, stakeType);
  return getCostsInfo(components, role, inputs as Hex[]);
};

export type StakeInfoType = {
  stakeType: Hex;
  inputs: CostInfoType[];
  outputs: { type: Hex; amount: number }[];
  buildingType: Hex;
  timeCost: number;
};

// convert stakeSpecs to stakeInfo
export const getStakeInfo = (
  components: ClientComponents,
  stakeType: Hex,
  role: Hex
): StakeInfoType | undefined => {
  const { StakeSpecs, EntityType } = components;
  const typeEntity = encodeTypeEntity(stakeType) as Entity;
  const stakeSpec = getComponentValue(StakeSpecs, typeEntity);
  if (!stakeSpec) return;
  const buildingType = stakeSpec.buildingType as Hex;
  const outputs = stakeSpec.outputs.map((cost) => splitBytes32(cost as Hex));
  const inputs = getCostsInfo(components, role, stakeSpec.inputs as Hex[]);
  const timeCost = stakeSpec.timeCost;
  return {
    stakeType,
    inputs,
    outputs,
    buildingType,
    timeCost,
  };
};

export const getBuildingStakesInfo = (
  components: ClientComponents,
  building: Entity,
  role?: Hex
) => {};

// ------------- staking info -------------
export type StakingInfoType = {
  building: Hex;
  role: Hex;
  stakeType: Hex;
  inputs: { type: Hex; amount: number }[];
  outputs: { type: Hex; amount: number }[];
  timeCost: number;
  lastUpdated: number;
  ready: boolean;
};

// get all staking ids in building
export const getBuildingStakingIds = (
  components: ClientComponents,
  building: Hex
) => {
  const { StakingInfo } = components;
  const stakingIds = [...runQuery([HasValue(StakingInfo, { building })])];
  return stakingIds;
};

// get staking ids of provided role in the building
export const getRoleInBuildingStakingIds = (
  components: ClientComponents,
  building: Hex,
  role: Hex
) => {
  const { StakingInfo } = components;
  const stakingIds = [...runQuery([HasValue(StakingInfo, { building, role })])];
  return stakingIds as Hex[];
};

// get info not only from StakingInfo, but also from StakeSpecs
// to display them on UI
export const getStakingInfo = (
  components: ClientComponents,
  stakingId: Hex
): StakingInfoType | undefined => {
  const { StakingInfo, StakeSpecs } = components;
  const stakingInfo = getComponentValue(StakingInfo, stakingId as Entity);
  if (!stakingInfo) return;
  const { building, role, lastUpdated, outputType } = stakingInfo;
  const stakeSpecs = getComponentValue(
    StakeSpecs,
    encodeTypeEntity(outputType as Hex) as Entity
  );
  if (!stakeSpecs) return;
  const { timeCost } = stakeSpecs;
  const outputs = stakeSpecs.outputs.map((cost) => splitBytes32(cost as Hex));
  const inputs = stakeSpecs.inputs.map((cost) => splitBytes32(cost as Hex));
  const ready = lastUpdated + timeCost <= unixTimeSecond();
  return {
    building: building as Hex,
    role: role as Hex,
    stakeType: outputType as Hex,
    inputs,
    outputs,
    timeCost,
    lastUpdated,
    ready,
  };
};
