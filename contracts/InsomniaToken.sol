// contracts/InsomniaToken.sol
// SPDX-License-Identifier: MIT

pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";

contract InsomniaToken is ERC20Capped, ERC20Burnable {
    address payable public owner;
    uint256 public blockReward;

    constructor(uint256 cap, uint256 reward) ERC20("InsomniaToken", "INT") ERC20Capped(cap * (10 ** super.decimals())){
        owner = payable(msg.sender);
        _mint(owner, 70_000_000 * (10 ** super.decimals()));
        blockReward = reward * (10 ** super.decimals());
    }

     function _update(address from, address to, uint256 value) internal virtual override(ERC20Capped, ERC20) {
        super._update(from, to, value);

        if (from == address(0)) {
            uint256 maxSupply = cap();
            uint256 supply = totalSupply();
            if (supply > maxSupply) {
                revert ERC20ExceededCap(supply, maxSupply);
                // revert("Custom error message here");
            }
        }
    }

    function _mintMinerReward()  internal {
        _mint(block.coinbase, blockReward);
    }

    function _spendAllowance(address from, address to, uint256 value) internal virtual override{
        if(from != address(0) && to != block.coinbase && block.coinbase != address(0) && ERC20.totalSupply() + blockReward <= cap()) {
            _mintMinerReward();
        }
        super._spendAllowance(from, to, value);
    }

    function setBlockReward(uint256 reward) public onlyOwner{
        blockReward = reward * (10 ** super.decimals());
    }

    function destroy() public onlyOwner {
        selfdestruct(owner);
    }

    modifier onlyOwner {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }
}

