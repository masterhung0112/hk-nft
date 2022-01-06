import { expect } from 'chai';
import { ethers } from "hardhat";

describe("Box", () => {
  it("retrieve returns a value previously stored", async function () {
    const Box = await ethers.getContractFactory("Box");
    const box = await Box.deploy();
    await box.deployed();
    // Store a value
    await box.store(42);

    // Test if the returned value is the same one
    // Note that we need to use strings to compare the 256 bit integers
    expect((await box.retrieve()).toString()).to.equal("42");
  });
});
