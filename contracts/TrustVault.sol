// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract TrustVault {

    struct Deposit {
        uint256 amount;
        uint256 unlockTime;
        bool withdrawn;
    }

    mapping(address => Deposit[]) private vaults;

    event Deposited(address indexed user, uint256 amount, uint256 unlockTime);
    event Withdrawn(address indexed user, uint256 amount, uint256 depositIndex);

    modifier validDeposit(address user, uint256 index) {
        require(index < vaults[user].length, "Deposit does not exist");
        require(!vaults[user][index].withdrawn, "Already withdrawn");
        _;
    }

    // Deponuj ETH sa minimalnim vremenom cekanja u sekundama
    function deposit(uint256 lockDuration) external payable {
        require(msg.value > 0, "Must send ETH");
        require(lockDuration > 0, "Lock duration must be > 0");

        uint256 unlockTime = block.timestamp + lockDuration;

        vaults[msg.sender].push(Deposit({
            amount: msg.value,
            unlockTime: unlockTime,
            withdrawn: false
        }));

        emit Deposited(msg.sender, msg.value, unlockTime);
    }

    // Povuci depozit po indeksu ako je rok prosao
    function withdraw(uint256 depositIndex)
        external
        validDeposit(msg.sender, depositIndex)
    {
        Deposit storage dep = vaults[msg.sender][depositIndex];
        require(block.timestamp >= dep.unlockTime, "Funds are still locked");

        dep.withdrawn = true;
        uint256 amount = dep.amount;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawn(msg.sender, amount, depositIndex);
    }

    // Vrati sve depozite za datog korisnika
    function getDeposits(address user) external view returns (Deposit[] memory) {
        return vaults[user];
    }

    // Koliko sekundi ostaje do otključavanja (0 ako je već prošlo)
    function getTimeRemaining(address user, uint256 index)
        external
        view
        validDeposit(user, index)
        returns (uint256)
    {
        uint256 unlock = vaults[user][index].unlockTime;
        if (block.timestamp >= unlock) return 0;
        return unlock - block.timestamp;
    }
}