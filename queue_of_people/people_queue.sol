pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract ShopQueue {

    string[] private shop_queue;
    string private name;
    uint8 private queue_base_pointer = 0;

    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();
    }

    function get_in_queue(string new_name) public {
        shop_queue.push(new_name);
        tvm.accept();
    }

    function get_from_queue() public returns (string) {
        string _name = shop_queue[queue_base_pointer];
        delete shop_queue[queue_base_pointer];
        queue_base_pointer++;
        return _name;
        tvm.accept();
    }
}