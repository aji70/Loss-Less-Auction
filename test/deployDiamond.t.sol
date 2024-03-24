// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";

import "../contracts/facets/AUCFacet.sol";
import "../contracts/facets/AuctionHouseFacet.sol";

import "../contracts/MyToken.sol";
import "../contracts/MyERC1155.sol";
import "forge-std/Test.sol";
import "../contracts/Diamond.sol";

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

    address A = address(0xa);
    address B = address(0xb);

    AuctionHouseFacet boundAuction;

    function setUp() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        aucFacet = new AUCFacet();
        ahFacet = new AuctionHouseFacet();
        nft = new MyToken(address(diamond));
        erc1155 = new MyERC1155(address(diamond));

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

        //set rewardToken
        // diamond.setRewardToken(address(nft));
        // diamond.setRewardToken(address(erc1155));

        A = mkaddr("staker a");
        B = mkaddr("staker b");

        //mint test tokens
        AUCFacet(address(diamond)).mintTo(A);
        AUCFacet(address(diamond)).mintTo(B);
        MyToken(address(diamond)).safeMint(A);

        boundAuction = AuctionHouseFacet(address(diamond));
    }

    function testStaking() public {
        switchSigner(A);
        // boundAuction.create721Auction(
        //     1,
        //     50_000_000e18,
        //     60,
        //     block.timestamp,
        //     address(nft)
        // );

        boundAuction.getAllAuctions();

        // vm.warp(3154e7);
        // boundAuction.checkRewards(A);
        // switchSigner(B);

        // vm.expectRevert(
        //     abi.encodeWithSelector(StakingFacet.NoMoney.selector, 0)
        // );
        // boundAuction.getAllAuctions();

        // bytes32 value = vm.load(
        //     address(diamond),
        //     bytes32(abi.encodePacked(uint256(2)))
        // );
        // uint256 decodevalue = abi.decode(abi.encodePacked(value), (uint256));
        // console.log(decodevalue);
    }

    //     function testLowBalance() public {
    //         switchSigner(A);
    //         boundStaking.stake(50_000_000e19);

    //         vm.warp(3154e7);
    //         boundStaking.checkRewards(A);
    //         switchSigner(A);

    //         vm.expectRevert();
    //         // abi.encodeWithSelector(StakingFacet.NotEnough.selector, 0)
    //         // 'Not Enough'
    //         boundStaking.unstake(5);

    //         bytes32 value = vm.load(
    //             address(diamond),
    //             bytes32(abi.encodePacked(uint256(2)))
    //         );
    //         uint256 decodevalue = abi.decode(abi.encodePacked(value), (uint256));
    //         console.log(decodevalue);
    //     }

    //     function testEarlyCall() public {
    //         switchSigner(A);
    //         boundStaking.stake(50_000_000e18);

    //         vm.warp(2154e7);
    //         boundStaking.checkRewards(A);
    //         switchSigner(A);

    //         vm.expectRevert();
    //         // abi.encodeWithSelector(StakingFacet.NotEnough.selector, 0)
    //         // 'Not Enough'
    //         boundStaking.unstake(5);

    //         bytes32 value = vm.load(
    //             address(diamond),
    //             bytes32(abi.encodePacked(uint256(2)))
    //         );
    //         uint256 decodevalue = abi.decode(abi.encodePacked(value), (uint256));
    //         console.log(decodevalue);
    //     }

    //     // function testLayoutfacet() public {
    //     //     LayoutChangerFacet l = LayoutChangerFacet(address(diamond));
    //     //     // l.getLayout();
    //     //     l.ChangeNameAndNo(777, "one guy");

    //     //     //check outputs
    //     //     LibAppStorage.Layout memory la = l.getLayout();

    //     //     assertEq(la.name, "one guy");
    //     //     assertEq(la.currentNo, 777);
    //     // }

    //     // function testLayoutfacet2() public {
    //     //     LayoutChangerFacet l = LayoutChangerFacet(address(diamond));
    //     //     //check outputs
    //     //     LibAppStorage.Layout memory la = l.getLayout();

    //     //     assertEq(la.name, "one guy");
    //     //     assertEq(la.currentNo, 777);
    //     // }

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
