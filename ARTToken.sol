// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";

contract ARTToken is
Context,
AccessControlEnumerable,
ERC721Enumerable,
ERC721URIStorage
{
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    string private _internalBase64Image;

    constructor(
        string memory name,
        string memory symbol,
        string memory base64Image
    ) public ERC721(name, symbol) {
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());

        _setupRole(MINTER_ROLE, _msgSender());

        _internalBase64Image = *PLACEHOLDER*;
    }

    function burn(uint256 tokenId) public virtual {
        require(
            _isApprovedOrOwner(_msgSender(), tokenId),
            "ERC721Burnable: caller is not owner nor approved"
        );
        _burn(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
    public
    view
    virtual
    override(ERC721Enumerable, AccessControlEnumerable, ERC721)
    returns (bool)
    {
        return
        interfaceId == type(IERC721Enumerable).interfaceId ||
        super.supportsInterface(interfaceId);
    }

    function setBase64Image(string memory newBase64Image) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "ERC721: must have admin role to change Base64Image"
        );

        _internalBase64Image = newBase64Image;
    }

    function mint(address to, uint256 tokenId) public virtual {
        require(
            hasRole(MINTER_ROLE, _msgSender()),
            "ERC721: must have minter role to mint"
        );

        _mint(to, tokenId);
    }

    function tokenURI(uint256 tokenId)
    public
    view
    virtual
    override(ERC721URIStorage, ERC721)
    returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function _burn(uint256 tokenId)
    internal
    virtual
    override(ERC721, ERC721URIStorage)
    {
        super._burn(tokenId);
    }

    function _Base64Image() internal view override returns (string memory) {
        return _internalBase64Image;
    }

    function setTokenB64I(uint256 tokenId, string memory _tokenURI) public {
        require(
            hasRole(DEFAULT_ADMIN_ROLE, _msgSender()),
            "ERC721: must have admin role to set Token URIs"
        );
        super._setTokenURI(tokenId, _tokenURI);
    }
}
