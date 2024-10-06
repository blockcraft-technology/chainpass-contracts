// SPDX-License-Identifier: MIT
pragma solidity ^0.8.27;

import "@openzeppelin/contracts/utils/ReentrancyGuard.sol";  

contract FileSharing is ReentrancyGuard {

    struct DataItem {
        address pointer;
        address owner;
    }

    mapping(address => address) public userSettingsPointer;
    mapping(address => mapping(address => DataItem)) public userDataItems;
    mapping(address => address[]) public userPointers;
    mapping(address => mapping(address => DataItem)) public sharedWithUser;

    event SettingsPointerUpdated(address indexed user, address newPointer);
    event DataItemAdded(address indexed user, address pointer);
    event DataItemShared(address indexed from, address indexed to, address pointer);
    event DataItemRemoved(address indexed user, address pointer);
    event DataItemPointerUpdated(address indexed user, address oldPointer, address newPointer);
    event SharedDataItemRemoved(address indexed from, address indexed to, address pointer);

    modifier validAddress(address addr) {
        require(addr != address(0), "Invalid address");
        _;
    }

    modifier dataItemExists(address user, address pointer) {
        require(userDataItems[user][pointer].pointer != address(0), "Data item does not exist");
        _;
    }

    function updateSettingsPointer(address newPointer) public validAddress(newPointer) {
        userSettingsPointer[msg.sender] = newPointer;
        emit SettingsPointerUpdated(msg.sender, newPointer);
    }

    function addDataItem(address pointer) public validAddress(pointer) nonReentrant {
        require(userDataItems[msg.sender][pointer].pointer == address(0), "Data item already exists");

        DataItem memory newItem = DataItem({
            pointer: pointer,
            owner: msg.sender
        });

        userDataItems[msg.sender][pointer] = newItem;
        userPointers[msg.sender].push(pointer);
        emit DataItemAdded(msg.sender, pointer);
    }

    function removeDataItem(address pointer)
        public
        validAddress(pointer)
        dataItemExists(msg.sender, pointer)
        nonReentrant
    {
        require(userDataItems[msg.sender][pointer].owner == msg.sender, "Unauthorized: Not the owner");

        delete userDataItems[msg.sender][pointer];

        address[] storage pointers = userPointers[msg.sender];
        for (uint256 i = 0; i < pointers.length; i++) {
            if (pointers[i] == pointer) {
                pointers[i] = pointers[pointers.length - 1];
                pointers.pop();
                break;
            }
        }

        emit DataItemRemoved(msg.sender, pointer);
    }

    function shareDataItem(address pointer, address recipient)
        public
        validAddress(pointer)
        validAddress(recipient)
        dataItemExists(msg.sender, pointer)
        nonReentrant
    {
        require(userDataItems[msg.sender][pointer].owner == msg.sender, "Unauthorized: Not the owner");
        require(sharedWithUser[recipient][pointer].pointer == address(0), "File is already shared with the recipient");

        DataItem memory itemToShare = userDataItems[msg.sender][pointer];
        sharedWithUser[recipient][pointer] = itemToShare;
        emit DataItemShared(msg.sender, recipient, pointer);
    }

    function removeSharedDataItem(address recipient, address pointer)
        public
        validAddress(recipient)
        validAddress(pointer)
        nonReentrant
    {
        require(sharedWithUser[recipient][pointer].pointer != address(0), "Shared item does not exist");
        require(sharedWithUser[recipient][pointer].owner == msg.sender, "Unauthorized: Not the owner of shared file");

        delete sharedWithUser[recipient][pointer];
        emit SharedDataItemRemoved(msg.sender, recipient, pointer);
    }

    function updateDataItemPointer(address oldPointer, address newPointer)
        public
        validAddress(newPointer)
        validAddress(oldPointer)
        dataItemExists(msg.sender, oldPointer)
        nonReentrant
    {
        require(userDataItems[msg.sender][oldPointer].owner == msg.sender, "Unauthorized: Not the owner");

        DataItem storage itemToUpdate = userDataItems[msg.sender][oldPointer];
        itemToUpdate.pointer = newPointer;

        userDataItems[msg.sender][newPointer] = itemToUpdate;
        delete userDataItems[msg.sender][oldPointer];

        address[] storage pointers = userPointers[msg.sender];
        for (uint256 i = 0; i < pointers.length; i++) {
            if (pointers[i] == oldPointer) {
                pointers[i] = newPointer;
                break;
            }
        }

        for (uint256 i = 0; i < pointers.length; i++) {
            address recipient = pointers[i];
            if (sharedWithUser[recipient][oldPointer].owner == msg.sender) {
                sharedWithUser[recipient][newPointer] = sharedWithUser[recipient][oldPointer];
                delete sharedWithUser[recipient][oldPointer];
            }
        }

        emit DataItemPointerUpdated(msg.sender, oldPointer, newPointer);
    }

    function getFilesSharedWithMe(address me) public view returns (DataItem[] memory) {
        uint256 count = 0;

        for (uint256 i = 0; i < userPointers[me].length; i++) {
            address pointer = userPointers[me][i];
            if (sharedWithUser[me][pointer].pointer != address(0)) {
                count++;
            }
        }

        DataItem[] memory sharedFiles = new DataItem[](count);
        uint256 index = 0;

        for (uint256 i = 0; i < userPointers[me].length; i++) {
            address pointer = userPointers[me][i];
            if (sharedWithUser[me][pointer].pointer != address(0)) {
                sharedFiles[index] = sharedWithUser[me][pointer];
                index++;
            }
        }

        return sharedFiles;
    }

    function getUserFiles(address user) public view returns (address[] memory) {
        return userPointers[user];
    }
}
