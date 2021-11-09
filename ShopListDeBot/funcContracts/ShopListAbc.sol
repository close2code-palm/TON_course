pragma ton-solidity >= 0.40.0;

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

    uint internal m_ownerPubkey;

    constructor(uint _pubkey) virtual public {}
}
