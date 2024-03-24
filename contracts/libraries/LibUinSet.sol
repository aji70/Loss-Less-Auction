// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

library UintSet {
    struct Set {
        uint256[] values;
        mapping(uint256 => uint256) indexes;
        mapping(uint256 => bool) isInSet;
    }

    function add(Set storage set, uint256 value) internal {
        if (!contains(set, value)) {
            set.values.push(value);
            set.indexes[value] = set.values.length;
            set.isInSet[value] = true;
        }
    }

    function remove(Set storage set, uint256 value) internal {
        if (contains(set, value)) {
            uint256 index = set.indexes[value] - 1;
            uint256 lastIndex = set.values.length - 1;
            uint256 lastValue = set.values[lastIndex];

            set.values[index] = lastValue;
            set.indexes[lastValue] = index + 1;

            set.values.pop();
            delete set.indexes[value];
            delete set.isInSet[value];
        }
    }

    function contains(
        Set storage set,
        uint256 value
    ) internal view returns (bool) {
        return set.isInSet[value];
    }

    function length(Set storage set) internal view returns (uint256) {
        return set.values.length;
    }

    function at(
        Set storage set,
        uint256 index
    ) internal view returns (uint256) {
        require(index < set.values.length, "Index out of bounds");
        return set.values[index];
    }
}
