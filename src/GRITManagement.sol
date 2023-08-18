pragma solidity ^0.8.19;

import "HARDManagement.sol";
import "SignatureManagement.sol";
import "SafeMath.sol";

contract GritPointsManagement {

    using SafeMath for uint256;

    HARDManagement public hardManagement;
    SignatureManagement public signatureManagement;

    mapping(address => uint256) public gritPoints;

    event GritMinted(address indexed recipient, uint256 amount);
    event GritBurned(address indexed issuer, uint256 amount);

    constructor(address _hardManagement, address _signatureManagement) {
        hardManagement = HARDManagement(_hardManagement);
        signatureManagement = SignatureManagement(_signatureManagement);
    }

    function mintGritForSignatures(uint256 hardId) external {
        require(hardManagement.hardOwnership(msg.sender) == hardId, "You don't own this HARD");

        uint256 signaturesCount = signatureManagement.hardSignatures(hardId).length;
        uint256 gritToMint = signaturesCount * 10;

        gritPoints[msg.sender] = gritPoints[msg.sender].add(gritToMint);
        emit GritMinted(msg.sender, gritToMint);
    }

    function burnGrit(uint256 hardId, uint256 amount) external {
        require(gritPoints[msg.sender] >= amount, "Not enough Grit points to burn");

        // Ensure the burner signed the specific HARD
        address[] memory signers = signatureManagement.hardSignatures(hardId);
        bool hasSigned = false;
        for (uint256 i = 0; i < signers.length; i++) {
            if (signers[i] == msg.sender) {
                hasSigned = true;
                break;
            }
        }
        require(hasSigned, "You haven't signed this HARD");

        gritPoints[msg.sender] = gritPoints[msg.sender].sub(amount);
        emit GritBurned(msg.sender, amount);
    }

}
