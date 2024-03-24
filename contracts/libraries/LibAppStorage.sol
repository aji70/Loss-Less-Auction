pragma solidity ^0.8.0;

library LibAppStorage {
    event Transfer(address indexed _from, address indexed _to, uint256 _value);

    struct Auction {
        address seller;
        uint256 tokenId;
        address tokenContract;
        uint256 startTime;
        uint256 duration;
        uint256 reservePrice;
        uint256 currentHighestBid;
        address currentHighestBider;
        address lastBidder;
        uint lastbid;
        bool started;
        bool ended;
        address auctionCreator;
        uint256 endedTime;
        uint tokenType;
        uint256 tokenAmount;
    }

    struct Layout {
        //AUC
        string name;
        string symbol;
        uint256 totalSupply;
        uint8 decimals;
        mapping(address => uint256) balances;
        mapping(address => mapping(address => uint256)) allowances;
        //AuctionHouse
        bool isInAuctionMode;
        uint256 auctionDuration;
        uint256 lastBid;
        address bidder;
        address highestBidder;
        address randomDOA;
        address teamAddress;
        address lastAUCUser;
        address previousBidder;
        mapping(address => uint) bids;
        uint256 auctionIdCounter;
        uint256 auctionId;
        mapping(uint256 => Auction) auctions;
        mapping(uint => address) bidders;
        Auction[] auctionarray;
    }

    struct Bidder {
        address bidderAddress;
        uint256 bidAmount;
        bool isWinner;
        bool hasWithdrawn;
        bool compensated;
    }

    function layoutStorage() internal pure returns (Layout storage l) {
        assembly {
            l.slot := 0
        }
    }

    function _transferFrom(
        address _from,
        address _to,
        uint256 _amount
    ) internal {
        Layout storage l = layoutStorage();
        uint256 frombalances = l.balances[msg.sender];
        require(
            frombalances >= _amount,
            "ERC20: Not enough tokens to transfer"
        );
        l.balances[_from] = frombalances - _amount;
        l.balances[_to] += _amount;
        emit Transfer(_from, _to, _amount);
    }

    function burn(uint256 amount) external {
        Layout storage l = layoutStorage();
        // Ensure the user has enough balance to burn
        require(l.balances[msg.sender] >= amount, "Insufficient balance");

        // Deduct the tokens from the user's balance
        l.balances[msg.sender] -= amount;

        // Update the total supply
        l.totalSupply -= uint96(amount);

        // Emit the Transfer event
        emit LibAppStorage.Transfer(msg.sender, address(0), amount);
    }
}
