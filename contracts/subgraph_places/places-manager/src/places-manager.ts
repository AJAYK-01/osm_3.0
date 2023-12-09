import {
  placeAdded as placeAddedEvent,
  placeApproved as placeApprovedEvent
} from "../generated/PlacesManager/PlacesManager"
import { placeAdded, placeApproved } from "../generated/schema"

export function handleplaceAdded(event: placeAddedEvent): void {
  let entity = new placeAdded(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.contributor = event.params.contributor
  entity.place_name = event.params.place_name
  entity.latitude = event.params.latitude
  entity.longitude = event.params.longitude

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}

export function handleplaceApproved(event: placeApprovedEvent): void {
  let entity = new placeApproved(
    event.transaction.hash.concatI32(event.logIndex.toI32())
  )
  entity.placeCid = event.params.placeCid
  entity.place_name = event.params.place_name
  entity.latitude = event.params.latitude
  entity.longitude = event.params.longitude

  entity.blockNumber = event.block.number
  entity.blockTimestamp = event.block.timestamp
  entity.transactionHash = event.transaction.hash

  entity.save()
}
