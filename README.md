# Solidity ETH Timelock Vault

A minimal smart contract that lets users lock ETH deposits for a self-defined duration.
No admin keys. No early withdrawals. Funds release only when the lock expires.

Deployed and verified on **Sepolia testnet**.

---

## How It Works

1. Call `deposit(lockDuration)` with ETH attached — `lockDuration` is in seconds
2. The contract records your deposit with an unlock timestamp
3. Call `withdraw(depositIndex)` after the lock expires to retrieve your ETH
4. Multiple independent deposits per address are supported

---

## Contract

| Function | Description |
|---|---|
| `deposit(uint256 lockDuration)` | Lock ETH for a given number of seconds |
| `withdraw(uint256 depositIndex)` | Withdraw after lock expires |
| `getDeposits(address user)` | View all deposits for an address |
| `getTimeRemaining(address user, uint256 index)` | Seconds until a deposit unlocks |

---

## Deployment

**Network:** Sepolia Testnet  
**Contract address:** 0xFE697f169274Bc33b19799BA407Db40866C4cD1A

**Etherscan:** [Example of transaction](https://sepolia.etherscan.io/tx/0x45215452212104d115084799f819f76caf8ad16a58ededb280be2007a9c063cf)

---

## Run Locally (Remix IDE)

1. Open [Remix IDE](https://remix.ethereum.org)
2. Paste `contracts/TrustVault.sol`
3. Compile with Solidity `^0.8.20`
4. Deploy via **Injected Provider** on Sepolia

---

## Tech

- Solidity `^0.8.20`
- Remix IDE
- Sepolia testnet
