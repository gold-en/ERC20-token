// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract ERC20{
    //State variables
    string public name = "OKEAMA";
    string public symbol = "BUNN";
    uint256 public totalsupply;
    uint8 public decimal = 18;
    address public owner;

    mapping (address => uint256) public balanceOf;

    mapping (address => mapping(address=> uint256)) public allowance;

    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Burn(address indexed from, uint256 amount);
    
 
    constructor(){
        owner = msg.sender;
        totalsupply = 1000e18;
        balanceOf[msg.sender] = totalsupply;
    }

    function approve(address spender, uint256 amount) external returns(bool){

        require(spender != address(0), "erc20 approve to the address");

        allowance[msg.sender][spender] = amount;

        emit Approval(msg.sender, spender, amount);

        return true;
    }

   
    function transfer (address recipient, uint256 amount) external returns(bool){
     
        return _transfer(msg.sender, recipient, amount);
    }

 
    function transferFrom(address sender, address recipient, uint256 amount) external returns(bool){
        
        uint256 currentBalance = allowance[sender][msg.sender];
        require(currentBalance >= amount, "Erc20 transfer amount exceeded your allowance");

        //subtracting the amount from the allowance
        allowance[sender][msg.sender] = currentBalance - amount;

        emit Approval(sender, recipient, amount);

        return _transfer(sender, recipient, amount);
    }

    
    function _transfer (address sender, address recipient ,uint256 amount) private returns(bool){
        
        require(recipient != address(0), "Erc20 transfer to address 0");
        
        //getting the balance of the person paying for the transaction
        uint256 senderBalance = balanceOf[sender];

        require(senderBalance >= amount, "Erc20 transfer amount exceeds balance");

        balanceOf[sender] = senderBalance - amount;

        balanceOf[recipient] += amount;

        emit Transfer(sender, recipient, amount);

        return true;
    }

    function mint(uint256 amount) external {
         require (owner == msg.sender, "only the owner can call this function");

         totalsupply += amount;
         balanceOf[msg.sender] += amount;

         emit Transfer(address(0), msg.sender, amount);

    }

    function burn(uint256 amount) external {
         require (owner == msg.sender, "only the owner can call this function");
         require(amount <= balanceOf[msg.sender], "Insufficient balance");

         totalsupply -= amount;
         balanceOf[msg.sender] -= amount;

         emit Burn(msg.sender, amount);
         emit Transfer(address(0), msg.sender, amount);
    }
}