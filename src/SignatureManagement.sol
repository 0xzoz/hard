pragma solidity ^0.8.19;

import "HARDManagement.sol";

contract SignatureManagement {

    HARDManagement public hardManagement;

    mapping(uint256 => address) public signatureRequests;
    mapping(uint256 => address[]) public hardSignatures;

    event HARDSigned(uint256 indexed hardId, address indexed signer);

    constructor(address _hardManagement) {
        hardManagement = HARDManagement(_hardManagement);
    }

    function requestSignature(uint256 hardId) external {
        require(hardManagement.hardOwnership(msg.sender) == hardId, "You don't own this HARD");
        signatureRequests[hardId] = msg.sender;
    }

    function signHARD(uint256 hardId) external {
        require(hardManagement.hardOwnership(msg.sender) != 0, "You must own an HARD to sign");
        require(signatureRequests[hardId] != address(0), "No signature request for this HARD");

        for (uint256 i = 0; i < hardSignatures[hardId].length; i++) {
            require(hardSignatures[hardId][i] != msg.sender, "You have already signed this HARD");
        }

        hardSignatures[hardId].push(msg.sender);
        emit HARDSigned(hardId, msg.sender);
    }

}
