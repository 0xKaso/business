const {
  time,
  loadFixture,
} = require("@nomicfoundation/hardhat-network-helpers");
const { anyValue } = require("@nomicfoundation/hardhat-chai-matchers/withArgs");
const { expect } = require("chai");
const BusinessDeploy = require("./deploy/main.js");
const { ethers } = require("hardhat");

describe("business", function (accounts) {
  let Business;
  let BusinessAddr;
  let Signers;

  beforeEach(async () => {
    Business = await BusinessDeploy(false, false, false);

    BusinessAddr = Business.address;
    Signers = await ethers.getSigners();
  });

  it("check rights match deployment input", async function () {
    const rights = await Business.rights();

    expect(rights.isWhitelisted).to.equal(false);
    expect(rights.isLock).to.equal(false);
    expect(rights.isCap).to.equal(false);
  });

  it("check owner match deployment input", async function () {
    const owner = await Business.owner();
    expect(owner).to.equal(Signers[0].address);
  });

  it("mint SFT and pay eth", async function () {
    await Business.mint().catch(function (err) {
      expect(err.message).include("Err_Invalid_Invest_Amount");
    });
    await Business.mint({ value: 100000 });
  });
});
