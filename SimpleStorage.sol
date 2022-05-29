// SPDX-License-Identifier: MIT
pragma solidity 0.8.8;

// EVM compatible: avalanche, fantom, polygon

contract SimpleStorage {
    // type name visibility return
    // Initalized to zero
    uint256 favoriteNumber;

    // People public person = People({favoriteNumber: 2, name: "mike"});

    // Dynamic array, add a number in [X] for static
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
        // for each thing we do, costs for gas
    }

    function retreive() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    // function add() public pure returns(uint256){
    //     return(1+1);
    // }
}

// Contract address: 0xd9145CCE52D386f254917e481eB44e9943F39138

// view, pure -> when called alone dont spend gas, that are just looking at it, cant change state
// pure cant look at blockchain stuff, use for math operations
// if you call view function in function that costs gas, then will pay gas for retrieve function
// blue buttons are viewing, no transaction, orange buttons are transactions green checkmark

// calldata, memory, storage, used for structs maps or arrays

// calldata: variables exist only in scope, cant change calldata variable
// memory: variables exist only in scope
// Storage: variables exist outside function (favoriteNumber)
