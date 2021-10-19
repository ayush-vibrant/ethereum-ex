pragma solidity ^0.4.18;

contract Deal {

  /// The seller's address
  address public from;

  /// The buyer's address part on this contract
  address public to;

  /// The Transaction struct
  struct Transaction {
    address to;
    address from;
    string orderId;
    string orderPlatform; /// TODO: mark it as constant later
    string productSno;

    bool init;
  }

  /// The mapping to store transactions
  mapping (uint => Transaction) transactions;

  /// The sequence number of transactions
  uint transactionseq;

  /// Event triggered when the seller sends the invoice
  event TransactionSent(address indexed from, address to, uint transaction_no, uint transaction_date);


  /// The smart contract's constructor
  function Deal(address _buyerAddr) public payable {
    
    /// The seller is the contract's owner
    from = msg.sender;

    to = _buyerAddr;
  }


  /// The function to send the transaction data
  ///  requires fee
  function sendTransaction(uint transaction_no, string order_id, string product_sno, uint transaction_date, address buyer) payable public {

    /// Validate the transaction number
    require(transactions[transaction_no].init);

    /// Just the seller can send the invoice
    require(from == msg.sender);

    transactionseq++;

    /// Create then Transaction instance and store it
    transactions[transactionseq] = Transaction(buyer, msg.sender, order_id, "OLX", product_sno, true);

    /// Update the shipment data TODO: Check this!!
    /// orders[orderno].shipment.date    = delivery_date;
    /// orders[orderno].shipment.courier = courier;

    /// Trigger the event
    TransactionSent(msg.sender, to, transactionseq, transaction_date);
  }


  /// The function to get the sent transaction
  ///  requires no fee
  function getTransaction(uint transaction_no) constant public
  returns (address buyer, address seller, string orderId, string orderPlatform, string productSno){

    /// Validate the transaction number
    require(transactions[transaction_no].init);

    Transaction storage _transaction = transactions[transaction_no];
    /// Order storage _order     = orders[_invoice.orderno];

    return (_transaction.to, _transaction.from, _transaction.orderId, _transaction.orderPlatform, _transaction.productSno);
  }

  function health() pure public returns (string) {
    return "running";
  }
}
