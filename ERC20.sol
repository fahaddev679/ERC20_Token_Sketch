// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

// https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v3.0.0/contracts/token/ERC20/IERC20.sol
interface ERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(address owner, address spender) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

contract Token is ERC20{
    string public name = "Block";
    string public symbol = "BLK";
    address public founder;
    uint public decimal = 0;
    uint public override totalSupply;

    mapping(address => uint) public balances;//store balances of addresses
    mapping(address => mapping(address => uint)) allowed;

    constructor(){
        totalSupply = 500000;
        founder = msg.sender;
        balances[founder] = totalSupply;
    }

   function balanceOf(address account) external view returns (uint){
         return balances[account];
    }

   function transfer(address recipient, uint amount) external returns (bool){
        require(balances[msg.sender]>amount, "insufficient tokens");
        balances[recipient] += amount;
        balances[msg.sender] -= amount;
        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function allowance(address owner, address spender) external view override returns (uint){
        return allowed[owner][spender];
    }

    function approve(address spender, uint amount) external override returns (bool){
        require(balances[msg.sender] >= amount, "insufficient balance");
        require(amount > 0, "invalid amount");
        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

     function transferFrom(address sender,address recipient,uint amount) external returns (bool){
         require(allowed[sender][recipient] >= amount, "invalid amount");
         require(balances[sender] >= amount, "insufficient balance");
         balances[sender] -= amount;
         balances[recipient] += amount;
         return true;
    }
}
