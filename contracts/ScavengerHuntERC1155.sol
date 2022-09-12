// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.0;

import "@thirdweb-dev/contracts/base/ERC1155LazyMint.sol";

contract ScavengerHuntERC1155 is ERC1155LazyMint {
    mapping(address => mapping(uint256 => bool)) private finders;

    constructor(
        string memory _name,
        string memory _symbol,
        address _royaltyRecipient,
        uint128 _royaltyBps
    ) ERC1155LazyMint(_name, _symbol, _royaltyRecipient, _royaltyBps) {}

    function isFinderOfTreasure(address holder) external view returns (bool) {
        return finders[holder][0];
    }

    function foundTreasure(address _claimer) external {
        require(
            balanceOf[_claimer][0] > 0,
            "Must be a holder of participant NFT to find treasure"
        );

        finders[_claimer][0] = true;
    }

    function verifyClaim(
        address _claimer,
        uint256 _tokenId,
        uint256 _quantity
    ) public view override {
        if (_tokenId == 1) {
            // must be holder of participant NFT
            require(balanceOf[_claimer][0] >= 1, "Does not own level 1 NFT");

            // must have found the treasure
            require(
                finders[_claimer][0] == true,
                "Can only claim if found treasure"
            );

            // a person can only own one of these NFTs
            require(
                balanceOf[_claimer][1] == 0,
                "already owned can't claim another"
            );
        }
    }
}
