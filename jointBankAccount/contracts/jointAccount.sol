//SPDX-Licence-Identifier: MIT

pragma solidity 0.8.19;

contract BankAccount {
    event Deposit (address indexed user, uint256 indexed accountId, uint256 value, uint256 timestamp);
    event withdrawRequested (address indexed user, uint256 indexed accountId, uint256 indexed withdrawId, uint256 amount, uint256 timeStamp);
    event Withdraw (uint indexed withdrawId, uint timestamp);
    event AccountCreated (address[] owners, uint indexed id, uint timpstamp);

    struct withdrawRequest {
        address user;
        uint amount;
        uint approvals;
        mapping(address => bool) ownersApproved;
        bool approved;
    }

    struct Account {
        address[] owners;
        uint balance;
        mapping(uint => withdrawRequest) withdrawRequests;
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

    modifier validOwners (address[] calldata owners) {
        require (owners.length + 1 <= 4, "maximum of 4 owners per account");
        for (uint i; i < owners.length; i++) {
            for(uint j = i + 1; j < owners.length; j++){
                if(owners[i] == owners[j]){
                    revert("no duplicate owners");
                }
            }
        }
        _;
    }

    modifier sufficientBalance(uint accountId, uint amount){
        require(accounts[accountId].balance >= amount, "insufficient balance");
        _;
    }

    modifier canApprove(uint256 accountId, uint256 withdrawId){
        require(!accounts[accountId].withdrawRequests[withdrawId].approved, "this request is already approved");
        require(accounts[accountId].withdrawRequests[withdrawId].user != msg.sender, "you cannot approve this request");
        require(accounts[accountId].withdrawRequests[withdrawId].user != address(0), "this request does not exist");
        require(!accounts[accountId].withdrawRequests[withdrawId].ownersApproved[msg.sender], "you have already approved this request");
        _;
    }

    function deposit(uint accountId) external payable accountOwner(accountId) {
        accounts[accountId].balance += msg.value;

    }

    function createAccount(address[] calldata otherOwners) external validOwners(otherOwners) {
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

    function requestWithdrawl(uint accountId, uint amount) external accountOwner(accountId) sufficientBalance(accountId, amount){
        uint256 id = nextWithdrawId;
        withdrawRequest storage request = accounts[accountId].withdrawRequests[id];
        request.user = msg.sender;
        request.amount = amount;
        nextWithdrawId++;
        emit withdrawRequested(msg.sender, accountId, id, amount, block.timestamp);

    }
    function approveWithdrawl(uint accountId, uint withdrawId) external accountOwner(accountId) canApprove(accountId, withdrawId) {
        withdrawRequest storage request = accounts[accountId].withdrawRequests[withdrawId];
        request.approvals++;
        request.ownersApproved[msg.sender] = true;

        if (request.approvals == accounts[accountId].owners.length - 1){
            request.approved = true;
        }


    }
    function withdraw(uint accountId, uint withdrawId) external {
        uint amount = accounts[accountId].withdrawRequests[withdrawId].amount;
        require (accounts[accountId].balance >= amount, "insufficient balance");

        accounts[accountId].balance -= amount;
        delete accounts[accountId].withdrawRequests[withdrawId];

        (bool sent,) = payable(msg.sender).call{value: amount}("");
        require (sent);
        
        emit Withdraw(withdrawId, block.timestamp);

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