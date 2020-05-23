pragma solidity >=0.4.21 <0.7.0;

contract ERC20Sample {
string public  name;
string public symbol;
uint8 public decimals;
address contractOwner;
mapping(address => uint256) balances;
mapping(address => mapping (address => uint256)) allowed;

event Approval(address indexed tokenOwner, address indexed spender,
 uint tokens);
event Transfer(address indexed from, address indexed to,
 uint tokens);


uint256 totalSupply_;
constructor(uint256 total) public {
   totalSupply_ = total;
   contractOwner = msg.sender;
   balances[msg.sender] = totalSupply_;
}
modifier checkowner {
 require(msg.sender != contractOwner, "onl contract owner ca call this");
 _;
}

function totalSupply() public view returns (uint256) {
  return totalSupply_;
}

function balanceOf(address tokenOwner) public view returns (uint) {
  return balances[tokenOwner];
}

function transfer(address payable receiver,uint numTokens)  payable public returns(bool) {
  require(numTokens <= balances[msg.sender]);
  balances[msg.sender]-= numTokens;
  balances[receiver] += numTokens;
  emit Transfer(msg.sender, receiver, numTokens);
  return true;
}

function approve(address payable delegate,uint numTokens) public returns (bool) {
    require(numTokens <= balances[contractOwner],"the number of tokens seeked should be less than balance in the owner account");
  allowed[msg.sender][delegate] = numTokens;
  emit Approval(msg.sender, delegate, numTokens);
  return true;
}

function allowance(address owner,address delegate) public view returns (uint) {
  return allowed[owner][delegate];
}

function transferFrom(address owner, address buyer,
                     uint numTokens) public payable returns (bool) {
  require(numTokens <= balances[owner],"checking the delgated address balance");
  require(numTokens <= allowed[owner][msg.sender],"checking the the limit of the deligated address");
  balances[owner] -= numTokens;
  allowed[owner][msg.sender] -= numTokens;
  balances[buyer] += numTokens;
 emit Transfer(owner, buyer, numTokens);
  return true;
}
}