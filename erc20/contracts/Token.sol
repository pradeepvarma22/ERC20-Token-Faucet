//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";


contract VarmaToken is ERC20{

    constructor() ERC20("Varma's Token","VARMA")
    {
        _mint(msg.sender, 100);        
    }
}


contract VarmaTokenFaucet is ERC20{
    event FaucetRequest(address indexed caller, uint256 tokenAmount);
    address public owner;
    uint256 constant public waitTime = 60 minutes;
    mapping(address => uint256) lastAccessTime;
    uint256 public tokenAmount;

    constructor() ERC20("Varma's Token","VARMA"){
        tokenAmount=5;
        owner=msg.sender;
    }

    function faucetRequestTokens() external returns(bool){
        require(allowedToWithdraw(msg.sender));
        _mint(msg.sender, tokenAmount);
        emit FaucetRequest(msg.sender, tokenAmount);
        lastAccessTime[msg.sender] = 5 minutes;
        return true;
    }

    function allowedToWithdraw(address _to) internal view returns(bool)
    {
        if(block.timestamp >= lastAccessTime[_to] || lastAccessTime[_to] ==0 )
        {
            return true;
        }
        return false;
    }

    function setTokenAmount(uint256 value) public onlyOwner{
        tokenAmount = value;
    }

    function getTokenAmount() public view returns(uint256){
        return tokenAmount;
    }

    modifier onlyOwner()
    {
        require(msg.sender==owner);
        _;
    }

}