// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.23;

import "./place_token.sol";

contract PlacesManager {
    PlaceToken public token;

    struct Place {
        string cid;
        string place_name;
        uint256 latitude; // in microdegrees
        uint256 longitude; // in microdegrees
        bool isApproved;
        uint256 approvalCount;
    }

    struct User {
        uint256 homeLatitude; // in microdegrees
        uint256 homeLongitude; // in microdegrees
    }

    Place[] public places;
    mapping(uint => address) public placeToOwner;
    mapping(address => uint) ownerPlaceCount;
    mapping(address => User) public users;

    event placeAdded(
        address contributor,
        string place_name,
        uint256 latitude,
        uint256 longitude
    );
    event placeApproved(
        string placeCid,
        string place_name,
        uint256 latitude,
        uint256 longitude
    );

    constructor() {
        token = new PlaceToken(address(this));
    }

    function signUp(uint256 _homeLatitude, uint256 _homeLongitude) public {
        users[msg.sender] = User(_homeLatitude, _homeLongitude);
    }

    function addPlace(
        string memory _cid,
        string memory _place_name,
        uint256 _latitude,
        uint256 _longitude
    ) public {
        places.push(Place(_cid, _place_name, _latitude, _longitude, false, 0));
        uint id = places.length - 1;
        placeToOwner[id] = msg.sender;
        ownerPlaceCount[msg.sender]++;

        emit placeAdded(msg.sender, _place_name, _latitude, _longitude);
    }

    function abs(uint256 a, uint256 b) private pure returns (uint256) {
        return a > b ? a - b : b - a;
    }

    function approvePlace(uint _placeId) public {
        require(
            abs(users[msg.sender].homeLatitude, places[_placeId].latitude) <=
                2000,
            "You are not in the vicinity of this place"
        );
        require(
            abs(users[msg.sender].homeLongitude, places[_placeId].longitude) <=
                200,
            "You are not in the vicinity of this place"
        );
        require(!places[_placeId].isApproved, "This place is already approved");

        places[_placeId].approvalCount++;
        if (places[_placeId].approvalCount >= 3) {
            places[_placeId].isApproved = true;

            // Mint tokens for the contributor
            token.mint(placeToOwner[_placeId], 1 * 10 ** 18); // Change this to the amount you want to mint

            emit placeApproved(
                places[_placeId].cid,
                places[_placeId].place_name,
                places[_placeId].latitude,
                places[_placeId].longitude
            );
        }
    }

    function addBusinessPlace(
        string memory _cid,
        string memory _place_name,
        uint256 _latitude,
        uint256 _longitude
    ) public {
        uint256 tokenAmount = 2 * 10 ** 18; // Twice the usual mint amount
        require(
            token.balanceOf(msg.sender) >= tokenAmount,
            "Insufficient tokens for business place addition"
        );

        // Transfer tokens from the business to the contract
        token.transferFrom(msg.sender, address(this), tokenAmount);

        places.push(Place(_cid, _place_name, _latitude, _longitude, true, 0));
        uint id = places.length - 1;
        placeToOwner[id] = msg.sender;
        ownerPlaceCount[msg.sender]++;

        emit placeAdded(msg.sender, _place_name, _latitude, _longitude);
        emit placeApproved(
            places[id].cid,
            places[id].place_name,
            places[id].latitude,
            places[id].longitude
        );
    }
}
