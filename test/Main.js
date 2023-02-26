const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const BusinessDeploy = require("./deploy/main.js")

describe("business", function (accounts) {
  let Business;
  let BusinessAddr;
  let Signers;

  beforeEach(async () => {
    Business = await BusinessDeploy();
    BusinessAddr = Business.address;
    Signers = await ethers.getSigners();
  });

  it("deployer is the manager", async function () {
    const owner = await Business.owner();
    const owner_ = Signers[0].address;
    expect(owner).to.equal(owner_);
  });
});
