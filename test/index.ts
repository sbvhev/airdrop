import { expect } from "chai";
import { ethers, network } from "hardhat";
// @ts-ignore
import GnomeABI from "../abi/gnome.json";
import { Airdrop } from "../typechain";

const GNOME_ADDRESS = "0xE58Eb0Bb13a71d7B95c4C3cBE6Cb3DBb08f9cBFB";
const mirrorNFTHolder = "0x03c322db3f0d92ccdf6f8b6effd4031c94bed1ab";

describe("Airdrop", function () {
  let gnomeHolder: any;
  let signer: any;
  let airdrop: Airdrop;
  let gnomeContract: any;

  beforeEach(async function () {
    const Airdrop = await ethers.getContractFactory("Airdrop");
    airdrop = await Airdrop.deploy(
      "0xaf89C5E115Ab3437fC965224D317d09faa66ee3E"
    );
    await airdrop.deployed();

    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [mirrorNFTHolder],
    });
    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0xd53C79fF8c473bbFE4E40e5525D4d24fD4b8534c"],
    });

    signer = await ethers.getSigner(mirrorNFTHolder);

    const gnomeHolder = await ethers.getSigner(
      "0xd53C79fF8c473bbFE4E40e5525D4d24fD4b8534c"
    );

    await gnomeHolder.sendTransaction({
      to: airdrop.address,
      value: ethers.utils.parseEther("1.0"),
    });

    gnomeContract = new ethers.Contract(GNOME_ADDRESS, GnomeABI, signer);
    await gnomeContract
      .connect(gnomeHolder)
      .transfer(airdrop.address, ethers.utils.parseEther("9999"));
  });

  it("Should claim correct amount", async function () {
    const initialGnomeBalance = await gnomeContract.balanceOf(signer.address);
    await airdrop.connect(signer).claimAirdrop([909, 910]);
    expect(await gnomeContract.balanceOf(signer.address)).equal(
      initialGnomeBalance.add(ethers.utils.parseEther("1").mul(2000))
    );
  });

  it("Shouldn't claim tokens already claimed", async function () {
    const initialGnomeBalance = await gnomeContract.balanceOf(signer.address);

    // both Tokens are not used
    expect(await airdrop.isTokenUsed(909)).to.be.equal(false);
    expect(await airdrop.isTokenUsed(910)).to.be.equal(false);

    // claim
    await airdrop.connect(signer).claimAirdrop([909, 910]);

    const afterGnomeBalance = await gnomeContract.balanceOf(signer.address);

    expect(afterGnomeBalance).equal(
      initialGnomeBalance.add(ethers.utils.parseEther("1").mul(2000))
    );

    // both used
    expect(await airdrop.isTokenUsed(909)).to.be.equal(true);
    expect(await airdrop.isTokenUsed(910)).to.be.equal(true);

    await airdrop.connect(signer).claimAirdrop([909, 910, 911]);

    // balance does not change
    expect( await gnomeContract.balanceOf(signer.address)).equal(afterGnomeBalance);
  });



});
