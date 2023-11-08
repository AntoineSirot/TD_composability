// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;
pragma abicoder v2;

import {ERC20} from "openzeppelin-contracts/contracts/token/ERC20/ERC20.sol";
import "v3-core/contracts/interfaces/IUniswapV3Factory.sol";

import {IStudentToken} from "./IStudentToken.sol";

contract StudentToken is ERC20, IStudentToken {
    address public constant RewardToken =
        0x56822085cf7C15219f6dC404Ba24749f08f34173;
    address public constant EvaluatorToken =
        0x5cd93e3B0afBF71C9C84A7574a5023B4998B97BE;
    address public constant WETHAddress =
        0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6;
    uint24 public constant poolFee = 0; // Fee at 0%

    ISwapRouter constant swapRouter =
        ISwapRouter(0xE592427A0AEce92De3Edee1F18E0157C05861564);
    IUniswapV3Factory constant uniswapFactory =
        IUniswapV3Factory(0x1F98431c8aD98523631AE4a59f267346ea31F984);
    uint public INITIAL_SUPPLY = 100000000 * 10 ** 18;

    constructor() ERC20("AntoineSToken", "AST") {
        _mint(msg.sender, INITIAL_SUPPLY);
        _approve(address(this), EvaluatorToken, 10000000);
    }

    function createLiquidityPool() external returns (address) {
        address newPoll = uniswapFactory.createPool(
            address(this),
            WETHAddress,
            3000
        );

        return newPoll;
    }

    function SwapRewardToken(
        uint256 _amountOut,
        uint256 _amountInMaximum
    ) external returns (uint256 amountIn) {
        IERC20(EvaluatorToken).transferFrom(
            msg.sender,
            address(this),
            amountIn
        );
        IERC20(EvaluatorToken).approve(address(swapRouter), amountIn);

        ISwapRouter.ExactOutputSingleParams memory params = ISwapRouter
            .ExactOutputSingleParams({
                tokenIn: EvaluatorToken,
                tokenOut: RewardToken,
                fee: poolFee,
                recipient: msg.sender,
                deadline: block.timestamp,
                amountOut: _amountOut,
                amountInMaximum: _amountInMaximum,
                sqrtPriceLimitX96: 0
            });

        amountIn = swapRouter.exactOutputSingle(params);

        if (amountIn < _amountInMaximum) {
            IERC20(EvaluatorToken).approve(address(swapRouter), 0);

            IERC20(EvaluatorToken).transfer(
                msg.sender,
                _amountInMaximum - amountIn
            );
        }

        return amountIn;
    }
}

interface IERC20 {
    function totalSupply() external view returns (uint);

    function balanceOf(address account) external view returns (uint);

    function transfer(address recipient, uint amount) external returns (bool);

    function allowance(
        address owner,
        address spender
    ) external view returns (uint);

    function approve(address spender, uint amount) external returns (bool);

    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint value);
    event Approval(address indexed owner, address indexed spender, uint value);
}

interface IUniswapV3SwapCallback {
    /// @notice Called to `msg.sender` after executing a swap via IUniswapV3Pool#swap.
    /// @dev In the implementation you must pay the pool tokens owed for the swap.
    /// The caller of this method must be checked to be a UniswapV3Pool deployed by the canonical UniswapV3Factory.
    /// amount0Delta and amount1Delta can both be 0 if no tokens were swapped.
    /// @param amount0Delta The amount of token0 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token0 to the pool.
    /// @param amount1Delta The amount of token1 that was sent (negative) or must be received (positive) by the pool by
    /// the end of the swap. If positive, the callback must send that amount of token1 to the pool.
    /// @param data Any data passed through by the caller via the IUniswapV3PoolActions#swap call
    function uniswapV3SwapCallback(
        int256 amount0Delta,
        int256 amount1Delta,
        bytes calldata data
    ) external;
}

interface ISwapRouter is IUniswapV3SwapCallback {
    struct ExactOutputSingleParams {
        address tokenIn;
        address tokenOut;
        uint24 fee;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
        uint160 sqrtPriceLimitX96;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another token
    /// @param params The parameters necessary for the swap, encoded as `ExactOutputSingleParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutputSingle(
        ExactOutputSingleParams calldata params
    ) external payable returns (uint256 amountIn);

    struct ExactOutputParams {
        bytes path;
        address recipient;
        uint256 deadline;
        uint256 amountOut;
        uint256 amountInMaximum;
    }

    /// @notice Swaps as little as possible of one token for `amountOut` of another along the specified path (reversed)
    /// @param params The parameters necessary for the multi-hop swap, encoded as `ExactOutputParams` in calldata
    /// @return amountIn The amount of the input token
    function exactOutput(
        ExactOutputParams calldata params
    ) external payable returns (uint256 amountIn);
}
