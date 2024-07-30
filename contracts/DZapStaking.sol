// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC721/utils/ERC721HolderUpgradeable.sol";


contract DZapStaking is UUPSUpgradeable,  OwnableUpgradeable, ERC721HolderUpgradeable {


IERC721 public nft;
IERC20 public rewardToken;
uint public reward;
uint public rewardPerBlock;
uint public unbondingPeriod;
uint public rewardDelayPeriod;


struct StakedNFT{
    address owner;
    uint stakedBlock;
    uint claimedBlock;


}

bool private _paused;



modifier whenNotPaused() {
    require(!_paused, "contract is paused");
    _;
}
     
     mapping(uint => StakedNFT) public stakedNFTs;
     mapping(address => uint[]) public userStakedNFTs;

     event staked(address indexed user, uint tokenId);
     event _unstaked(address indexed user, uint tokenId);
     event rewardClaimed(address indexed user, uint amount);

     function initialize(address _nft, address _rewardToken, uint _rewardsPerBlock, uint _unbondingPeriod, uint _rewardDelayPeriod) public initializer {
          
        __Ownable_init;
        __ERC721Holder_init();


        nft = IERC721(_nft);
        rewardToken = IERC20(_rewardToken);
        rewardPerBlock = _rewardsPerBlock;
        unbondingPeriod = _unbondingPeriod;
        rewardDelayPeriod = _rewardDelayPeriod;
        _paused = false;

     }


     function _authorizeUpgrade(address newImplementation) internal override onlyOwner {

     }


     function stakeNFT(uint tokenId) external whenNotPaused {
        nft.safeTransferFrom(msg.sender, address(this), tokenId);
        stakedNFTs[tokenId] = StakedNFT({
            owner : msg.sender,
            stakedBlock : block.number,
            claimedBlock : block.number
        });

        userStakedNFTs[msg.sender].push(tokenId);
        emit staked(msg.sender, tokenId);
     }

     function unstakeNFT(uint tokenId) external {
        require(stakedNFTs[tokenId].owner == msg.sender, "not the owner");
        stakedNFTs[tokenId].claimedBlock = 0;
        emit _unstaked(msg.sender, tokenId);

     }


     function withdrawNFT(uint tokenId) external {
        require(stakedNFTs[tokenId].owner == msg.sender, "not the owner");
        require(stakedNFTs[tokenId].claimedBlock == 0, "not unstaked");
        require(block.number >= stakedNFTs[tokenId].stakedBlock +  unbondingPeriod, "unbonding period not passed");
        nft.safeTransferFrom(address(this), msg.sender, tokenId);
        _removeUserStakedNFT(msg.sender, tokenId);
        delete stakedNFTs[tokenId];
        
     }

     function claimRewards(uint[] calldata tokenIds) external whenNotPaused {
        uint totalRewards = 0;
        for (uint i = 0; i < tokenIds.length; i++) {
            uint tokenId = tokenIds[i];
            StakedNFT storage _StakedNFT = stakedNFTs[tokenId];
            require(_StakedNFT.owner == msg.sender, "not the owner");
            require(_StakedNFT.claimedBlock != 0, "NFT unstaked");
            require(block.number >= _StakedNFT.claimedBlock + rewardDelayPeriod, "claim delay not met");
             rewardPerBlock = block.number - _StakedNFT.claimedBlock;
            totalRewards += reward;
            _StakedNFT.claimedBlock = block.number;




        }


        require(rewardToken.transfer(msg.sender, totalRewards), "reward transfer failed");
        emit rewardClaimed(msg.sender, totalRewards);

     }

    event paused();
     function pause() external onlyOwner {
        _paused = true;
        emit paused();
     }
     

     event unpaused();
     function unpause() external onlyOwner {
        _paused = false;
        emit unpaused();
     }

     

    function setRewardsPerBlock(uint _rewardsPerBlock) external onlyOwner{
        rewardPerBlock = _rewardsPerBlock;
        
    }


    function _removeUserStakedNFT(address user, uint tokenId) internal {
        uint[] storage stakedTokens = userStakedNFTs[user];
        for (uint i = 0; i < stakedTokens.length; i++) {
            if (stakedTokens[i] == tokenId) {
                stakedTokens[i] = stakedTokens[stakedTokens.length - 1];
                stakedTokens.pop();
                break;

            }
        }
    }









}