// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.24;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol";
import "@openzeppelin/contracts/utils/introspection/ERC165.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Holder.sol";

contract ERC1155StakeandBurnCityBuilderXpert is Ownable, ERC1155Holder {
    struct StakedRecord {
        uint256 amount;
        uint256 stakedAt; // Timestamp of when the tokens were staked
    }

    mapping(address => bool) public admins;
    mapping(address => mapping(uint256 => uint256)) public stakedBalances; // Total balance staked per user and tokenId
    mapping(address => mapping(uint256 => StakedRecord[])) public stakingRecords; // List of staking records per user and tokenId

    uint256 public unstakingDelay = 30 days; // Default unstaking delay, configurable

    address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD;

    modifier onlyAdmin() {
        require(admins[msg.sender] || owner() == msg.sender, "Not authorized");
        _;
    }

    event TokenStaked(
        address indexed staker, address indexed tokenAddress, uint256 indexed tokenId, uint256 amount, uint256 stakedAt
    );
    event TokenUnstaked(address indexed staker, address indexed tokenAddress, uint256 indexed tokenId, uint256 amount);
    event TokenBurned(address indexed burner, address indexed tokenAddress, uint256 indexed tokenId, uint256 amount);
    event UnstakingDelayUpdated(uint256 newDelay);

    constructor() Ownable(msg.sender) {}

    function addAdmin(address _admin) external onlyOwner {
        admins[_admin] = true;
    }

    function removeAdmin(address _admin) external onlyOwner {
        admins[_admin] = false;
    }

    function setUnstakingDelay(uint256 _delay) external onlyAdmin {
        require(_delay >= 1 minutes, "Delay must be at least 1 minute");
        unstakingDelay = _delay;
        emit UnstakingDelayUpdated(_delay);
    }

    function stakeERC1155(address tokenAddress, uint256 tokenId, uint256 amount) external {
        require(amount > 0, "Amount must be greater than 0");
        require(IERC1155(tokenAddress).balanceOf(msg.sender, tokenId) >= amount, "Insufficient token balance");

        // Log approval check
        bool isApproved = IERC1155(tokenAddress).isApprovedForAll(msg.sender, address(this));
        require(isApproved, "Contract is not approved");

        // Transfer tokens
        IERC1155(tokenAddress).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");

        stakedBalances[msg.sender][tokenId] += amount;

        stakingRecords[msg.sender][tokenId].push(StakedRecord({amount: amount, stakedAt: block.timestamp}));

        emit TokenStaked(msg.sender, tokenAddress, tokenId, amount, block.timestamp);
    }

    function unstakeERC1155(address tokenAddress, uint256 tokenId, uint256 amount) external {
        require(stakedBalances[msg.sender][tokenId] >= amount, "Insufficient balance");

        uint256 remainingAmount = amount;
        StakedRecord[] storage records = stakingRecords[msg.sender][tokenId];

        // Iterate through staking records to fulfill the unstake request
        for (uint256 i = 0; i < records.length && remainingAmount > 0; i++) {
            StakedRecord storage record = records[i];

            // Ensure the staking delay is respected
            require(block.timestamp >= record.stakedAt + unstakingDelay, "Unstaking not allowed yet");

            if (record.amount <= remainingAmount) {
                // Consume the entire record
                remainingAmount -= record.amount;
                record.amount = 0;
            } else {
                // Partially consume the record
                record.amount -= remainingAmount;
                remainingAmount = 0;
            }
        }

        require(remainingAmount == 0, "Unable to unstake the requested amount");

        // Update the overall balance and transfer tokens
        stakedBalances[msg.sender][tokenId] -= amount;
        IERC1155(tokenAddress).safeTransferFrom(address(this), msg.sender, tokenId, amount, "");

        emit TokenUnstaked(msg.sender, tokenAddress, tokenId, amount);
    }

    function burnERC1155(address tokenAddress, uint256 tokenId, uint256 amount) external onlyAdmin {
        require(stakedBalances[msg.sender][tokenId] >= amount, "Insufficient balance");

        stakedBalances[msg.sender][tokenId] -= amount;

        // Send the tokens to the burn address
        IERC1155(tokenAddress).safeTransferFrom(address(this), BURN_ADDRESS, tokenId, amount, "");

        emit TokenBurned(msg.sender, tokenAddress, tokenId, amount);
    }
}
