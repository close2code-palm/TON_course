struct ToBuy {
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

struct ToBuy_l {
        uint32 id;
        string naming;
        uint16 amount;
        uint32 addedAt;
        bool bought;
        uint128 price;
}


abstract contract HasConstructorWithPubKey {

    
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
        m_tobuys[toBuysCnt] = ToBuy(_naming, _amount, now, false, 0);
        ++toBuysCnt;
        tvm.accept();
    }

    function deleteItem(uint32 _id) public {
        require(tobuys.exists(_id), 111, 'Not found.');
        tvm.accept();
        delete tobuys(_id);
    }

    function getList() view public returns (ToBuy_l[] l_tobuy) {
        string _naming;
        uint16 _amount;
        uint32 _creation_t;
        bool _bought;
        uint128 _pricePaid;

        for ((uint32 _iid, ToBuy tobuys) : m_tobuys) {

            ToBuy_l tbli = (_iid, tobuys.unpack()); 
            // _naming = tobuys.naming;
            // _amount = tobuys.amount;
            // _creation_t = tobuys.addedAt;
            // _bought = tobuys.bought;
            // _pricePaid = tobuys.price;
            // l_tobuy.push(ToBuy(iid, _naming, _amount, _creation_t, _bought, _pricePaid));
            l_tobuy.push(tbli);
        }
        
    }

    function buy(uint32 _id ,uint128 _price) public {
        ToBuy buyItem = m_tobuys[_id];
        require(buyIt.hasValue(), 117, 'No item in list with this id');
        tvm.accept();
        buyItem.bought = true;
        buyItem.price = _price;
        m_tobuys[_id] = buyItem;
    }

    function purchStats() public returns(BuysSummary purchStats) {
        purchStats = BuysSummary(0,0,0);
        for ((uint32 id, ToBuy tl_tobuys) : m_tobuys) {
            if (tl_tobuys.bought = true) {
                ++purchStats.paid;
                purchStats.totalPrice += tl_tobuys.price;
            } else {
                ++purchStats.notPaid;
            }
        }
    }
}