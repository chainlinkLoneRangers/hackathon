//SPDX-License-Identifier: Unlicense

pragma solidity ^0.8.4;

import "https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/KeeperCompatible.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract BlockchainReviews is KeeperCompatibleInterface, ERC20  {

        event ReviewSubmitted(uint8 rating, string review);
        event ClientOnboarded(address indexed clientAddress, string clientName, string clientCategory, uint256 timestamp, bool rewarded);
        event SetClientOnboardingFee(uint256 fee);

        address payable private _owner;
        uint256 private _clientOnboardingFee;

        constructor(uint updateInterval) ERC20("On Chain Reviews Token", "OCRT") {
        _owner = payable(msg.sender);
        _clientOnboardingFee = 1 ether;

        //ERC20 mint
        _mint(msg.sender, 1000 * 10 ** 18);

        // chainlink keepers
        interval = updateInterval;
        lastTimeStamp = block.timestamp;
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
            address clientAddress;
            string clientName;
            string clientCategory;
            uint onboardingTime;
            bool rewarded;
        }

        Review[] private userReviews;
        Client[] private clientData;

        // State change fucntions

        function setClientOnboardingFee(uint256 _fee) public onlyOwner {
            _clientOnboardingFee = _fee;
            emit SetClientOnboardingFee(_fee);

        }

        function onboardClient(string memory _clientName, string memory _clientCategory) external payable {
            require(msg.value == 1 ether, "Please enter the required onboarding fee");
            clientData.push(Client(msg.sender, _clientName, _clientCategory, block.timestamp, false));
            emit ClientOnboarded(msg.sender, _clientName, _clientCategory, block.timestamp, false);
        }

        function submitReviews(uint8 _rating, string memory _review) public {
            
            userReviews.push(Review(_rating, _review));
            emit ReviewSubmitted(_rating, _review);
        }

        function _rewardClientsWithTokens() private {
            for (uint256 i = 0; i < clientData.length; i++){
                if ((block.timestamp > clientData[i].onboardingTime + 30 days) && (clientData[i].rewarded == false)){
                    transfer(clientData[i].clientAddress, 1);
                }
            }
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

        //ERC20
        
        function mintMoreTokens(address _to, uint256 _amount) external {
            require(msg.sender == _owner, "You are not the Owner");
            _mint(_to, _amount);
        }

        // Chainlink Keepers

        uint256 public immutable interval;
        uint256 public lastTimeStamp;    

        function checkUpkeep(bytes calldata checkData) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = (block.timestamp - lastTimeStamp) > interval;
        performData = checkData;
        }

        function performUpkeep(bytes calldata performData) external override {
        lastTimeStamp = block.timestamp;
        _rewardClientsWithTokens();
        performData;
        }

}