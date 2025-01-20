// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";
import {TestToken} from "../src/mocks/TestToken.sol";

import {ERC1155StakeandBurnCityBuilderXpert} from "../src/ERC1155StakeandBurnCityBuilderXpert.sol";

contract ERC1155StakeandBurnCityBuilderXpertScript is Script {
    TestToken public testToken;
    ERC1155StakeandBurnCityBuilderXpert public builder;

    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        testToken = new TestToken();
        builder = new ERC1155StakeandBurnCityBuilderXpert();

        testToken.setApprovalForAll(address(builder), true);
        builder.stakeERC1155(address(testToken), 1, 1);

        vm.stopBroadcast();
    }
}
