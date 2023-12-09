import {
  assert,
  describe,
  test,
  clearStore,
  beforeAll,
  afterAll
} from "matchstick-as/assembly/index"
import { Address, BigInt } from "@graphprotocol/graph-ts"
import { placeAdded } from "../generated/schema"
import { placeAdded as placeAddedEvent } from "../generated/PlacesManager/PlacesManager"
import { handleplaceAdded } from "../src/places-manager"
import { createplaceAddedEvent } from "./places-manager-utils"

// Tests structure (matchstick-as >=0.5.0)
// https://thegraph.com/docs/en/developer/matchstick/#tests-structure-0-5-0

describe("Describe entity assertions", () => {
  beforeAll(() => {
    let contributor = Address.fromString(
      "0x0000000000000000000000000000000000000001"
    )
    let place_name = "Example string value"
    let latitude = BigInt.fromI32(234)
    let longitude = BigInt.fromI32(234)
    let newplaceAddedEvent = createplaceAddedEvent(
      contributor,
      place_name,
      latitude,
      longitude
    )
    handleplaceAdded(newplaceAddedEvent)
  })

  afterAll(() => {
    clearStore()
  })

  // For more test scenarios, see:
  // https://thegraph.com/docs/en/developer/matchstick/#write-a-unit-test

  test("placeAdded created and stored", () => {
    assert.entityCount("placeAdded", 1)

    // 0xa16081f360e3847006db660bae1c6d1b2e17ec2a is the default address used in newMockEvent() function
    assert.fieldEquals(
      "placeAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "contributor",
      "0x0000000000000000000000000000000000000001"
    )
    assert.fieldEquals(
      "placeAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "place_name",
      "Example string value"
    )
    assert.fieldEquals(
      "placeAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "latitude",
      "234"
    )
    assert.fieldEquals(
      "placeAdded",
      "0xa16081f360e3847006db660bae1c6d1b2e17ec2a-1",
      "longitude",
      "234"
    )

    // More assert options:
    // https://thegraph.com/docs/en/developer/matchstick/#asserts
  })
})
