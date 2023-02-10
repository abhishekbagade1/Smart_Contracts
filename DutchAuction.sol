//SPDX-License-Identifier: MIT

pragma solidity 0.8.8 ;

interface IERC721 {
    function transferFrom(address _from, address _to, uint _nftId) external;
}

contract DutchAuction {
    uint private constant DURATION = 7 days;

    IERC721 public  nft;    
    uint public  nftId;

    address payable public seller;
    uint public startingPrice;
    uint public startAt;
    uint public expiresAt;

    uint public discountRate;

    event sold(address buyer, uint price);

    constructor(uint _startingPrice, uint _discountRate, address _nft, uint _nftId){
        seller = payable(msg.sender);
        startingPrice = _startingPrice;

        startAt = block.timestamp;
        expiresAt = block.timestamp + DURATION;

        discountRate = _discountRate;
        require(_startingPrice >= _discountRate*DURATION, "starting price < min");

        nft = IERC721(_nft);
        nftId = _nftId;
    }

    function getPrice() public view returns (uint) {
        uint timeElapsed = block.timestamp - startAt;
        uint discount = discountRate * timeElapsed;
        return startingPrice - discount;
    }

    function buy() external payable {
        require(block.timestamp < expiresAt, "auction expired");

        uint price = getPrice();
        require(msg.value >= price, "ETH < price");

        nft.transferFrom(seller, msg.sender, nftId);
        uint refund = msg.value - price;
        if (refund > 0) {
            payable(msg.sender).transfer(refund);
        }
        emit sold(msg.sender, msg.value);

        selfdestruct(seller);
    }
}
