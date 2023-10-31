// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;
pragma abicoder v2;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import 'uniswap/v3-periphery/contracts/interfaces/ISwapRouter.sol';
import 'uniswap/v3-periphery/contracts/libraries/TransferHelper.sol';

import {IStudentToken} from "./IStudentToken.sol";

contract StudentToken is ERC20, IStudentToken {

    address public RewardToken = 0x56822085cf7C15219f6dC404Ba24749f08f34173;
    address public EvaluatorToken = 0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE;
    uint public poolFee = 3000;  // Fee at 0.3%

    ISwapRouter public immutable swapRouter;
    uint public INITIAL_SUPPLY = 100000000000000000000000000;

    // _swapRouter is the Uniswap V3 Router contract's Address on goerli : 0xE592427A0AEce92De3Edee1F18E0157C05861564
    constructor(ISwapRouter _swapRouter) ERC20("AntoineSToken", "AST") {
        _mint(msg.sender, INITIAL_SUPPLY);
        _approve(
            address(this),
            0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE,
            INITIAL_SUPPLY
        );
        swapRouter = _swapRouter;
    }

    function createLiquidityPool() external {}

    function SwapRewardToken(uint256 amountOut, uint256 amountInMaximum) external returns (uint256 amountIn) {

        // Transfer the specified amount of EvaluatorToken to this contract.
        TransferHelper.safeTransferFrom(EvaluatorToken, msg.sender, address(this), amountInMaximum);

        // Approve the router to spend the specifed `amountInMaximum` of EvaluatorToken.
        // In production, you should choose the maximum amount to spend based on oracles or other data sources to acheive a better swap.
        TransferHelper.safeApprove(EvaluatorToken, address(swapRouter), amountInMaximum);

        ISwapRouter.ExactOutputSingleParams memory params =
            ISwapRouter.ExactOutputSingleParams({
                tokenIn: EvaluatorToken,
                tokenOut: RewardToken,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: amountOut,
                amountInMaximum: amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        // Executes the swap returning the amountIn needed to spend to receive the desired amountOut.
        amountIn = swapRouter.exactOutputSingle(params);

        // For exact output swaps, the amountInMaximum may not have all been spent.
        // If the actual amount spent (amountIn) is less than the specified maximum amount, we must refund the msg.sender and approve the swapRouter to spend 0.
        if (amountIn < amountInMaximum) {
            TransferHelper.safeApprove(EvaluatorToken, address(swapRouter), 0);
            TransferHelper.safeTransfer(EvaluatorToken, msg.sender, amountInMaximum - amountIn);
        }

        return amountIn;
    }
}
