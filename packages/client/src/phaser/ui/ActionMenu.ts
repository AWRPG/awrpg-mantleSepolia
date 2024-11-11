import { UIScene } from "../scenes/UIScene";
import { GuiBase } from "./GuiBase";
import { ALIGNMODES, ERC20_TYPES, SOURCE } from "../../constants";
import { UIList } from "../components/ui/common/UIList";
import { Box } from "../components/ui/Box";
import { Box2 } from "../components/ui/Box2";
import { UIText } from "../components/ui/common/UIText";
import { ButtonA } from "../components/ui/ButtonA";
import { MenuTitle } from "../components/ui/MenuTitle";
import { UIController } from "../components/controllers/UIController";
import { SceneObjectController } from "../components/controllers/SceneObjectController";
import { Role } from "../objects/Role";
import { PlayerInput } from "../components/controllers/PlayerInput";
import { ItemsListMenu } from "./common/ItemsListMenu";
import { combineToEntity } from "../../logics/move";
import { getDropContainer, getCanPickupERC20 } from "../../logics/drop";
import {
  Entity,
  getComponentValue,
  runQuery,
  HasValue,
} from "@latticexyz/recs";
import { isHost } from "../../logics/entity";
import {
  encodeTypeEntity,
  fromEntity,
  hexTypeToString,
} from "../../utils/encode";
import { ItemData } from "../../api/data";
import { getBalance } from "../../logics/container";
import { Hex } from "viem";
import {
  convertTerrainTypesToValues,
  GRID_SIZE,
  TileTerrain,
} from "../../logics/terrain";
import { AttackTips } from "./AttackTips";

/**
 * show the action buttons player can do
 */
export class ActionMenu extends GuiBase {
  list: UIList;
  role?: Role;

  attackTips?: AttackTips;

  /** */
  constructor(scene: UIScene) {
    super(
      scene,
      new Box(scene, {
        width: 380,
        height: 210,
        alignModeName: ALIGNMODES.MIDDLE_CENTER,
        marginX: 220,
      })
    );

    this.name = "ActionMenu";

    // Title
    const titleBox = new Box2(scene, {
      width: 178,
      height: 58,
      alignModeName: ALIGNMODES.RIGHT_TOP,
      marginX: 8,
      marginY: -36,
      parent: this.rootUI,
    });
    new MenuTitle(scene, "ACTIONS", { parent: titleBox });

    // Button list
    this.list = new UIList(scene, {
      marginY: 28,
      itemWidth: 328,
      itemHeight: 48,
      spacingY: 12,
      parent: this.rootUI,
      onCancel: () => {
        this.hidden();
        SceneObjectController.resetFocus();
        PlayerInput.onlyListenSceneObject();
      },
    });
    this.focusUI = this.list;
  }

  show(role?: Role) {
    super.show();
    this.role = role ?? this.role;
    SceneObjectController.focus = this.role;
    this.updateList();
    PlayerInput.onlyListenUI();
  }

  updateList() {
    const items = [];

    // [Button] Move
    const item_move = new ButtonA(this.scene, {
      text: "Move",
      onConfirm: () => {
        this.hidden();
        if (this.role) UIController.scene.moveTips?.show(this.role, this);
      },
    });
    items.push(item_move);

    // [Button] Construct
    const item_construct = new ButtonA(this.scene, {
      text: "Construct",
      onConfirm: () => {
        this.hidden();
        if (this.role) UIController.scene.constructMenu?.show(this.role, this);
      },
    });
    items.push(item_construct);

    // [Button] Attack
    const item_attack = new ButtonA(this.scene, {
      text: "Attack",
      onConfirm: () => {
        this.hidden();
        if (this.role) {
          this.attackTips = new AttackTips(this.scene);
          this.attackTips.show(this.role, this);
        }
      },
    });
    items.push(item_attack);

    // [Button] Pick up
    const item_pick = this.updatePickupButton();
    if (item_pick) items.push(item_pick);

    // [Button] Change Terrain
    const item_changeTerrain = new ButtonA(this.scene, {
      text: "<DM> Plain Create",
      // disable: true,
      onConfirm: () => {
        this.hidden();
        SceneObjectController.resetFocus();
        PlayerInput.onlyListenSceneObject();

        if (!this.role) return;
        const gridCoord = {
          x: Math.floor(this.role.tileX / GRID_SIZE),
          y: Math.floor(this.role.tileY / GRID_SIZE),
        };
        const terrainMatrix = [
          [3, 3, 3, 3, 3, 3, 3, 3],
          [3, 3, 3, 3, 3, 3, 3, 3],
          [3, 3, 3, 3, 3, 3, 3, 3],
          [3, 3, 3, 3, 3, 3, 3, 3],
          [3, 3, 3, 3, 3, 3, 3, 3],
          [3, 3, 3, 3, 3, 3, 3, 3],
          [3, 3, 3, 3, 3, 3, 3, 3],
          [3, 3, 3, 3, 3, 3, 3, 3],
        ];
        const terrainTypes: TileTerrain[] = [];
        terrainMatrix.forEach((row, i) => {
          row.forEach((terrain, j) => {
            terrainTypes.push({
              i,
              j,
              terrainType: terrainMatrix[j][i],
            });
          });
        });
        const terrainValues = convertTerrainTypesToValues(terrainTypes);
        this.systemCalls.setTerrainValues(gridCoord, terrainValues);
      },
    });
    items.push(item_changeTerrain);

    this.list.items = items;

    (this.rootUI as Box).setSlices(
      undefined,
      this.list.itemsCount * (this.list.itemHeight + this.list.spacingY) + 56
    );

    if (this.list.itemIndex < 0 || this.list.itemIndex >= this.list.itemsCount)
      this.list.itemIndex = 0;
    else this.list.itemIndex = this.list.itemIndex;
  }

  updatePickupButton() {
    if (!this.role) return;
    const toHost = this.role.entity;
    const { Owner, StoredSize, SelectedHost } = this.components;

    const tile = combineToEntity(this.role.tileX, this.role.tileY);
    const drop = getDropContainer(this.role.tileX, this.role.tileY) as Entity;
    const noLoots = (getComponentValue(StoredSize, drop)?.value ?? 0n) === 0n;
    if (noLoots) return;

    const datas: ItemData[] = [];

    // FT
    const erc20Whitelist = ERC20_TYPES;
    erc20Whitelist.forEach((erc20Type, index) => {
      const balance = getBalance(this.components, drop, erc20Type);
      if (balance && balance !== 0n) {
        const data = {
          type: hexTypeToString(erc20Type),
          entity: erc20Type as Entity,
          amount: Number(balance),
        };
        datas.push(data);
      }
    });

    // NFT
    const entities = [...runQuery([HasValue(Owner, { value: drop })])];
    entities.forEach((entity, index) => {
      const { type, id } = fromEntity(entity as Hex);
      const data = {
        type: hexTypeToString(type),
        entity,
        amount: 1,
        id: Number(id),
      };
      datas.push(data);
    });

    const item_pick = new ButtonA(this.scene, {
      text: "Pick up",
      onConfirm: () => {
        if (!this.role) {
          UIController.focus = this.focusUI;
          return;
        }
        const itemsListMenu = new ItemsListMenu(this.scene, this.role);
        itemsListMenu.show(this, datas);
      },
    });
    return item_pick;
  }
}
