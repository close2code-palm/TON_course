abstract contract HasConstructorWithPubKey {
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
        uint32 unpaid;
        uint totalPrice;    
    }

    ToBuy[] tobuys;
    uint m_ownerPubkey;

    constructor(uint _pubkey) public { 
        require(pubkey != 0, 120);
        tvm.accept();
        m_ownerPubkey = _pubkey;
    }

    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101, 'Only owner can do it.');
        _;
    }
}