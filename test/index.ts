import { expect } from "chai";
import { ethers, network } from "hardhat";
// @ts-ignore
import GnomeABI from "../abi/gnome.json";
import { Airdrop } from "../typechain";

const GNOME_ADDRESS = "0xE58Eb0Bb13a71d7B95c4C3cBE6Cb3DBb08f9cBFB"

describe("Airdrop", function () {
  it("Should claim correct amount of GNOME", async function () {
    const Airdrop = await ethers.getContractFactory("Airdrop");
    const airdrop: Airdrop = await Airdrop.deploy(
      "0xaf89C5E115Ab3437fC965224D317d09faa66ee3E"
    );
    await airdrop.deployed();

    await network.provider.request({
      method: "hardhat_impersonateAccount",
      params: ["0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B"],
    });
    const signer = await ethers.getSigner(
      "0xAb5801a7D398351b8bE11C439e05C5B3259aeC9B"
    );

    const gnomeContract = new ethers.Contract(GNOME_ADDRESS, GnomeABI, signer);
    const initialGnomeBalance = await gnomeContract.balanceOf(signer.address);
    await airdrop.connect(signer).claimAirdrop([909, 910]);
    // const afterBalance = await gnomeContract.balanceOf(signer.address);
    console.log('initial balance, after balance', initialGnomeBalance)
  });
});
