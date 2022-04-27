// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "classes/review.sol";
import "github.com/smartcontractkit/chainlink/evm-contracts/src/v0.6/ChainlinkClient.sol";

contract Reviews {

    review[] public reviews;
    address public reviewee;   //could one review pertain to multiple businesses
                               //Google reviews are one business to many reviews
                               //ours could be a many to many relationship
    //function addReview()
    //function updateReview() -- can only be allowed under certain circumstances
    //                        -- reviews should be "mostly immutable"
    //                        -- discuss with team about use cases
    //event notifyReviewer(address reviewer, review newReview) -- alert of new reviews
    //event notifyReviewee(address reviewee, review updatedReview) -- alert of response to review
    //function scheduleKeeper() -- schedule self publish of negative review
    //function arbitrateReview() -- allow parties to settle a negative review
    //function listAllReviews()

    bool private needsArbitration;
    bool private settled;
    bool private reviewerArbitrated;
    bool private revieweeArbitrated;
    bool private reviewerSettled;
    bool private revieweeSettled;

    constructor() public {
        owner = msg.sender;
        oraclePayment = 0.1 * 10 ** 18; // 0.1 LINK

        //TODO: we should mock these addresses for testing
        //Kovan alarm oracle
        oracle = 0x2f90A6D021db21e1B2A077c5a37B3C7E75D15b7e; 
        jobId = "a7ab70d561d34eb49e9b1612fd2e044b";
        settled = false;
        needsArbitration = false;
    }

    //should be a way for an owner or reviewer to extend the timer
    //maybe the owner needs to research or the reviewer needs time to reconsider
    //how best to do that?
    function scheduleKeeper(uint sleepMinutes) private {
        Chainlink.Request memory req = buildChainlinkRequest(jobId, address(this), this.fulfill.selector);

        //Linter: Avoid to make time-based decisions in your business logic [not-rely-on-time]
        //TODO: Fix Linter error
        req.addUint("until", now + sleepMinutes * 1 minutes);

        //Request keeper to sleep for $sleepMinutes and call publish at that time
        sendChainlinkRequestTo(oracle, req, oraclePayment);
    }

    //Callback for request
    function publishReview(bytes32 _requestId) public recordChainlinkFulfillment(_requestId) {
        //TODO: complete code

        //this is the use case when owner and reviewer cannot settle
        //other use cases:
        //owner and reviewer settle and agree review can be published
        //owner and reviewer settle and agree review cannot be published
        //a good review passes through the system and is automatically published
        if (needsArbitration == true && settled == false)
            addReview();
    }

    function arbitrateReview(address fromAddress) {
        //needs approval from both accounts
        //when that is done, the review will not be published
        //TODO: complete code
        if (fromAddress == reviewee)
            revieweeArbitrated = true;

        if (fromAddress == review.reviewer)
            reviewerArbitrated = true;
        
        if (reviewerArbitrated && revieweeArbitrated)
            cancelKeeper();

        //we also need to record the agreement they have reached
        //the smart contract will serve as the binding contract for their settlement
    }

    function markReviewSettled(address fromAddress) {
        //needs approval from both accounts
        //when that is done, the arbitration will be marked as settled (complete)
        //TODO: complete code
        if (fromAddress == reviewee)
            revieweeSettled = true;

        if (fromAddress == review.reviewer)
            reviewerSettled = true;
        
        settled = (reviewerSettled && revieweeSettled);
    }

    function cancelKeeper() {
        //can we cancel the keeper once it is started?
        //if not, we can add a flag on the callback (publishReview)
        //like so:
        settled == true;
    }
}