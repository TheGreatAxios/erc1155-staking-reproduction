// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Test, console} from "forge-std/Test.sol";
import {TestToken} from "../src/mocks/TestToken.sol";
import {ERC1155StakeandBurnCityBuilderXpert} from "../src/ERC1155StakeandBurnCityBuilderXpert.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract ERC1155StakeandBurnCityBuilderXpertTest is Test, ERC1155Holder {
    TestToken public testToken;
    ERC1155StakeandBurnCityBuilderXpert public builder;

    function setUp() public {
        testToken = new TestToken();
        builder = new ERC1155StakeandBurnCityBuilderXpert();
    }

    function test_Approval() public {
        testToken.setApprovalForAll(address(builder), true);
        assertEq(testToken.isApprovedForAll(address(this), address(builder)), true);
    }

    function test_Stake1() public {
        testToken.setApprovalForAll(address(builder), true);
        builder.stakeERC1155(address(testToken), 1, 1);

        // Validate Staked Balance
        uint256 stakedBalance = builder.stakedBalances(address(this), 1);
        assertEq(stakedBalance, 1);

        // Validate Staking Records
        (uint256 amountStaked, uint256 stakeTimestamp) = builder.stakingRecords(address(this), 1, 0);
        assertEq(amountStaked, 1);
        assertEq(stakeTimestamp, block.timestamp);
    }

    function testFail_Unstake1() public {
        testToken.setApprovalForAll(address(builder), true);
        builder.stakeERC1155(address(testToken), 1, 1);

        // Validate Staked Balance
        uint256 stakedBalance = builder.stakedBalances(address(this), 1);
        assertEq(stakedBalance, 1);

        // Validate Staking Records
        (uint256 amountStaked, uint256 stakeTimestamp) = builder.stakingRecords(address(this), 1, 0);
        assertEq(amountStaked, 1);
        assertEq(stakeTimestamp, block.timestamp);

        builder.unstakeERC1155(address(testToken), 1, 1);

    }

    function test_Unstake1() public {
        testToken.setApprovalForAll(address(builder), true);
        builder.stakeERC1155(address(testToken), 1, 1);

        // Validate Staked Balance
        uint256 stakedBalance = builder.stakedBalances(address(this), 1);
        assertEq(stakedBalance, 1);

        // Validate Staking Records
        (uint256 amountStaked, uint256 stakeTimestamp) = builder.stakingRecords(address(this), 1, 0);
        assertEq(amountStaked, 1);
        assertEq(stakeTimestamp, block.timestamp);

        skip(31 days); // Skips 31 days to ensure sufficient time is met to avoid revert

        builder.unstakeERC1155(address(testToken), 1, 1);

        // Validate Staked Balance
        uint256 stakedBalance2 = builder.stakedBalances(address(this), 1);
        assertEq(stakedBalance2, 0);

        // Validate Staking Records
        (uint256 amountStaked2, uint256 stakeTimestamp2) = builder.stakingRecords(address(this), 1, 0);
        assertEq(amountStaked2, 0);
        assertEq(stakeTimestamp2, 1); // Note Timestamp is not removed

    }

    function test_Stake5() public {
        testToken.setApprovalForAll(address(builder), true);
        builder.stakeERC1155(address(testToken), 2, 5);

        // Validate Staked Balance
        uint256 stakedBalance = builder.stakedBalances(address(this), 2);
        assertEq(stakedBalance, 5);

        // // Validate Staking Records
        (uint256 amountStaked, uint256 stakeTimestamp) = builder.stakingRecords(address(this), 2, 0);
        assertEq(amountStaked, 5);
        assertEq(stakeTimestamp, block.timestamp);
    }


}
