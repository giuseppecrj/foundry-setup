// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";

contract Safe {
  receive() external payable {}

  function withdraw() external {
    payable(msg.sender).transfer(address(this).balance);
  }
}

contract SafeTest is Test {
    Safe safe;

    // Needed so the test contract itself can receive ether
    // when withdrawing
    receive() external payable {}

    function setUp() public {
        safe = new Safe();
    }

    // The default amount of ether that the test contract is given is 2**96 wei
    function testWithdraw(uint96 amount) public {
        vm.assume(amount > 0.1 ether);

        payable(address(safe)).transfer(amount);

        // The balance of the contract owner
        uint256 preBalance = address(this).balance;

        safe.withdraw();

        uint256 postBalance = address(this).balance;
        assertEq(preBalance + amount, postBalance);
    }
}
