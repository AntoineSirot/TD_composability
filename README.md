## TD Composability

This TD, is forked from the original subject. In this repo i'll explain how far i went and what i did at every steps.

### Deployment: 

To load the variables in the .env file:
```
source .env
```

To deploy and verify our contract:
```
forge script path/to/DeploymentScript.sol:DeploymentScript --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
```

If there is an issue with the verification:
```
forge verify-contract --chain-id $CHAIN_ID --etherscan-api-key $ETHERSCAN_API_KEY $MY_CONTRACT_ADDRESS path/to/contractName.sol:contractName
```

### Interacting with specific contract: 

These are the two commands i used to interact with specific contracts :

- Write something in a contract: 
```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $MY_CONTRACT_ADDRESS "functionName(typeOf(param1), typeOf(param2))" param1 param2
```
- Read something in a contract:
```
cast call --rpc-url $GOERLI_RPC_URL $MY_CONTRACT_ADDRESS "functionName(typeOf(param1), typeOf(param2))" param1 param2
```


### Updating contract's addresses: 

To give the Evaluator's contract my contracts' addresses I needded to give him the new address each time I deployed a contract : 

```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $EVALUATOR_CONTRACT "registerStudentNft(address)" $MY_CONTRACT_ADDRESS
```
or
```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $EVALUATOR_CONTRACT "registerStudentToken(address)" $MY_CONTRACT_ADDRESS
```

### Ex 1: Deploy an ERC20: 

I implemented a StudentToken.sol contract based on the interface IStudentToken.sol. For this step I imported openzeppelin lib to create my ERC20 and then i deployed StudentToken: 

```
forge script script/DeploymentERC20.sol:DeploymentScriptToken --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
```

### Ex 2: Mint your ERC20

For this one i just needed to approve the evaluator to transfer some token from the contract : 
```
_approve(address(this), EvaluatorToken, INITIAL_SUPPLY);
```

Then, i redeployed the new contract, send the new address to the Evaluator's contract and then called the `ex2_mintStudentToken`:
```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $EVALUATOR_CONTRACT "ex2_mintStudentToken()"
```

### Ex 3: Mint some EvaluatorTokens

For this exercise i needed to transfer some token (from my wallet) to the contract so that it'll have 30000000 of my ERC20 instead of the 10000000 he got from the last exercise: 
```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $MY_CONTRACT_ADDRESS "transfer(address, uint)" $EVALUATOR_CONTRACT 20000000
```

Then, I had to call the `ex3_mintEvaluatorToken`:
```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $EVALUATOR_CONTRACT "ex3_mintEvaluatorToken()"
```

### Ex 4: Swap EvaluatorToken <> RewardToken from Uniswap contracts

I struggled on this exercice. Finally i let the implementation i had but i wasn't working so i decided to swap the tokens from the Uniswap Dapp to be allowed to continue this TD without being stuck here.

### Ex 5: Send RewardToken to the Evaluator smart contract

Here i needed to approve the Evaluator to transfer Reward Token from my wallet. To do so i approve the amount needed from my wallet to the Evaluator: 
```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $REWARD_CONTRACT "approve(address, uint)" $EVALUATOR_CONTRACT 10000000000000000000
```
Then i called the `ex5_checkRewardTokenBalance`: 
```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $EVALUATOR_CONTRACT "ex5_checkRewardTokenBalance()"
```


### Ex 6: Create a liquidity pool on uniswap V3 between my ERC20 tokens and some WETH

For this exercice i implemented the `createLiquidityPool` function inside my StudentToken.sol that use the Uniswap Factory contract.

Here is the address of the pool i created : 0x3301be34c97e9af6360def277ddcdddc135def48
Here is a proof it is a pool between an AST (my ERC20) and WETH : https://www.dextools.io/app/en/ethergoerli/pair-explorer/0x3301be34c97e9af6360def277ddcdddc135def48)
Here is a proof that it's a uniswap v3 pool : https://goerli.etherscan.io/address/0x3301be34c97e9af6360def277ddcdddc135def48

### Ex 7: Deploy an ERC721

I implemented a StudentNft.sol contract based on the interface IStudentNft.sol. For this step I imported openzeppelin lib to create my ERC721 and then i deployed StudentNft: 

```
forge script script/DeploymentERC721.sol:DeploymentScriptNFT --rpc-url $GOERLI_RPC_URL --broadcast --verify -vvvv
```

### Ex 8: Mint some ERC721 from Evaluator

I Implemented the `mint` function of StudentNft with the right require so that the Evaluator contract has to approve a certain amount of Evaluator's token as collateral before minting a NFT an then i called `ex8_mintNFT`:

```
cast send --private-key $PRIVATE_KEY --rpc-url $GOERLI_RPC_URL $EVALUATOR_CONTRACT "ex8_mintNFT()"
```


### Ex 9: Evaluator contract is admin of my ERC721 token

First i needed to approve the Evaluator to burn all of my tokens. I had an issue with it, even if i all the require inside the `ex9_burnNft` worked independentally (I tested them with cast commands) and my burn function worked on my side when i tried it with 2 addresses, the function wasn't working so i didn't achive to find why.

### Ex 10: Verify your smart contract on Etherscan and sourcify

For Etherscan I could verify a contract if it wasn't before with this cast command: 
```
forge verify-contract --chain-id $CHAIN_ID --etherscan-api-key $ETHERSCAN_API_KEY $MY_CONTRACT_ADDRESS path/to/contractName.sol:contractName
```

For Sourcify i found a command that was supposed to work:
```
forge verify-contract $MY_CONTRACT_ADDRESS src/StudentNft.sol:StudentNft --chain-id 5 --verifier sourcify
```


But i kept having the same error (when etherscan verification was working) :
```
Sourcify verification request for address ($MY_CONTRACT_ADDRESS) failed with status code 500 Internal Server Error
Details: {
  "error": "The deployed and recompiled bytecode don't match."
}
```

While trying to understand why I achieved to verify a contract manually on https://sourcify.dev/#/verifier so I did it like this. To check taht i was verified i did this: 
```
forge verify-check 0xc688Fc6352D3d771c0ff02849700fD26EF1b905A --chain-id 5 --verifier sourcify
```
(I let the contract's addresss if you want to verify) 
And it returned: 

```
Checking verification status on goerli
Contract successfully verified
```


## Ex 11: (Not so simply) call `ex11_unlock_ethers`

For this exercise I achieved to understand what was really asked. I needed to send ETH to the Evaluator with a certain message that would be : 0x73955a2bc62a4e5da2c27e3b2b4d804c3c9bcd0e136855c46565022e5838224c once hashed. I tried different things but didn't find the right message that would result on this hash. After that i should have called the `ex11_unlock_ethers` and it'll have refunded me what i gave him before (i would have 5h to call it otherwise i would have needed to resend a ETH).

### BONUS:
- I didn't try to make all the TD in one transaction
- I did automate the deployment in a script


-----------------------------------------
Deployed Addresses on goerli:
- [Evaluator contract](https://goerli.etherscan.io/address/0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE)
- [Reward contract](https://goerli.etherscan.io/address/0x56822085cf7C15219f6dC404Ba24749f08f34173)
