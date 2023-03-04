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

    uint nextAccountId;
    uint nextWithdrawId;

    function deposit(uint accountId) external payable {

    }

    function createAccount(address[] calldata otherOwners) external {

    }

    function requestWithdrawl(uint accountId, uint amount) external {

    }
    function approveWithdrawl(uint accountId, uint withdrawId) external {

    }
    function withdraw(uint accountId, uint withdrawId) external {

    }
    function getBalance(uint accountId) public view returns (uint) {

    }
    function getOwners(uint accountId) public view returns (address[] memory) {

    }
    function getApprovals(uint accountId, uint withdrawId) public view returns (uint) {

    }
    function getAccounts() public view returns (uint[]) {
        
    }



}