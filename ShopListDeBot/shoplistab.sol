abstract contract HasConstructorWithPubKey {

    struct ToBuy {
        uint32 id;
        string naming;
        uint16 amount;
        uint32 addedAt;
        bool bought;
        optional(uint128) price;
    }

    struct BuysSummary {
        uint32 paid;
        uint32 unpaid;
        uint totalPrice;    
    }

    mapping (uint32=>ToBuy) m_tobuys;
    uint32 toBuysCnt;
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

    function addItem(string _naming, uint16 _amount) public {
        m_tobuys[toBuysCnt] = ToBuy(toBuysCnt, _naming, _amount, now, false, NaN);
        ++toBuysCnt;
        tvm.accept();
    }

    function deleteItem(uint32 _id) public {
        require(tobuys.exists(_id), 111, 'Not found.');
        tvm.accept();
        delete tobuys(_id);
    }

    function getList() view public returns (ToBuy[] l_tobuy) {
        string _naming;
        uint16 _amount;
        uint32 _creation_t;
        bool _bought;
        optional(uint128) _pricePaid;

        for ((uint32 _iid, ToBuy tobuys) : m_tobuys) {
            _naming = tobuys.naming;
            _amount = tobuys.amount;
            _creation_t = tobuys.addedAt;
            _bought = tobuys.bought;
            _pricePaid = tobuys.price;
            l_tobuy.push(ToBuy(iid, _naming, _amount, _creation_t, _bought, _pricePaid));
        }
        
    }
}