// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract MyToken is ERC1155, ERC1155Supply, Ownable {
    using Strings for uint256;
    uint96 public totalSupply;
    string private _uri;
    string public baseExtension = ".json";
    string public name;
    string public symbol;

    constructor(
        string memory _name,
        string memory _symbol,
        string memory _URI
    ) ERC1155("") {
        name = _name;
        symbol = _symbol;
        _uri = _URI;
    }

    function mint(uint96 tokenAmount, uint96 amount) public onlyOwner {
        for (uint i; i < tokenAmount; i++) {
            _mint(msg.sender, totalSupply + i, amount, "");
        }
        totalSupply = totalSupply + tokenAmount;
    }

    function setURI(string memory newuri) public onlyOwner {
        _uri = newuri;
    }

    // The following functions are overrides required by Solidity.
    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    ) internal override(ERC1155, ERC1155Supply) {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }

    function uri(
        uint256 tokenId
    ) public view virtual override returns (string memory) {
        return
            string(abi.encodePacked(_uri, tokenId.toString(), baseExtension));
    }
}
