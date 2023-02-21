// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.12;

// Uncomment this line to use console.log
// import "hardhat/console.sol";
import "@solvprotocol/erc-3525/ERC3525.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract MyERC3525 is ERC3525, Ownable {
    constructor(
        bool isWhitelisted_,
        bool isLock_,
        bool isCap_
    ) ERC3525("MyERC3525", "MY3525", 18) {
        rights.isWhitelisted = isWhitelisted_;
        rights.isLock = isLock_;
        rights.isCap = isCap_;
    }

    struct Rights {
        bool isWhitelisted;
        bool isLock;
        bool isCap;
    }

    struct ProjectInfo {
        uint hasRecivedAmount;
        uint waittingReciviedCap;
    }

    struct WithdrewHistory {
        uint amount;
        address handler;
        address receiver;
        uint time;
    }

    Rights public rights;
    ProjectInfo public projectInfo;
    WithdrewHistory[] public withdrewHistory;

    mapping(address => uint) public investorAmount;
    mapping(address => uint) public whiteCanInverstAmout;

    function setWhiteCanInverstAmouts(
        address[] memory investors,
        uint[] memory amounts
    ) external onlyOwner {
        require(investors.length == amounts.length, "Err_Length_Not_Equal");
        for (uint i = 0; i < investors.length; i++) {
            whiteCanInverstAmout[investors[i]] = amounts[i];
        }
    }

    function setProjectInvestCap(uint amount) external onlyOwner {
        projectInfo.waittingReciviedCap = amount;
    }

    function mint() external payable {
        uint value = msg.value;

        require(value != 0, "Err_Invalid_Invest_Amount");
        require(rights.isLock == false, "Err_Project_Locked");

        _mint(msg.sender, 1, value);

        investorAmount[msg.sender] += value;

        if (rights.isWhitelisted) whiteCanInverstAmout[msg.sender] -= value;
        if (rights.isCap)
            require(
                (value += projectInfo.hasRecivedAmount) <=
                    projectInfo.waittingReciviedCap,
                "Err_Project_Overflow_Cap"
            );
    }

    function setRigthsIsLock(bool isLock_) external onlyOwner {
        rights.isLock = isLock_;
    }

    receive() external payable {
        projectInfo.hasRecivedAmount += msg.value;
    }

    function withdraw(
        address receiver,
        uint amount
    ) external payable onlyOwner {
        (bool success, ) = payable(receiver).call{value: amount}("");

        withdrewHistory.push(
            WithdrewHistory({
                amount: amount,
                handler: msg.sender,
                receiver: receiver,
                time: block.timestamp
            })
        );

        require(success);
    }
}
