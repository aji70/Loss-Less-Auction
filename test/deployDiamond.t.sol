// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";

import "../contracts/facets/AUCFacet.sol";
import "../contracts/facets/AuctionHouseFacet.sol";
import "forge-std/Test.sol";
import "../contracts/Diamond.sol";

import "../contracts/MyToken.sol";
import "../contracts/MyERC1155.sol";

import "../contracts/libraries/LibAppStorage.sol";

contract DiamondDeployer is Test, IDiamondCut {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    AUCFacet aucFacet;
    AuctionHouseFacet ahFacet;
    MyToken nft;
    MyERC1155 erc1155;
    AUCFacet au;
    AuctionHouseFacet ah;
    MyToken n;

    address A = address(0xa);
    address B = address(0xb);
    address RD = address(0xc);
    address TM = address(0xd);
    address LAU = address(0xe);
    address C = address(0xf);

    AuctionHouseFacet boundAuction;
    AUCFacet boundingAUC;

    function setUp() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        aucFacet = new AUCFacet();
        ahFacet = new AuctionHouseFacet();
        nft = new MyToken();
        erc1155 = new MyERC1155();

        // wow = new WOWToken(address(diamond));

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](4);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );
        cut[2] = (
            FacetCut({
                facetAddress: address(aucFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("AUCFacet")
            })
        );

        cut[3] = (
            FacetCut({
                facetAddress: address(ahFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("AuctionHouseFacet")
            })
        );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");
        A = mkaddr("staker a");
        B = mkaddr("staker b");
        C = mkaddr("auction c");

        // //mint test tokens
        AUCFacet(address(diamond)).mintTo(A);
        AUCFacet(address(diamond)).mintTo(B);
        AUCFacet(address(diamond)).mintTo(B);
        AUCFacet(address(diamond)).mintTo(C);

        // boundAuction = AuctionHouseFacet(address(diamond));
        // boundingAUC = AUCFacet(address(diamond));
    }

    function testAuction() public {
        au = new AUCFacet();
        ah = new AuctionHouseFacet();
        n = new MyToken();
        boundAuction = AuctionHouseFacet(address(diamond));
        boundingAUC = AUCFacet(address(diamond));
        switchSigner(A);
        nft.safeMint();
        nft.balanceOf(A);
        aucFacet.balanceOf(A);
        // aucFacet.mintTo(address(diamond));
        aucFacet.balanceOf(address(diamond));
        // aucFacet.balanceOf(address(this));
        // 0x2e234DAe75C793f67A35089C9d99245E1C58470b
        boundAuction.create721Auction(
            1,
            50_000_000e18,
            10000,
            block.timestamp,
            address(nft)
        );
        // switchSigner(B);
        // nft.safeMint();
        // boundAuction.create721Auction(
        //     1,
        //     50_000_000e18,
        //     1000000000,
        //     block.timestamp,
        //     address(nft)
        // );
        boundingAUC.approve(address(this), 60_000_000e18);

        boundAuction.bid(A, 1, 80_000_000e18, RD, LAU);
        uint256 bal = boundingAUC.balanceOf(address(diamond));
        console.log(bal, "A balance");
        switchSigner(B);
        // boundingAUC.approve(address(this), 50_000_000e18);

        // boundAuction.bid(B, 1, 50_000_000e18, RD, LAU);
        // uint256 balB = boundingAUC.balanceOf(address(diamond));
        // console.log(balB, "B balance");
        // switchSigner(C);
        boundingAUC.approve(address(this), 60_000_000e18);

        boundAuction.bid(B, 1, 90_000_000e18, RD, LAU);

        switchSigner(C);
        // boundingAUC.approve(address(this), 50_000_000e18);

        // boundAuction.bid(B, 1, 50_000_000e18, RD, LAU);
        // uint256 balB = boundingAUC.balanceOf(address(diamond));
        // console.log(balB, "B balance");
        // switchSigner(C);
        boundingAUC.approve(address(this), 60_000_000e18);

        boundAuction.bid(C, 1, 10_000_000e18, RD, LAU);

        boundAuction.getParticularAuction(1);
    }

    function generateSelectors(
        string memory _facetName
    ) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function mkaddr(string memory name) public returns (address) {
        address addr = address(
            uint160(uint256(keccak256(abi.encodePacked(name))))
        );
        vm.label(addr, name);
        return addr;
    }

    function switchSigner(address _newSigner) public {
        address foundrySigner = 0x1804c8AB1F12E6bbf3894d4083f33e07309d1f38;
        if (msg.sender == foundrySigner) {
            vm.startPrank(_newSigner);
        } else {
            vm.stopPrank();
            vm.startPrank(_newSigner);
        }
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}
}
