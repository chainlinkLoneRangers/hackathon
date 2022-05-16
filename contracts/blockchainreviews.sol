//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

contract BlockchainReviews{

        event ReviewSubmitted(uint8 rating, string review);
        event ClientOnboarded(string clientName, string clientCategory);

        struct Review {
            uint8 rating;
            string review;
        }

        struct Client {
            string clientName;
            string clientCategory;
        }

        Review[] private userReviews;
        Client[] private clientData;

        function onboardClient(string memory _clientName, string memory _clientCategory) external payable {
            require(msg.value >= 1000, "Please provide sufficient funds");
            clientData.push(Client(_clientName, _clientCategory));
            emit ClientOnboarded(_clientName, _clientCategory);
        }

        function submitReviews(uint8 _rating, string memory _review) public {
            
            userReviews.push(Review(_rating, _review));
            emit ReviewSubmitted(_rating, _review);
        }

        function getReviews() public view returns (Review[] memory) {
            return userReviews;
        }

        function getContractBalance() public view returns(uint256) {
            return address(this).balance;
        }

}