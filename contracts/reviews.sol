//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.0;

contract BlockchainReviews{

        event ReviewSubmitted(uint8 rating, string review);
        event ClientOnboarded(string clientName, string clientCategory);
        event SetClientOnboardingFee(uint256 fee);

        address payable private _owner;
        uint256 private _clientOnboardingFee;

        constructor() {
            _owner = payable(msg.sender);
            _clientOnboardingFee = 0.01 ether;
        }
        
        modifier onlyOwner() {
            require(msg.sender == _owner);
            _;
        }

        struct Review {
            uint8 rating;
            string review;
        }

        struct Client {
            string clientName;
            string clientCategory;
            uint256 rewardReserves;
        }

        Review[] private userReviews;
        Client[] private clientData;

        // State change fucntions

        function setClientOnboardingFee(uint256 _fee) public onlyOwner {
            _clientOnboardingFee = _fee;
            emit SetClientOnboardingFee(_fee);

        }

        function onboardClient(string memory _clientName, string memory _clientCategory) external payable {
            require(msg.value == 0.01 ether, "Please enter the required onboarding fee");
            clientData.push(Client(_clientName, _clientCategory, msg.value));
            emit ClientOnboarded(_clientName, _clientCategory);

        }

        function submitReviews(uint8 _rating, string memory _review) public {
            
            userReviews.push(Review(_rating, _review));
            emit ReviewSubmitted(_rating, _review);
            payable(msg.sender).transfer(0.0001 ether);
        }

        function fillUpRewardPot(uint256 clientId) external payable {
            require(msg.value >= 0.01 ether, "Please enter minimum the required onboaording fee");
            clientData[clientId].rewardReserves += msg.value;
        }

        // Getter functions

        function getClientOnboardingFee() external view returns(uint256) {
            return _clientOnboardingFee;
        }

        function getReviews() external view returns (Review[] memory) {
            return userReviews;
        }

        function getContractBalance() external view returns(uint256) {
            return address(this).balance;
        }
        function viewClientList() external view returns(Client[] memory) {
            return clientData;
        } 

}