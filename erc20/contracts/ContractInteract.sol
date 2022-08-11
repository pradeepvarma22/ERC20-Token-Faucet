//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract InteractWithOtherContract
{
    mapping(bytes32 => address) public whitelistedtokens;  //key: symbol address: tokenAddress

    mapping(address => mapping(bytes32 => uint256)) public accountBalances;    // user ==> tokenName ==> tokenbalances
    address owner;

    constructor()
    {
        owner = msg.sender;
    }

    function whiteListToken(bytes32 _symbol, address _tokenAddress) external{
        require(owner==msg.sender, "This Function is Not public");
        whitelistedtokens[_symbol]=_tokenAddress;
    }
    
    function depositTokenToThisContract(uint256 _amount,bytes32 _symbol) external {
        
        accountBalances[msg.sender][_symbol] +=_amount;
        IERC20(whitelistedtokens[_symbol]).transferFrom(msg.sender,address(this),_amount);

    }

    function withdraw(uint256 _amount, bytes32 _symbol) external{

        require(accountBalances[msg.sender][_symbol] < _amount, "balance is low");
        accountBalances[msg.sender][_symbol] -= _amount;
        IERC20(whitelistedtokens[_symbol]).transfer(msg.sender,_amount);
    }

}