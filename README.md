## TD Composability

For this TD, you will be evaluated in two ways:
- first by sending to the teacher your github repository because for all exercises, you must write some solidity code or use `cast` tool but not just call etherscan. Please complete `IStudentToken.sol` and `IStudentNft.sol` also.
- second by calling exercice functions when needing (variable `exerciceProgression` will be check for evaluation)


**Here are specifics details:**

Ex 1: Deploy an ERC20 contract (2pts)

Ex 2: Mint your ERC20 tokens by calling `ex2_mintStudentToken` (2pts)

Ex 3: Mint some EvaluatorTokens by calling `ex3_mintEvaluatorToken` (2 pts)

Ex 4: From your smart contract, you must call uniswap V3 smart contracts in order to swap EvaluatorToken <> RewardToken. Then call `ex4_checkRewardTokenBalance`  (2 pts)

Ex 5: You must send to the Evaluator smart contract some RewardToken by calling `ex5_checkRewardTokenBalance` (2 pts)

Ex 6: Create a liquidity pool on uniswap V3 between your ERC20 tokens and some WETH. You must use Uniswap smart contracts (2 pts)

Ex 7: Deploy an ERC721 (2 pts)

Ex 8: Mint some ERC721's by calling `ex8_mintNFT` (2 pts)

Ex 9: Ouch... my Evaluator contract is admin of your ERC721 token. He has full rights and you must call `ex9_burnNft` (1 pts)

Ex 10: Verify your smart contract on Etherscan and sourcify (1 pts)

Ex 11: Simply call `ex11_unlock_ethers` (2 pts)

BONUS:
- You succeed to make all the TD in one transaction (1 pt)
- You can automate some tasks (like deployment) in a makefile (1 pt)


-----------------------------------------
Deployed Addresses on goerli:
- [Evaluator contract](https://goerli.etherscan.io/address/0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE)
- [Reward contract](https://goerli.etherscan.io/address/0x56822085cf7C15219f6dC404Ba24749f08f34173)

# Beginning of the solution : 
## How to load the variables in the .env file
source .env

## How to deploy and verify our contract
forge script script/Deployment.sol:DeploymentScript --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv