// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {ERC1155StakeandBurnCityBuilderXpert} from "../src/ERC1155StakeandBurnCityBuilderXpert.sol";

contract ERC1155StakeandBurnCityBuilderXpertScript is Script {
    ERC1155StakeandBurnCityBuilderXpert public stakingContract;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        stakingContract = new ERC1155StakeandBurnCityBuilderXpert();

        vm.stopBroadcast();
    }
}
