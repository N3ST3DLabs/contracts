// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/ERC1155.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract MyToken is ERC1155, ERC1155Supply, Ownable {
    using Strings for uint256;
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

    function mintBatch(uint256 id, uint256 amount) public onlyOwner {
        _mint(msg.sender, id, amount, "");
    }

    function mintBatch(
        uint256[] memory ids,
        uint256[] memory amounts
    ) public onlyOwner {
        _mintBatch(msg.sender, ids, amounts, "");
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
