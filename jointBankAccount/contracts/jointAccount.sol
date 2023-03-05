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

    modifier accountOwner(uint accountId){
        bool isOwner;
        for(uint idx; idx < accounts[accountId].owners.length; idx++){
            if(accounts[accountId].owners[idx] == msg.sender){
                isOwner = true;
                break;
            }
        }
        require(isOwner, "you are not an owner of this account");
        _;
    }

    function deposit(uint accountId) external payable accountOwner(accountId) {
        accounts[accountId].balance += msg.value;

    }

    function createAccount(address[] calldata otherOwners) external {
        address[] memory owners = new address[](otherOwners.length + 1);
        owners[otherOwners.length] = msg.sender;

        uint id = nextAccountId;

        for(uint idx; idx < owners.length; idx++){
            if(idx < owners.length - 1){
                owners[idx] = otherOwners[idx];
            }
            if(userAccounts[owners[idx]].length > 2){
                revert("each user can have a max of 3 accounts");
            }
            userAccounts[owners[idx]].push(id);
        }

        accounts[id].owners = owners;
        nextAccountId++;
        emit AccountCreated(owners, id, block.timestamp);

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
    function getAccounts() public view returns (uint[] memory) {

    }



}