// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.23;

contract PlacesManager {
    struct Place {
        string cid;
        bool isApproved;
    }

    Place[] public places;
    mapping(uint => address) public placeToOwner;
    mapping(address => uint) ownerPlaceCount;

    event placeAdded(address contributor, Place place);
    event placeApproved(string placeCid);

    function addPlace(string memory _cid) public {
        places.push(Place(_cid, false));
        uint id = places.length - 1;
        placeToOwner[id] = msg.sender;
        ownerPlaceCount[msg.sender]++;

        emit placeAdded(msg.sender, places[id]);
    }

    function approvePlace(uint _placeId) public {
        require(
            msg.sender == placeToOwner[_placeId],
            "Only the owner can approve this place"
        );
        places[_placeId].isApproved = true;

        emit placeApproved(places[_placeId].cid);
    }
}
