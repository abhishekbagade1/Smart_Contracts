//SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Vault {

    IERC20 public immutable token;
    uint public totalSupply;

    mapping (address => uint) public balanceof;

    constructor(address _token){
        token = IERC20(_token);
    }

    function deposit(uint _amount) {
        uint shares;
        if(totalSupply == 0){
            shares = _amount;
        }else{
            shares = (_amount*totalSupply) / token.balanceof(address(this));
        }

        mint(msg.sender, shares);
        token.transferFrom(msg.sender, address(this), _amount);
    }

    function mint(address _to, uint shares) private{
        totalSupply += shares;
        balanceof[_to] += shares;
    }

    function burn(address _from ,uint shares) private {
        totalSupply -= shares ;
        balanceOf[_from] -= shares ;
    }

    function withdraw(uint _shares) external {
        uint amount = (_shares*token.balanceof(adddress(this)))/ totalSupply;
        burn(msg.sender, _shares);
        token.transfer(msg.sender, amount);
    }

    interface IERC20 {
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

        event Transfer(address indexed from, address indexed to, uint amount);
        event Approval(address indexed owner, address indexed spender, uint amount);
    }
}