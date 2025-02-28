// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import {Test, console} from "forge-std/Test.sol";
import {TizunToken} from "src/TizunToken.sol";

contract TizunTokenTest is Test {
    TizunToken public tizunToken;
    address public OWNER = address(this);
    address public constant USER = address(1);
    address public constant USER2 = address(2);
    function setUp() external {
        tizunToken = new TizunToken();
        tizunToken.mint(USER, 1000 * 10 ** 18);
        tizunToken.mint(USER, 1000 * 10 ** 18);
    }

    function test_setUp() public view {
        console.log(address(tizunToken));
    }

    function test_mint() public {
        uint256 AMOUNT_SUPPLY = 500 * 10 ** 18;
        uint256 totalSupplyBeforeMint = tizunToken.totalSupply();
        tizunToken.mint(OWNER, AMOUNT_SUPPLY);
        uint256 totalSupplyAfterMint = tizunToken.totalSupply();
        assertEq(totalSupplyBeforeMint + AMOUNT_SUPPLY, totalSupplyAfterMint);
    }

    function test_burn() public {
        tizunToken.mint(OWNER, 300 * 10 ** 18);
        uint256 AMOUNT_SUPPLY = 50 * 10 ** 18;
        uint256 totalSupplyBeforeBurn = tizunToken.totalSupply();
        tizunToken.burn(OWNER, AMOUNT_SUPPLY);
        uint256 totalSupplyAfterBurn = tizunToken.totalSupply();
        assertEq(totalSupplyBeforeBurn - AMOUNT_SUPPLY, totalSupplyAfterBurn);
    }

    function test_totalSupply() public view {
        console.log("Current total supply:", tizunToken.totalSupply());
    }

    function test_balanceOf() public view {
        console.log("Current balance of:", tizunToken.balanceOf(USER));
    }

    function test_transfer() public {
        tizunToken.mint(USER, 300 * 10 ** 18);
        uint256 AMOUNT_TOKEN = 10 * 10 ** 18;

        uint256 balanceU1BeforeTransfer = tizunToken.balanceOf(USER);
        uint256 balanceU2BeforeTransfer = tizunToken.balanceOf(USER2);
        
        vm.prank(USER);
        tizunToken.transfer(USER2, AMOUNT_TOKEN);
        uint256 balanceU1AfterTransfer = tizunToken.balanceOf(USER);
        uint256 balanceU2AfterTransfer = tizunToken.balanceOf(USER2);
        assertEq(balanceU1BeforeTransfer - AMOUNT_TOKEN, balanceU1AfterTransfer);
        assertEq(balanceU2BeforeTransfer + AMOUNT_TOKEN, balanceU2AfterTransfer);
    }

    function test_transferFrom() public {
        uint256 ALLOWED_TOKEN = 10 * 10 ** 18;
        uint256 USED_TOKEN = 5 * 10 ** 18;
        uint256 balanceU1BeforeTransferFrom = tizunToken.balanceOf(USER);
        uint256 balanceU2BeforeTransferFrom = tizunToken.balanceOf(USER2);
        vm.prank(USER);
        tizunToken.approve(USER2, ALLOWED_TOKEN);
        vm.prank(USER2);
        tizunToken.transferFrom(USER, USER2, USED_TOKEN);
        uint256 balanceU1AfterTransferFrom = tizunToken.balanceOf(USER);
        uint256 balanceU2AfterTransferFrom = tizunToken.balanceOf(USER2);

        assertEq(balanceU1BeforeTransferFrom - USED_TOKEN, balanceU1AfterTransferFrom);

        assertEq(balanceU2BeforeTransferFrom + USED_TOKEN, balanceU2AfterTransferFrom);
    }

    function test_approve() public {
        uint256 AMOUNT_TOKEN = 10 * 10 ** 18;
        vm.prank(USER);
        bool success = tizunToken.approve(USER2, AMOUNT_TOKEN);
        assertTrue(success);
    }

    function test_allowance() public {
        uint256 ALLOWED_TOKEN = 15 * 10 ** 18;
        uint256 USED_TOKEN = 3 * 10 ** 18;
        vm.prank(USER);
        tizunToken.approve(USER2, ALLOWED_TOKEN);
        vm.prank(USER2);
        tizunToken.transferFrom(USER, USER2, USED_TOKEN);
        console.log("USER2 can use : ");
        console.log(tizunToken.allowance(USER, USER2));
    }
}