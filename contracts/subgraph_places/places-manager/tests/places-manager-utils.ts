import { newMockEvent } from "matchstick-as"
import { ethereum, Address, BigInt } from "@graphprotocol/graph-ts"
import {
  placeAdded,
  placeApproved
} from "../generated/PlacesManager/PlacesManager"

export function createplaceAddedEvent(
  contributor: Address,
  place_name: string,
  latitude: BigInt,
  longitude: BigInt
): placeAdded {
  let placeAddedEvent = changetype<placeAdded>(newMockEvent())

  placeAddedEvent.parameters = new Array()

  placeAddedEvent.parameters.push(
    new ethereum.EventParam(
      "contributor",
      ethereum.Value.fromAddress(contributor)
    )
  )
  placeAddedEvent.parameters.push(
    new ethereum.EventParam("place_name", ethereum.Value.fromString(place_name))
  )
  placeAddedEvent.parameters.push(
    new ethereum.EventParam(
      "latitude",
      ethereum.Value.fromUnsignedBigInt(latitude)
    )
  )
  placeAddedEvent.parameters.push(
    new ethereum.EventParam(
      "longitude",
      ethereum.Value.fromUnsignedBigInt(longitude)
    )
  )

  return placeAddedEvent
}

export function createplaceApprovedEvent(
  placeCid: string,
  place_name: string,
  latitude: BigInt,
  longitude: BigInt
): placeApproved {
  let placeApprovedEvent = changetype<placeApproved>(newMockEvent())

  placeApprovedEvent.parameters = new Array()

  placeApprovedEvent.parameters.push(
    new ethereum.EventParam("placeCid", ethereum.Value.fromString(placeCid))
  )
  placeApprovedEvent.parameters.push(
    new ethereum.EventParam("place_name", ethereum.Value.fromString(place_name))
  )
  placeApprovedEvent.parameters.push(
    new ethereum.EventParam(
      "latitude",
      ethereum.Value.fromUnsignedBigInt(latitude)
    )
  )
  placeApprovedEvent.parameters.push(
    new ethereum.EventParam(
      "longitude",
      ethereum.Value.fromUnsignedBigInt(longitude)
    )
  )

  return placeApprovedEvent
}
