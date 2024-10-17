import { UIScene } from "../scenes/UIScene";
import { GuiBase } from "./GuiBase";
import { ALIGNMODES } from "../../constants";
import { UIList } from "../components/ui/common/UIList";
import { Box } from "../components/ui/Box";
import { Box2 } from "../components/ui/Box2";
import { UIText } from "../components/ui/common/UIText";
import { ButtonA } from "../components/ui/ButtonA";
import { MenuTitle } from "../components/ui/MenuTitle";
import { UIController } from "../components/controllers/UIController";
import { SceneObjectController } from "../components/controllers/SceneObjectController";
import { Host } from "../objects/Host";

/**
 * show the action buttons player can do
 */
export class ActionMenu extends GuiBase {
  list: UIList;
  role?: Host;

  /** */
  constructor(scene: UIScene) {
    super(
      scene,
      new Box(scene, {
        width: 360,
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
      itemWidth: 260,
      itemHeight: 48,
      spacingY: 12,
      parent: this.rootUI,
      onCancel: () => {
        this.hidden();
        SceneObjectController.resetFocus();
        SceneObjectController.controllable = true;
      },
    });
    const item1 = new ButtonA(scene, {
      text: "Move",
      onConfirm: () => {
        this.hidden();
        if (this.role) UIController.scene.moveTips?.show(this.role);
      },
    });
    this.list.addItem(item1);
    const item2 = new ButtonA(scene, {
      text: "Build",
      onConfirm: () => {
        this.hidden();
        if (this.role) UIController.scene.buildMenu?.show(this.role);
      },
      onCancel: () => {
        this.show();
      },
    });
    this.list.addItem(item2);
    const item3 = new ButtonA(scene, {
      text: "Change Terrain",
      onConfirm: () => {
        this.hidden();
      },
    });
    this.list.addItem(item3);
    this.focusUI = this.list;
  }

  show(role?: Host) {
    super.show();
    this.role = role ?? this.role;
    SceneObjectController.focus = this.role;
    UIController.controllable = true;
  }
}
