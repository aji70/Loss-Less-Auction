// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {LibAppStorage} from "../libraries/LibAppStorage.sol";

contract AuctionHouseFacet {
    LibAppStorage.Layout internal l;
    event BidSubmitted(uint256 bidAmount);
    event AuctionCreated(
        uint256 auctionId,
        address indexed seller,
        uint256 indexed tokenId,
        uint256 reservePrice,
        uint256 duration
    );

    // function bid(uint auctionID, uint _bidAmount) public {
    //     LibAppStorage.Auction storage auctionedItem = l.auctions[auctionID];
    //     uint userbal = l.balances[msg.sender];
    //     l.lastBid = _bidAmount;
    //     // uint previousBidder = l.balances[l.highestBidder];
    //     require(_bidAmount > 0, "Bid amount must be greater than zero.");
    //     require(auctionedItem.reservePrice >= _bidAmount, "The bid is too low");
    //     require(
    //         auctionedItem.lastBidder != msg.sender,
    //         "You cannot outbid yourself"
    //     );
    //     require(userbal > _bidAmount, "Not enough  funds");
    //     require(
    //         _bidAmount > auctionedItem.lastbid,
    //         "Bid less than highest bid"
    //     );
    //     uint totalFee = (10 * _bidAmount) / 100;
    //     uint totalbidFee = (90 * _bidAmount) / 100;
    //     uint256 randDoa = (20 * totalFee) / 100;
    //     uint256 lastAUCUser = (10 * totalFee) / 100;
    //     uint highestBidderCompensation = (30 * totalFee) / 100;
    //     uint teamProfit = (20 * totalFee) / 100;
    //     uint burnAmount = (20 * totalFee) / 100;
    //     uint tot = totalbidFee + highestBidderCompensation;

    //     if (auctionedItem.currentHighestBider != address(0)) {
    //         if (auctionedItem.tokenType == 1) {
    //             LibAppStorage._transferFrom(
    //                 msg.sender,
    //                 address(this),
    //                 totalbidFee
    //             );
    //         } else if (auctionedItem.tokenType == 2) {
    //             IERC1155(auctionedItem.tokenContract).safeTransferFrom(
    //                 msg.sender,
    //                 address(this),
    //                 auctionedItem.tokenId,
    //                 auctionedItem.reservePrice,
    //                 ""
    //             );
    //         }
    //         LibAppStorage._transferFrom(msg.sender, l.randomDOA, randDoa);
    //         LibAppStorage._transferFrom(
    //             msg.sender,
    //             l.highestBidder,
    //             highestBidderCompensation
    //         );
    //         LibAppStorage._transferFrom(msg.sender, l.teamAddress, teamProfit);
    //         LibAppStorage._transferFrom(msg.sender, l.lastAUCUser, lastAUCUser);
    //         LibAppStorage.burn(burnAmount);
    //         emit BidSubmitted(_bidAmount);
    //     } else {
    //         LibAppStorage._transferFrom(msg.sender, l.randomDOA, randDoa);
    //         LibAppStorage._transferFrom(
    //             msg.sender,
    //             l.highestBidder,
    //             highestBidderCompensation
    //         );
    //         LibAppStorage._transferFrom(msg.sender, l.teamAddress, teamProfit);
    //         LibAppStorage._transferFrom(msg.sender, l.lastAUCUser, lastAUCUser);
    //         LibAppStorage.burn(burnAmount);

    //         LibAppStorage._transferFrom(msg.sender, address(this), tot);
    //         emit BidSubmitted(_bidAmount);
    //     }
    //     l.highestBidder = msg.sender;
    //     l.lastBid = _bidAmount;
    // }
    // function bid(uint auctionID, uint _bidAmount) public {
    //     LibAppStorage.Auction storage auctionedItem = l.auctions[auctionID];
    //     uint userbal = l.balances[msg.sender];
    //     l.lastBid = _bidAmount;

    //     require(_bidAmount > 0, "Bid amount must be greater than zero.");
    //     require(auctionedItem.reservePrice >= _bidAmount, "The bid is too low");
    //     require(
    //         auctionedItem.lastBidder != msg.sender,
    //         "You cannot outbid yourself"
    //     );
    //     require(userbal > _bidAmount, "Not enough funds");
    //     require(
    //         _bidAmount > auctionedItem.lastbid,
    //         "Bid less than highest bid"
    //     );
    //     require(
    //         block.timestamp > auctionedItem.endedTime || auctionedItem.ended,
    //         "Auction Ended"
    //     );

    //     uint totalFee = (10 * _bidAmount) / 100;
    //     uint totalbidFee = (90 * _bidAmount) / 100;
    //     uint256 randDoa = (10 * totalFee) / 100;
    //     uint256 lastAUCUser = (10 * totalFee) / 100;
    //     uint highestBidderCompensation = (30 * totalFee) / 100;
    //     uint teamProfit = (20 * totalFee) / 100;
    //     uint burnAmount = (20 * totalFee) / 100;
    //     // uint tot = totalbidFee + highestBidderCompensation;

    //     // Transfer tokens and handle fees

    //     if (block.timestamp > auctionedItem.endedTime || auctionedItem.ended) {
    //         handleTokenTransfers(
    //             auctionedItem,
    //             totalbidFee,
    //             randDoa,
    //             highestBidderCompensation,
    //             teamProfit,
    //             lastAUCUser,
    //             burnAmount
    //         );
    //     }
    //     emit BidSubmitted(_bidAmount);

    //     l.highestBidder = msg.sender;
    //     l.lastBid = _bidAmount;
    // }

    // function handleTokenTransfers(
    //     LibAppStorage.Auction storage auctionedItem,
    //     uint totalbidFee,
    //     uint256 randDoa,
    //     uint highestBidderCompensation,
    //     uint teamProfit,
    //     uint256 lastAUCUser,
    //     uint burnAmount
    // ) internal {
    //     if (auctionedItem.currentHighestBider != address(0)) {
    //         if (auctionedItem.tokenType == 1) {
    //             LibAppStorage._transferFrom(
    //                 msg.sender,
    //                 address(this),
    //                 totalbidFee
    //             );
    //         } else if (auctionedItem.tokenType == 2) {
    //             IERC1155(auctionedItem.tokenContract).safeTransferFrom(
    //                 msg.sender,
    //                 address(this),
    //                 auctionedItem.tokenId,
    //                 auctionedItem.reservePrice,
    //                 ""
    //             );
    //         } else {
    //             revert();
    //         }
    //         LibAppStorage._transferFrom(msg.sender, l.randomDOA, randDoa);
    //         LibAppStorage._transferFrom(
    //             msg.sender,
    //             l.highestBidder,
    //             highestBidderCompensation
    //         );
    //     }
    //     LibAppStorage._transferFrom(msg.sender, l.teamAddress, teamProfit);
    //     LibAppStorage._transferFrom(msg.sender, l.lastAUCUser, lastAUCUser);
    //     LibAppStorage.burn(burnAmount);
    // }

    function create721Auction(
        uint256 tokenId,
        uint256 reservePrice,
        uint256 duration,
        uint256 startTime,
        address tokenAddress
    ) public {
        require(reservePrice > 0, "no free auctions");
        require(
            duration >= 1 minutes,
            "auction must be at least one minute long"
        );
        require(
            IERC721(tokenAddress).ownerOf(tokenId) == msg.sender,
            "Not your token"
        );
        if (l.auctionId == 0) {
            l.auctionId = 1;
        } else {
            l.auctionId = l.auctionId;
        }
        LibAppStorage._transferFrom(msg.sender, address(this), tokenId);
        LibAppStorage.Auction memory al_;
        al_.seller = msg.sender;
        al_.tokenId = tokenId;
        al_.tokenContract = tokenAddress;
        al_.startTime = startTime;
        al_.duration = duration;
        al_.reservePrice = reservePrice;
        al_.currentHighestBid = 0;
        al_.currentHighestBider = address(0);
        al_.lastBidder = address(0);
        al_.lastbid = 0;
        al_.started = (block.timestamp >= startTime);
        al_.ended = false;
        al_.endedTime = startTime + duration;
        al_.auctionCreator = msg.sender;
        al_.endedTime = startTime + duration;
        al_.tokenType = 1;
        l.auctions[l.auctionId] = al_;
        l.auctionarray.push(al_);
        emit AuctionCreated(
            l.auctionId,
            msg.sender,
            tokenId,
            reservePrice,
            duration
        );
        l.auctionId++;
    }

    function create1155Auction(
        uint256 tokenId,
        uint256 amounts,
        uint256 reservePrice,
        uint256 duration,
        uint256 startTime,
        address tokenAddress
    ) public {
        require(reservePrice > 0, "Reserve price must be greater than 0");
        require(
            duration >= 1 minutes,
            "Auction must be at least one minute long"
        );
        require(
            IERC1155(tokenAddress).balanceOf(msg.sender, tokenId) >= amounts,
            "Not enough tokens"
        );

        if (l.auctionId == 0) {
            l.auctionId = 1;
        }

        IERC1155(tokenAddress).safeTransferFrom(
            msg.sender,
            address(this),
            tokenId,
            amounts,
            ""
        );

        LibAppStorage.Auction memory al_;

        al_.seller = msg.sender;
        al_.tokenId = tokenId;
        al_.tokenContract = tokenAddress;
        al_.startTime = startTime;
        al_.duration = duration;
        al_.reservePrice = reservePrice;
        al_.currentHighestBid = 0;
        al_.currentHighestBider = address(0);
        al_.lastBidder = address(0);
        al_.lastbid = 0;
        al_.started = (block.timestamp >= startTime);
        al_.ended = false;
        al_.endedTime = startTime + duration;
        al_.auctionCreator = msg.sender;
        al_.endedTime = startTime + duration;
        al_.tokenType = 2;

        l.auctions[l.auctionId] = al_;
        l.auctionarray.push(al_);

        emit AuctionCreated(
            l.auctionId,
            msg.sender,
            tokenId,
            reservePrice,
            duration
        );

        l.auctionId++;
    }

    function closeAuction(uint256 auctionId) public {
        // Get the auction from storage
        LibAppStorage.Auction storage auctionedItem = l.auctions[auctionId];
        require(
            auctionedItem.seller == msg.sender,
            "Cannot end another person's Auction"
        );

        auctionedItem.ended = true;

        if (auctionedItem.tokenType == 1) {
            LibAppStorage._transferFrom(
                address(this),
                auctionedItem.currentHighestBider,
                auctionedItem.tokenId
            );
        } else if (auctionedItem.tokenType == 2) {
            IERC1155(auctionedItem.tokenContract).safeTransferFrom(
                address(this),
                auctionedItem.currentHighestBider,
                auctionedItem.tokenId,
                auctionedItem.tokenAmount,
                ""
            );
        }
    }

    function getParticularAuction(
        uint256 auctionId
    ) public view returns (LibAppStorage.Auction memory) {
        LibAppStorage.Auction storage auctionedItem = l.auctions[auctionId];
        return (auctionedItem);
    }

    function getAllAuctions()
        public
        view
        returns (LibAppStorage.Auction[] memory)
    {
        return (l.auctionarray);
    }
}

interface IERC721 {
    event Transfer(
        address indexed from,
        address indexed to,
        uint256 indexed tokenId
    );
    event Approval(
        address indexed owner,
        address indexed approved,
        uint256 indexed tokenId
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );

    function balanceOf(address owner) external view returns (uint256 balance);

    function ownerOf(uint256 tokenId) external view returns (address owner);

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId
    ) external;

    function safeTransferFrom(
        address from,
        address to,
        uint256 tokenId,
        bytes calldata data
    ) external;

    function transferFrom(address from, address to, uint256 tokenId) external;

    function approve(address to, uint256 tokenId) external;

    function getApproved(
        uint256 tokenId
    ) external view returns (address operator);

    function setApprovalForAll(address operator, bool approved) external;

    function isApprovedForAll(
        address owner,
        address operator
    ) external view returns (bool);

    function supportsInterface(bytes4 interfaceId) external view returns (bool);
}

interface IERC1155 {
    event TransferSingle(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256 _id,
        uint256 _value
    );
    event TransferBatch(
        address indexed _operator,
        address indexed _from,
        address indexed _to,
        uint256[] _ids,
        uint256[] _values
    );
    event ApprovalForAll(
        address indexed _owner,
        address indexed _operator,
        bool _approved
    );
    event URI(string _uri, uint256 indexed _id);

    function balanceOf(
        address _owner,
        uint256 _id
    ) external view returns (uint256);

    function balanceOfBatch(
        address[] calldata _owners,
        uint256[] calldata _ids
    ) external view returns (uint256[] memory);

    function setApprovalForAll(address _operator, bool _approved) external;

    function isApprovedForAll(
        address _owner,
        address _operator
    ) external view returns (bool);

    function safeTransferFrom(
        address _from,
        address _to,
        uint256 _id,
        uint256 _value,
        bytes calldata _data
    ) external;

    function safeBatchTransferFrom(
        address _from,
        address _to,
        uint256[] calldata _ids,
        uint256[] calldata _values,
        bytes calldata _data
    ) external;

    function createAuction(
        uint256 _id,
        uint256 _quantity,
        uint256 _startPrice,
        uint256 _duration
    ) external;

    function bid(uint256 _id, uint256 _value) external;

    function endAuction(uint256 _id) external;

    function cancelAuction(uint256 _id) external;

    function getAuctionDetails(
        uint256 _id
    ) external view returns (address, uint256, uint256, uint256, uint256);
}
