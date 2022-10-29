// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
import "chainlink/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "chainlink/v0.8/VRFConsumerBaseV2.sol";

contract VRFv2Consumer is VRFConsumerBaseV2 {
    // Does the random word verification
    VRFCoordinatorV2Interface COORDINATOR;
    // Your subscription ID.
    // hardcoded into the constructor
    // The subscription ID is a unique identifier for your subscription and is passed
    // as a parameter in the constructor
    uint64 s_subscriptionId;
    // Each VRF supported chain has a unique contract address representing the main VRF V2 contract.
    // This address is passed to both the inherited interface as a reference later.
    // Goerli VRF v2 coordinator address - we use this address to request a random value
    address vrfCoordinator = 0x2Ca8E0C643bDe4C2E08ab1fA0da3401AdAD7734D;
    // The gas lane to use, which specifies the maximum gas price we are willing to pay per request.
    // Higher gas lane means higher price and lower confirmation times,
    // mainnets on chainlink VRF typically have multiple gas lanes,
    // but Goerli only has one gas lane. For more details,
    // see https://docs.chain.link/docs/vrf-contracts/#configurations
    bytes32 keyHash =
        0x79d3d8832d904592c0bf9818b621522c988bb8b0c05cdc3b15aea1b6e8db0c15;
    //Goerli has a max gas limit of 2.5 million,
    // As a rule you will be charged with the amount of work already done by the VRF oracle
    // if the function fails due to a lack of gas on your part.
    // we'll cap out at 200000, enough for about 10 words since each word costs about 20k gas
    uint32 callbackGasLimit = 200000;
    // The default is 3, but you can set this higher.
    // The higher the more secure the data.
    uint16 requestConfirmations = 3;
    // Cannot exceed VRFCoordinatorV2.MAX_NUM_WORDS.
    // maximum number of random values is 500 for Goerli Testnet
    uint32 public numWords = 3;
    uint256[] public s_randomWords;
    uint256 public s_requestId;
    address s_owner;

    // As you can see we have a constructor that takes in the subscription ID of our VRF subscription.
    // The VRFConsumerBaseV2 constructor takes in the VRF coordinator address.
    constructor(uint64 subscriptionId) VRFConsumerBaseV2(vrfCoordinator) {
        COORDINATOR = VRFCoordinatorV2Interface(vrfCoordinator);
        s_owner = msg.sender;
        s_subscriptionId = subscriptionId;
    }

    // Assumes the subscription is funded sufficiently. Sends a request to the VRF coordinator
    // for a supply of random words. Every single request has a unique ID.
    function requestRandomWords() external onlyOwner {
        // Will revert if subscription is not set and funded.
        s_requestId = COORDINATOR.requestRandomWords(
            keyHash,
            s_subscriptionId,
            requestConfirmations,
            callbackGasLimit,
            numWords
        );
    }

    // This is the function that is called by the VRF coordinator when the request is fulfilled.
    // It uses the request IDs we saw before to fetch our random data.
    function fulfillRandomWords(
        uint256, /* requestId */
        uint256[] memory randomWords
    ) internal override {
        s_randomWords = randomWords;
    }

    //function to change the number of requested words per VRF request.
    function changeNumOfWords(uint32 _numWords) public onlyOwner {
        numWords = _numWords;
    }

    modifier onlyOwner() {
        require(msg.sender == s_owner);
        _;
    }
}
