struct ToBuy {
        uint32 id;
        string naming;
        uint16 amount;
        uint32 addedAt;
        bool bought;
        uint128 price;
    }

struct BuysSummary {
    uint32 paid;
    uint32 notPaid;
    uint totalPrice;    
}


abstract contract HasConstructorWithPubKey {

    constructor(uint _pubkey) public { 
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = _pubkey;
    }
}
