## Problem Solving - ERC-1155 Recipient

Handling the recipient of ERC-1155 tokens can be complicated. In this scenario, the original code is not properly handling the "receipt" of these. Doing it manually can be complicated, so the new code uses a pre-built and audited smart contract utily from OpenZeppelin called [ERC1155Holder](https://docs.openzeppelin.com/contracts/5.x/api/token/erc1155#ERC1155Holder)

See Original Contract by [Clicking Here](./src/OriginalContract.sol)
See New Contract by [Clicking Here](./src/ERC1155StakeandBurnCityBuilderXpert.sol)

### Ownership + Licensing
The new contract has an initial starting point test suite to ensure that the recipient issue is resolved. The code HAS not been optimized, edited, or reviewed for security in any way. These modifications are made under the MIT license and are free to use with no rights back to the author. The original smart contract remains the sole property of the author unless they choose otherwise. The contributors make no guarantees regarding the safety of these contracts.

## Foundry

**Foundry is a blazing fast, portable and modular toolkit for Ethereum application development written in Rust.**

Foundry consists of:

-   **Forge**: Ethereum testing framework (like Truffle, Hardhat and DappTools).
-   **Cast**: Swiss army knife for interacting with EVM smart contracts, sending transactions and getting chain data.
-   **Anvil**: Local Ethereum node, akin to Ganache, Hardhat Network.
-   **Chisel**: Fast, utilitarian, and verbose solidity REPL.

## Documentation

https://book.getfoundry.sh/

## Usage

### Build

```shell
$ forge build
```

### Test (Run this to see it work)

```shell
$ forge test
```

### Format

```shell
$ forge fmt
```

### Gas Snapshots

```shell
$ forge snapshot
```

### Anvil

```shell
$ anvil
```

### Deploy

```shell
$ forge script script/Counter.s.sol:CounterScript --rpc-url <your_rpc_url> --private-key <your_private_key>
```

### Cast

```shell
$ cast <subcommand>
```

### Help

```shell
$ forge --help
$ anvil --help
$ cast --help
```
