// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// You can also run a script with `npx hardhat run <script>`. If you do that, Hardhat
// will compile your contracts, add the Hardhat Runtime Environment's members to the
// global scope, and execute the script.
const hre = require("hardhat");

async function main() {

  const ChannelVideo1 = await hre.ethers.getContractFactory("ChannelVideo");
  const channelVideo1 = await ChannelVideo1.deploy("SvetlanaIRL");
  await channelVideo1.deployed();
  console.log("ChannelVideo1 deployed to:", channelVideo1.address);

  const ChannelVideo2 = await hre.ethers.getContractFactory("ChannelVideo");
  const channelVideo2 = await ChannelVideo2.deploy("SuperTrip");
  await channelVideo2.deployed();
  console.log("ChannelVideo2 deployed to:", channelVideo2.address);

  const ChannelVideo3 = await hre.ethers.getContractFactory("ChannelVideo");
  const channelVideo3 = await ChannelVideo3.deploy("nimidiffa");
  await channelVideo3.deployed();
  console.log("ChannelVideo3 deployed to:", channelVideo3.address);

  const ChannelVideo4 = await hre.ethers.getContractFactory("ChannelVideo");
  const channelVideo4 = await ChannelVideo4.deploy("YourChannel");
  await channelVideo4.deployed();
  console.log("ChannelVideo4 deployed to:", channelVideo4.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
