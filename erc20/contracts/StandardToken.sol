//SPDX-License-Identifier: MIT
pragma solidity ^ 0.8.0;


interface IERC20 {
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    function totalSupply() external view returns (uint256);
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
    function allowance(address owner, address spender) external view returns (uint256);
    function approve(address spender, uint256 amount) external returns (bool);
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) external returns (bool);
}

contract StandardToken is IERC20{

    mapping(address => uint256) private _balances;

    event TransferFromEvent(address from,address spender,address to, uint256 amount);

    uint256 private _totalSupply;
    string private _name;
    string private _symbol;
    mapping(address => mapping(address=>uint256)) private _allowances;


    constructor(string memory name_, string memory symbol_)
    {
        _name = name_;
        _symbol = symbol_; 
    }

    function totalSupply() public view override returns (uint256)
    {
        return _totalSupply;
    }

    function balanceOf(address account) public view override returns (uint256)
    {
        return _balances[account];
    }

    /*
    unchechked: To save gas, as the code inside unchechked{"Some Code"} isn't verified for underflow/overflow error cases.


    */

    function transfer(address to, uint256 amount) external override returns (bool)
    {
        address from = msg.sender;
        require(to!= address(0),"transfer to the zero address");
        require(from != address(0), "transfer from the zero address");

        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "transfer amount exceeds the balance" );

        //unchecked: overflow not possible because we are checking the condition above fromBalance >= amount
        unchecked {
            _balances[from] -= amount;
            _balances[to] += amount;
        }
        emit Transfer(from, to, amount);
        return true;
    }

    function allowance(address owner, address spender) public view returns (uint256)
    {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) external returns (bool)
    {
        address owner_ = msg.sender;
        require(owner_ != address(0), "approve from the zero address");
        require(spender != address(0), "approve from the zero address");

        // require(amount <= _balances[msg.sender], "approve amount exceeds the present balance" );

        _allowances[owner_][spender] = amount;
        emit Approval(owner_, spender, amount);
        return true;
    }


    /*
        trader calls --> approve(desxaddress, amount)

        dex calls --> transferFrom(traderAddress, dexAddress, amount)

        dexAddress = dex caller 

        to may or may not be dexCaller

        //caller must be spender   to address may or may not be spender address, from address must be owner
    */
    function transferFrom(address from, address to,uint256 amount) external returns (bool)
    {
        address spender = msg.sender;

        require(to!= address(0),"transfer to the zero address");
        require(from != address(0), "transfer from the zero address");

        require(allowance(from,spender) >= amount, "amount requested is to high");
        _allowances[from][spender] -= amount;

        require(balanceOf(from) >=amount, "main owner balace is too low");
        _balances[from] -= amount;
        _balances[to] += amount;

        emit TransferFromEvent(from,spender,to, amount);
    
        return true;        
    }


}
