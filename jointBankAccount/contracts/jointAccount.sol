//SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

contract BankAccount {
    event Deposit (address indexed user, uint256 indexed accountId, uint256 value, uint256 timestamp);
    event withdrawRequested (address indexed user, uint256 indexed accountId, uint256 indexed withdrawId, uint256 amount, uint256 timeStamp);
    event Withdraw (uint indexed withdrwaId, uint timestamp);
    event AccountCreated (address[] owners, uint indexed id, uint timpstamp);

    struct withdrawRequest {
        address users;
        uint amount;
        uint approvals;
        mapping(address => bool) ownersApproved;
        bool approved;
    }

    struct Account {
        address[] owners;
        uint balance;
        mapping(uint => withdrawRequest) withdraweRequests;
    }

    mapping(uint => Account) accounts;
    mapping(address => uint[]) userAccounts;

}