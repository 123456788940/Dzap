

pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockERC20 is ERC20 {
    constructor() ERC20("MockERC20", "M20") {}
        function mint(address to, uint tokenId) external {
            _mint(to, tokenId);
        }
    
}

