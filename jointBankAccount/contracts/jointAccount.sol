//SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

contract BankAccount {
    event Deposit (address indexed user, uint256 indexed accountId, uint256 value, uint256 timestamp);
    event withDrawRequest (address indexed user, uint256 indexed accountId, uint256 indexed withdrawId, uint256 amount, uint256 timeStamp);

}