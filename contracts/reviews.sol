// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "classes/review.sol";

contract Reviews {

    review[] public reviews;
    address public reviewee;   //could one review pertain to multiple businesses
                               //Google reviews are one business to many reviews
                               //ours could be a many to many relationship
    //function addReview()
    //function updateReview() -- can only be allowed under certain circumstances
    //                        -- reviews should be "mostly immutable"
    //                        -- discuss with team about use cases
    //function notifyReviewer() -- alert of new reviews
    //function notifyReviewee() -- alert of response to review
    //function scheduleGatekeeper() -- schedule self publish of negative review
    //function arbitrateReview() -- allow parties to settle a negative review
    //function listAllReviews()
}