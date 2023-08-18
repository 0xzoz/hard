contract HARDManagement is IERC1155 {

    using SafeMath for uint256;

    address public owner;
    uint256 public currentNFTId = 1;

    mapping(address => uint256) public HARDOwnership;
    address[] public activeUsers;

    event HARDAirdropped(address indexed recipient, uint256 hardId);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the contract owner");
        _;
    }

    constructor(string memory _uri) IERC1155(_uri) {
        owner = msg.sender;
    }

    function setActiveUsers(address[] memory users) external onlyOwner {
        activeUsers = users;
    }

    function airdropHARD() external {
        require(activeUsers.length > 0, "No active users set");
        address recipient = activeUsers[random() % activeUsers.length];
        while(hardOwnership[recipient] != 0) {
            recipient = activeUsers[random() % activeUsers.length];
        }
        _mint(recipient, currentHARDId, 1, "");
        hardOwnership[recipient] = currentHARDId;
        currentHARDId = currentHARDId.add(1);
        emit HARDAirdropped(recipient, currentHARDId);
    }

    function random() internal view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
    }

}