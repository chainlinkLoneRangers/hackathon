// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@chainlink/contracts/src/v0.8/ChainlinkClient.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
// KeeperCompatible.sol imports the functions from both ./KeeperBase.sol and
// ./interfaces/KeeperCompatibleInterface.sol
import "@chainlink/contracts/src/v0.8/KeeperCompatible.sol";

error TransferFailed();

contract Reviews is ReentrancyGuard {

    IERC20 public s_rewardToken;

    struct review {
        address reviewer;
        uint revieweeId;
        string ipfsHash;
        int8 reviewScore;
    }

    review[] public reviews;
    address[] public reviewees;
    uint256 rewardPerReview = 1;

    function addReview(uint256 _revieweeId, string memory _ipfsHash, int8 _reviewScore) external {
        reviews.push(review(msg.sender, _revieweeId, _ipfsHash, _reviewScore));
    }

    function addReviewee(address _reviewee) external {
        reviewees.push(_reviewee);
    }

    function _rewardReviewer() private nonReentrant {
        bool success = s_rewardToken.transfer(msg.sender, rewardPerReview);
        if (!success) {
            revert TransferFailed();
        }
    }
    
    //function addReview()
    //function updateReview() -- can only be allowed under certain circumstances
    //                        -- reviews should be "mostly immutable"
    //                        -- discuss with team about use cases
    //event notifyReviewer(address reviewer, review newReview) -- alert of new reviews
    //event notifyReviewee(address reviewee, review updatedReview) -- alert of response to review
    //function scheduleKeeper() -- schedule self publish of negative review
    //function arbitrateReview() -- allow parties to settle a negative review
    //function listAllReviews()

    
}