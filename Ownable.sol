//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownabale {
    address public owner;

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwnwer);

    constructor(){
        owner == msg.sender;
    }

    modifier onlyOwner(){
        require(msg.sender == owner);
        _;
    }

    function currentOwner() public view returns(address){
        return owner;
    }

    function transferOwnership(address _newOwner) public onlyOwner{
        require(_newOwner != address(0), "The new Owne address is not valid");
        owner = _newOwner;
        emit OwnershipTransferred(msg.sender, owner);
    }

    // function to leave the contract without owner , therefore disabling all the functions that requie onlyOwner
    function renounceOwnership() public virtual onlyOwner{
        owner = address(0);
    }
}