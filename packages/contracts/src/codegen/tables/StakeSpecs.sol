// SPDX-License-Identifier: MIT
pragma solidity >=0.8.24;

/* Autogenerated file. Do not edit manually. */

// Import store internals
import { IStore } from "@latticexyz/store/src/IStore.sol";
import { StoreSwitch } from "@latticexyz/store/src/StoreSwitch.sol";
import { StoreCore } from "@latticexyz/store/src/StoreCore.sol";
import { Bytes } from "@latticexyz/store/src/Bytes.sol";
import { Memory } from "@latticexyz/store/src/Memory.sol";
import { SliceLib } from "@latticexyz/store/src/Slice.sol";
import { EncodeArray } from "@latticexyz/store/src/tightcoder/EncodeArray.sol";
import { FieldLayout } from "@latticexyz/store/src/FieldLayout.sol";
import { Schema } from "@latticexyz/store/src/Schema.sol";
import { EncodedLengths, EncodedLengthsLib } from "@latticexyz/store/src/EncodedLengths.sol";
import { ResourceId } from "@latticexyz/store/src/ResourceId.sol";

struct StakeSpecsData {
  bytes16 buildingType;
  uint40 timeCost;
  bytes32[] inputs;
  bytes32[] outputs;
}

library StakeSpecs {
  // Hex below is the result of `WorldResourceIdLib.encode({ namespace: "", name: "StakeSpecs", typeId: RESOURCE_TABLE });`
  ResourceId constant _tableId = ResourceId.wrap(0x746200000000000000000000000000005374616b655370656373000000000000);

  FieldLayout constant _fieldLayout =
    FieldLayout.wrap(0x0015020210050000000000000000000000000000000000000000000000000000);

  // Hex-encoded key schema of (bytes16)
  Schema constant _keySchema = Schema.wrap(0x001001004f000000000000000000000000000000000000000000000000000000);
  // Hex-encoded value schema of (bytes16, uint40, bytes32[], bytes32[])
  Schema constant _valueSchema = Schema.wrap(0x001502024f04c1c1000000000000000000000000000000000000000000000000);

  /**
   * @notice Get the table's key field names.
   * @return keyNames An array of strings with the names of key fields.
   */
  function getKeyNames() internal pure returns (string[] memory keyNames) {
    keyNames = new string[](1);
    keyNames[0] = "outputType";
  }

  /**
   * @notice Get the table's value field names.
   * @return fieldNames An array of strings with the names of value fields.
   */
  function getFieldNames() internal pure returns (string[] memory fieldNames) {
    fieldNames = new string[](4);
    fieldNames[0] = "buildingType";
    fieldNames[1] = "timeCost";
    fieldNames[2] = "inputs";
    fieldNames[3] = "outputs";
  }

  /**
   * @notice Register the table with its config.
   */
  function register() internal {
    StoreSwitch.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Register the table with its config.
   */
  function _register() internal {
    StoreCore.registerTable(_tableId, _fieldLayout, _keySchema, _valueSchema, getKeyNames(), getFieldNames());
  }

  /**
   * @notice Get buildingType.
   */
  function getBuildingType(bytes16 outputType) internal view returns (bytes16 buildingType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (bytes16(_blob));
  }

  /**
   * @notice Get buildingType.
   */
  function _getBuildingType(bytes16 outputType) internal view returns (bytes16 buildingType) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 0, _fieldLayout);
    return (bytes16(_blob));
  }

  /**
   * @notice Set buildingType.
   */
  function setBuildingType(bytes16 outputType, bytes16 buildingType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((buildingType)), _fieldLayout);
  }

  /**
   * @notice Set buildingType.
   */
  function _setBuildingType(bytes16 outputType, bytes16 buildingType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.setStaticField(_tableId, _keyTuple, 0, abi.encodePacked((buildingType)), _fieldLayout);
  }

  /**
   * @notice Get timeCost.
   */
  function getTimeCost(bytes16 outputType) internal view returns (uint40 timeCost) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes32 _blob = StoreSwitch.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint40(bytes5(_blob)));
  }

  /**
   * @notice Get timeCost.
   */
  function _getTimeCost(bytes16 outputType) internal view returns (uint40 timeCost) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes32 _blob = StoreCore.getStaticField(_tableId, _keyTuple, 1, _fieldLayout);
    return (uint40(bytes5(_blob)));
  }

  /**
   * @notice Set timeCost.
   */
  function setTimeCost(bytes16 outputType, uint40 timeCost) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((timeCost)), _fieldLayout);
  }

  /**
   * @notice Set timeCost.
   */
  function _setTimeCost(bytes16 outputType, uint40 timeCost) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.setStaticField(_tableId, _keyTuple, 1, abi.encodePacked((timeCost)), _fieldLayout);
  }

  /**
   * @notice Get inputs.
   */
  function getInputs(bytes16 outputType) internal view returns (bytes32[] memory inputs) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Get inputs.
   */
  function _getInputs(bytes16 outputType) internal view returns (bytes32[] memory inputs) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 0);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Set inputs.
   */
  function setInputs(bytes16 outputType, bytes32[] memory inputs) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((inputs)));
  }

  /**
   * @notice Set inputs.
   */
  function _setInputs(bytes16 outputType, bytes32[] memory inputs) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.setDynamicField(_tableId, _keyTuple, 0, EncodeArray.encode((inputs)));
  }

  /**
   * @notice Get the length of inputs.
   */
  function lengthInputs(bytes16 outputType) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get the length of inputs.
   */
  function _lengthInputs(bytes16 outputType) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 0);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get an item of inputs.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemInputs(bytes16 outputType, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Get an item of inputs.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemInputs(bytes16 outputType, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 0, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Push an element to inputs.
   */
  function pushInputs(bytes16 outputType, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to inputs.
   */
  function _pushInputs(bytes16 outputType, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 0, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from inputs.
   */
  function popInputs(bytes16 outputType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 0, 32);
  }

  /**
   * @notice Pop an element from inputs.
   */
  function _popInputs(bytes16 outputType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 0, 32);
  }

  /**
   * @notice Update an element of inputs at `_index`.
   */
  function updateInputs(bytes16 outputType, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of inputs at `_index`.
   */
  function _updateInputs(bytes16 outputType, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 0, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get outputs.
   */
  function getOutputs(bytes16 outputType) internal view returns (bytes32[] memory outputs) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes memory _blob = StoreSwitch.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Get outputs.
   */
  function _getOutputs(bytes16 outputType) internal view returns (bytes32[] memory outputs) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    bytes memory _blob = StoreCore.getDynamicField(_tableId, _keyTuple, 1);
    return (SliceLib.getSubslice(_blob, 0, _blob.length).decodeArray_bytes32());
  }

  /**
   * @notice Set outputs.
   */
  function setOutputs(bytes16 outputType, bytes32[] memory outputs) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((outputs)));
  }

  /**
   * @notice Set outputs.
   */
  function _setOutputs(bytes16 outputType, bytes32[] memory outputs) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.setDynamicField(_tableId, _keyTuple, 1, EncodeArray.encode((outputs)));
  }

  /**
   * @notice Get the length of outputs.
   */
  function lengthOutputs(bytes16 outputType) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    uint256 _byteLength = StoreSwitch.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get the length of outputs.
   */
  function _lengthOutputs(bytes16 outputType) internal view returns (uint256) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    uint256 _byteLength = StoreCore.getDynamicFieldLength(_tableId, _keyTuple, 1);
    unchecked {
      return _byteLength / 32;
    }
  }

  /**
   * @notice Get an item of outputs.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function getItemOutputs(bytes16 outputType, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _blob = StoreSwitch.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Get an item of outputs.
   * @dev Reverts with Store_IndexOutOfBounds if `_index` is out of bounds for the array.
   */
  function _getItemOutputs(bytes16 outputType, uint256 _index) internal view returns (bytes32) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _blob = StoreCore.getDynamicFieldSlice(_tableId, _keyTuple, 1, _index * 32, (_index + 1) * 32);
      return (bytes32(_blob));
    }
  }

  /**
   * @notice Push an element to outputs.
   */
  function pushOutputs(bytes16 outputType, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Push an element to outputs.
   */
  function _pushOutputs(bytes16 outputType, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.pushToDynamicField(_tableId, _keyTuple, 1, abi.encodePacked((_element)));
  }

  /**
   * @notice Pop an element from outputs.
   */
  function popOutputs(bytes16 outputType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.popFromDynamicField(_tableId, _keyTuple, 1, 32);
  }

  /**
   * @notice Pop an element from outputs.
   */
  function _popOutputs(bytes16 outputType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.popFromDynamicField(_tableId, _keyTuple, 1, 32);
  }

  /**
   * @notice Update an element of outputs at `_index`.
   */
  function updateOutputs(bytes16 outputType, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreSwitch.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Update an element of outputs at `_index`.
   */
  function _updateOutputs(bytes16 outputType, uint256 _index, bytes32 _element) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    unchecked {
      bytes memory _encoded = abi.encodePacked((_element));
      StoreCore.spliceDynamicData(_tableId, _keyTuple, 1, uint40(_index * 32), uint40(_encoded.length), _encoded);
    }
  }

  /**
   * @notice Get the full data.
   */
  function get(bytes16 outputType) internal view returns (StakeSpecsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreSwitch.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Get the full data.
   */
  function _get(bytes16 outputType) internal view returns (StakeSpecsData memory _table) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    (bytes memory _staticData, EncodedLengths _encodedLengths, bytes memory _dynamicData) = StoreCore.getRecord(
      _tableId,
      _keyTuple,
      _fieldLayout
    );
    return decode(_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function set(
    bytes16 outputType,
    bytes16 buildingType,
    uint40 timeCost,
    bytes32[] memory inputs,
    bytes32[] memory outputs
  ) internal {
    bytes memory _staticData = encodeStatic(buildingType, timeCost);

    EncodedLengths _encodedLengths = encodeLengths(inputs, outputs);
    bytes memory _dynamicData = encodeDynamic(inputs, outputs);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using individual values.
   */
  function _set(
    bytes16 outputType,
    bytes16 buildingType,
    uint40 timeCost,
    bytes32[] memory inputs,
    bytes32[] memory outputs
  ) internal {
    bytes memory _staticData = encodeStatic(buildingType, timeCost);

    EncodedLengths _encodedLengths = encodeLengths(inputs, outputs);
    bytes memory _dynamicData = encodeDynamic(inputs, outputs);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function set(bytes16 outputType, StakeSpecsData memory _table) internal {
    bytes memory _staticData = encodeStatic(_table.buildingType, _table.timeCost);

    EncodedLengths _encodedLengths = encodeLengths(_table.inputs, _table.outputs);
    bytes memory _dynamicData = encodeDynamic(_table.inputs, _table.outputs);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Set the full data using the data struct.
   */
  function _set(bytes16 outputType, StakeSpecsData memory _table) internal {
    bytes memory _staticData = encodeStatic(_table.buildingType, _table.timeCost);

    EncodedLengths _encodedLengths = encodeLengths(_table.inputs, _table.outputs);
    bytes memory _dynamicData = encodeDynamic(_table.inputs, _table.outputs);

    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.setRecord(_tableId, _keyTuple, _staticData, _encodedLengths, _dynamicData, _fieldLayout);
  }

  /**
   * @notice Decode the tightly packed blob of static data using this table's field layout.
   */
  function decodeStatic(bytes memory _blob) internal pure returns (bytes16 buildingType, uint40 timeCost) {
    buildingType = (Bytes.getBytes16(_blob, 0));

    timeCost = (uint40(Bytes.getBytes5(_blob, 16)));
  }

  /**
   * @notice Decode the tightly packed blob of dynamic data using the encoded lengths.
   */
  function decodeDynamic(
    EncodedLengths _encodedLengths,
    bytes memory _blob
  ) internal pure returns (bytes32[] memory inputs, bytes32[] memory outputs) {
    uint256 _start;
    uint256 _end;
    unchecked {
      _end = _encodedLengths.atIndex(0);
    }
    inputs = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());

    _start = _end;
    unchecked {
      _end += _encodedLengths.atIndex(1);
    }
    outputs = (SliceLib.getSubslice(_blob, _start, _end).decodeArray_bytes32());
  }

  /**
   * @notice Decode the tightly packed blobs using this table's field layout.
   * @param _staticData Tightly packed static fields.
   * @param _encodedLengths Encoded lengths of dynamic fields.
   * @param _dynamicData Tightly packed dynamic fields.
   */
  function decode(
    bytes memory _staticData,
    EncodedLengths _encodedLengths,
    bytes memory _dynamicData
  ) internal pure returns (StakeSpecsData memory _table) {
    (_table.buildingType, _table.timeCost) = decodeStatic(_staticData);

    (_table.inputs, _table.outputs) = decodeDynamic(_encodedLengths, _dynamicData);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function deleteRecord(bytes16 outputType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreSwitch.deleteRecord(_tableId, _keyTuple);
  }

  /**
   * @notice Delete all data for given keys.
   */
  function _deleteRecord(bytes16 outputType) internal {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    StoreCore.deleteRecord(_tableId, _keyTuple, _fieldLayout);
  }

  /**
   * @notice Tightly pack static (fixed length) data using this table's schema.
   * @return The static data, encoded into a sequence of bytes.
   */
  function encodeStatic(bytes16 buildingType, uint40 timeCost) internal pure returns (bytes memory) {
    return abi.encodePacked(buildingType, timeCost);
  }

  /**
   * @notice Tightly pack dynamic data lengths using this table's schema.
   * @return _encodedLengths The lengths of the dynamic fields (packed into a single bytes32 value).
   */
  function encodeLengths(
    bytes32[] memory inputs,
    bytes32[] memory outputs
  ) internal pure returns (EncodedLengths _encodedLengths) {
    // Lengths are effectively checked during copy by 2**40 bytes exceeding gas limits
    unchecked {
      _encodedLengths = EncodedLengthsLib.pack(inputs.length * 32, outputs.length * 32);
    }
  }

  /**
   * @notice Tightly pack dynamic (variable length) data using this table's schema.
   * @return The dynamic data, encoded into a sequence of bytes.
   */
  function encodeDynamic(bytes32[] memory inputs, bytes32[] memory outputs) internal pure returns (bytes memory) {
    return abi.encodePacked(EncodeArray.encode((inputs)), EncodeArray.encode((outputs)));
  }

  /**
   * @notice Encode all of a record's fields.
   * @return The static (fixed length) data, encoded into a sequence of bytes.
   * @return The lengths of the dynamic fields (packed into a single bytes32 value).
   * @return The dynamic (variable length) data, encoded into a sequence of bytes.
   */
  function encode(
    bytes16 buildingType,
    uint40 timeCost,
    bytes32[] memory inputs,
    bytes32[] memory outputs
  ) internal pure returns (bytes memory, EncodedLengths, bytes memory) {
    bytes memory _staticData = encodeStatic(buildingType, timeCost);

    EncodedLengths _encodedLengths = encodeLengths(inputs, outputs);
    bytes memory _dynamicData = encodeDynamic(inputs, outputs);

    return (_staticData, _encodedLengths, _dynamicData);
  }

  /**
   * @notice Encode keys as a bytes32 array using this table's field layout.
   */
  function encodeKeyTuple(bytes16 outputType) internal pure returns (bytes32[] memory) {
    bytes32[] memory _keyTuple = new bytes32[](1);
    _keyTuple[0] = bytes32(outputType);

    return _keyTuple;
  }
}
