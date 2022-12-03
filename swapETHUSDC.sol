pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

// Import the IUniswapV2Pair interface
import "https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol";

contract ETHUSDCSwap {

  // address of the contract owner
  address public owner;

  //  address of the Uniswap pair contract for ETH-USDC
  IUniswapV2Pair public pair;

  //  contract's USDC balance
  uint256 public balance;

  // The USDC contract
  ERC20 public usdc;

  // Event emitted when a swap occurs
  event Swap(
    address indexed _from,
    uint256 _ethAmount,
    uint256 _usdcAmount
  );

  constructor(address _pair, address _usdc) public {
    // Set the contract owner to the address that deployed the contract
    owner = msg.sender;

    // Set the Uniswap pair contract address
    pair = IUniswapV2Pair(_pair);

    // Set the USDC contract address
    usdc = ERC20(_usdc);
  }

  // Swap 1 ETH for the equivalent amount of USDC, for example
  function swap() public payable {
    // Ensure that the contract has been sent at least 1 ETH
    require(msg.value == 1 ether, "Must send 1 ETH to swap"); // latter error message

    // Calculate the amount of USDC that will be received in the swap
    uint256 usdcAmount = pair.getAmountOut(1 ether);

    // Execute the swap by transferring 1 ETH to the Uniswap pair contract and
    // receiving the equivalent amount of USDC
    (bool success, ) = pair.swap(1 ether, usdcAmount, usdc.address);
    require(success, "Unable to execute swap");

    // Increase the contract's USDC balance by the amount received in the swap
    balance = balance.add(usdcAmount);

    // Emit a Swap event
    emit Swap(msg.sender, 1 ether, usdcAmount);
  }

  // Withdraw the contract's USDC balance to the contract owner
  function withdraw() public {
    // Transfer the contract's USDC balance to the contract owner
    usdc.transfer(owner, balance);

    // Decrease the contract's USDC balance to zero
    balance = 0;
  }
}