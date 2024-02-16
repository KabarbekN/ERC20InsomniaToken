const hre = require("hardhat");

async function main() {
  const InsomniaToken = await hre.ethers.getContractFactory('InsomniaToken');
  const insomniaToken = await InsomniaToken.deploy(100_000_000, 50);

  const address = await insomniaToken.waitForDeployment();
  console.log("Insomnia Token deployed: ", address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
