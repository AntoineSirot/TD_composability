// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {IERC20} from "openzeppelin-contracts/contracts/token/ERC20/IERC20.sol";

interface IStudentToken is IERC20 {
    function createLiquidityPool() external;

    function SwapRewardToken() external;
}
