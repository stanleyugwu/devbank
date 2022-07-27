// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

/*
 * This exercise has been updated to use Solidity version 0.8.5
 * See the latest Solidity updates at
 * https://solidity.readthedocs.io/en/latest/080-breaking-changes.html
 */
// pragma experimental ABIEncoderV2;

contract SimpleBank {

    /* State variables
     */
    
    
    // Fill in the visibility keyword. 
    // Hint: We want to protect our users balance from other contracts
    mapping (address => uint) private  balances;
    
    // Fill in the visibility keyword
    // Hint: We want to create a getter function and allow contracts to be able
    //       to see if a user is enrolled.
    mapping (address => bool) public enrolled;

    // Let's make sure everyone knows who owns the bank, yes, fill in the
    // appropriate visilibility keyword
    address public owner = msg.sender;
    
    /* Events - publicize actions to external listeners
     */

    
    // Add an argument for this event, an accountAddress
    event LogEnrolled(address accountAddress);

    // Add 2 arguments for this event, an accountAddress and an amount
    event LogDepositMade(address accountAddress, uint amount);

    // Create an event called LogWithdrawal
    // Hint: it should take 3 arguments: an accountAddress, withdrawAmount and a newBalance 
    event LogWithdrawal(address accountAddress, uint withdrawAmount, uint newBalance);

    /* Functions
     */

    // Fallback function - Called if other functions don't match call or
    // sent ether without data
    // Typically, called when invalid data is sent
    // Added so ether sent to this contract is reverted if the contract fails
    // otherwise, the sender's money is transferred to contract


    /// @notice Get balance
    /// @return The balance of the user
    function getBalance() public view returns (uint) {
      
      // 1. ADD A SPECIAL KEYWORD that prevents function from editing state variables;
      //    allows function to run locally/off blockchain
      // 2. Get the balance of the sender of this transaction
      return balances[msg.sender];
    }

    /// @notice Enroll a customer with the bank
    /// @return The users enrolled status
    // Emit the appropriate event
    function enroll() public returns (bool){
      emit LogEnrolled(msg.sender);
      return enrolled[msg.sender] = true;
    }

    /// @notice Deposit ether into bank
    /// @return The balance of the user after the deposit is made
    function deposit() public payable returns (uint) {
      address depositor = msg.sender;
      // Ensure depositor is enrolled
      require(enrolled[depositor], "You should be enrolled before you can make deposit");
      // Ensure deposit amount is greater than 0
      require(msg.value > 0, "Insufficient deposit amount");
      // update depositor's balance
      uint depositorsBalance = balances[depositor]+=msg.value;
      // emit deposit event
      emit LogDepositMade(depositor, msg.value);
      // return new balance
      return depositorsBalance;


      // Hint 
      // 1. Add the appropriate keyword so that this function can receive ether
      // 2. Users should be enrolled before they can make deposits
            // -- Hint
            // Use a require expression to guard/ensure sender has enough funds
      // 3. Add the amount to the user's balance. Hint: the amount can be
      //    accessed from on of the global variable `msg`

      // 4. Emit the appropriate event associated with this function

      // 5. return the balance of sender of this transaction

    }

    /// @notice Withdraw ether from bank
    /// @dev This does not return any excess ether sent to it
    /// @param withdrawAmount amount you want to withdraw
    /// @return The balance remaining for the user
    function withdraw(uint withdrawAmount) public returns (uint) {
      address payable withdrawer = payable(msg.sender);
      // Ensure withdrawer has up to the requested withdrawal amount 
      require(balances[withdrawer] >= withdrawAmount, "You can't withdraw more than you have deposited");
      // Deducts withdrawn amount from withdrawer's acct and return balance
      uint withdrawersBalance = balances[withdrawer]-=withdrawAmount;
      // send requested amount to withdrawer
      // transfer has to be made after deducting withdrawer's balance to prevent re-entracy
      withdrawer.transfer(withdrawAmount);
      // emit withdraw event
      emit LogWithdrawal(withdrawer, withdrawAmount, withdrawersBalance);
      // return withdrawer's balance
      return withdrawersBalance;
      
      // If the sender's balance is at least the amount they want to withdraw,
      // Subtract the amount from the sender's balance, and try to send that amount of ether
      // to the user attempting to withdraw. 
      // return the user's balance.

      // 1. Use a require expression to guard/ensure sender has enough funds

      // 2. Transfer Eth to the sender and decrement the withdrawal amount from
      //    sender's balance

      // 3. Emit the appropriate event for this message
    }
}
