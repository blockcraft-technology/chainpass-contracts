# Data Sharing Smart Contract for ChainPass

## Overview

This smart contract is designed for use on the iExec blockchain network and built for the EthRome 2024 Hackathon. It allows users to securely store, share, and manage data pointers (represented as Ethereum addresses) on-chain. Users can set their own settings, add data items, share data with others, and retrieve data shared with them.

## Features

- **User Settings Management**
- **Data Management & Sharing**
- **Data Pointer Updates**
- **Shared Data Management**

## Contract Details

### Structs
- **DataItem**: Represents a data with `pointer` (address) and `owner` (address).

### Mappings
- `userSettingsPointer`: Maps users' settings pointers.
- `userDataItems`: Maps users' data pointers to `DataItem`.
- `userPointers`: Tracks data pointers owned by each user.
- `sharedWithUser`: Tracks data shared with each user.

### Events
- **SettingsPointerUpdated**: Triggered when a user updates their settings pointer.
- **DataItemAdded**: Triggered when a data is added.
- **DataItemShared**: Triggered when a data is shared with another user.
- **DataItemRemoved**: Triggered when a data is removed.
- **DataItemPointerUpdated**: Triggered when a data pointer is updated.
- **SharedDataItemRemoved**: Triggered when a shared data is removed from another user's list.

## Functions

### Key Functions:
1. **updateSettingsPointer**: Updates the user's settings pointer.
2. **addDataItem**: Adds new data to the user's list.
3. **shareDataItem**: Shares data with another user.
4. **removeDataItem**: Removes data from the user's list.
5. **removeSharedDataItem**: Removes data shared with another user.
6. **updateDataItemPointer**: Updates the pointer of an existing data.
7. **getDatasSharedWithMe**: Retrieves data shared with the given address.
8. **getUserData**: Retrieves the data pointers owned by the given user.

## Deployment

1. Set up `.env` with your private key:
   ```bash
   PRIVATE_KEY=your_private_key


## Contract Deployment

The contract is currently deployed on the iExec Bellecour network:

- **Contract Address**: 0x58B19940498f1a15993C6FDC6897BA7b72A71162
- **Block Explorer URL**: [View on Blockscout](https://blockscout-bellecour.iex.ec/address/0x58B19940498f1a15993C6FDC6897BA7b72A71162)
