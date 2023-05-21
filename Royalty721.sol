// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFT is ERC721Enumerable, Ownable {
  using Strings for uint256;

  string public baseURI;
  string public baseExtension = ".json";
  string public contractURI;
  uint256 public maxSupply;
  struct RoyaltyInfo {
        address[] receiver;
        uint96[] share;
    }
  RoyaltyInfo private _defaultRoyaltyInfo;
  constructor(
    string memory _name,
    string memory _symbol,
    string memory _initBaseURI,
    uint256 _maxSupply
  ) ERC721(_name, _symbol) {
    setBaseURI(_initBaseURI);
    maxSupply = _maxSupply;
  }

  // internal
  function _baseURI() internal view virtual override returns (string memory) {
    return baseURI;
  }

  // public
  function mint(uint256 _mintAmount) public onlyOwner {

    uint256 supply = totalSupply();
    require(_mintAmount > 0, "need to mint at least 1 NFT");
    require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");

    for (uint256 i = 1; i <= _mintAmount; i++) {
      _safeMint(msg.sender, supply + i);
    }
  }
  
  function walletOfOwner(address _owner)
    public
    view
    returns (uint256[] memory)
  {
    uint256 ownerTokenCount = balanceOf(_owner);
    uint256[] memory tokenIds = new uint256[](ownerTokenCount);
    for (uint256 i; i < ownerTokenCount; i++) {
      tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
    }
    return tokenIds;
  }

  function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override
    returns (string memory)
  {
    require(
      _exists(tokenId),
      "ERC721Metadata: URI query for nonexistent token"
    );
    
    string memory currentBaseURI = _baseURI();
    return bytes(currentBaseURI).length > 0
        ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
        : "";
  }

  function setBaseURI(string memory _newBaseURI) public onlyOwner {
    baseURI = _newBaseURI;
  }

  function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
    baseExtension = _newBaseExtension;
  }
  
  // Function lets other marketplace know this contract support Royalties
  function supportsInterface(bytes4 interfaceId) public view override(ERC721Enumerable)
        returns (bool)
    {
        return interfaceId == 0x2a55205a || super.supportsInterface(interfaceId);
    }
   
    // Function Set default Royality For the Whole Collection max fee limit is set to 10%
    // Verify’s  users enter valid account and share info.
    // only dev can call this function
    function setDefaultRoyalty(address[] memory receiver, uint96[] memory share)
        public
        onlyOwner
    {
        require(verifyReceiver(receiver) == false,"Receiver Address is Invalid");
        require(verifyShare(share) <= 1000,"Total Share Value should be less then or equal to 1000 bips max limit is 10%");
        require(receiver.length == share.length,"Invalid info Receiver and share length not equal");
        _defaultRoyaltyInfo = RoyaltyInfo(receiver, share);
    }
        //internal funcations verifying using entered valid account info
    function verifyReceiver(address[] memory _receiver)
        internal
        pure
        returns (bool checked)
    {
        for (uint96 i = 0; i < _receiver.length; i + 1) {
            if (_receiver[i] != address(0)) {
                return false;
            }
        }
        return false;
    }
    //internal funcations verifying using entered valid share value of 100%
    function verifyShare(uint96[] memory _share)
        internal
        pure
        returns (uint96 share)
    {
        uint96 res = 0;
        for (uint96 i = 0; i < _share.length; i++) {
            res += _share[i];
        }
        return res;
    }

    // Function Sets Contract Metadata for Collection Store Front.
    function setContractURI(string calldata _contractURI) public onlyOwner {
        contractURI = _contractURI;
    }
}
