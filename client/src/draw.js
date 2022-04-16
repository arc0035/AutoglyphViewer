const ethers = require("ethers");
import abi from '../../artifacts/contracts/Autoglyph.sol/Autoglyphs.json'

export async function drawCode(seed) {
    // const provider = new ethers.providers.Web3Provider(window.ethereum);
    // await provider.send("eth_requestAccounts", []);
    const provider = new ethers.providers.JsonRpcProvider("http://127.0.0.1:8545")
    const signer = provider.getSigner(0)    
    const factory = new ethers.ContractFactory(abi.abi, abi.bytecode,  signer)
    const contract = await factory.deploy()
    await contract.deployed()

    const result = await contract.draw(BigInt(seed))
    return result
}

