pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

import 'hardhat/console.sol';
import './ExampleExternalContract.sol';

contract Staker {
  ExampleExternalContract public exampleExternalContract;

  uint256 public deadline;
  uint256 public constant threshold = 1 ether;
  mapping(address => uint256) public balances;

  constructor(address exampleExternalContractAddress) public {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
    deadline = block.timestamp + 600;
  }

  // TODO: Collect funds in a payable `stake()` function and track individual `balances` with a mapping:
  //  ( make sure to add a `Stake(address,uint256)` event and emit it for the frontend <List/> display )

  // TODO: After some `deadline` allow anyone to call an `execute()` function
  //  It should call `exampleExternalContract.complete{value: address(this).balance}()` to send all the value

  // TODO: if the `threshold` was not met, allow everyone to call a `withdraw()` function

  // TODO: Add a `timeLeft()` view function that returns the time left before the deadline for the frontend

  // TODO: Add the `receive()` special function that receives eth and calls stake()

  event Stake(address staker, uint256 value);

  function stake() public payable {
    balances[msg.sender] += msg.value;
    emit Stake(msg.sender, msg.value);
  }

  function execute() external {
    require(address(this).balance >= threshold, 'Insufficient Stake');
    exampleExternalContract.complete{value: address(this).balance}();
  }

  function withdraw() external {
    (bool sent, ) = msg.sender.call{value: balances[msg.sender]}('');
    require(sent, 'Withdraw failed');
  }

  function timeleft() public view {
    return block.timestamp < deadline ? deadline - block.timestamp : 0;
  }
}
