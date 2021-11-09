pragma ton-solidity >= 0.40.0;

pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

import './ShopListAbc.sol';
import './ShopListStructures.sol';


contract ShopList  {
    
    uint ownerPubkey;

    constructor(uint _pubkey) public override { 
        require(_pubkey != 0, 120);
        tvm.accept();
        ownerPubkey = _pubkey;
    }

    mapping (uint32=>ToBuy) m_tobuys;
    uint32 toBuysCnt;


    modifier onlyOwner() {
        require(msg.pubkey() == ownerPubkey, 101, 'Only owner can do it.');
        _;
    }

    function addItem(string _naming, uint16 _amount) public {
        m_tobuys[toBuysCnt] = ToBuy(toBuysCnt ,_naming, _amount, now, false, 0);
        ++toBuysCnt;
        tvm.accept();
    }

    function deleteItem(uint32 _id) public {
        require(m_tobuys.exists(_id), 111, 'Not found.');
        tvm.accept();
        delete m_tobuys[_id];
    }

    function getList() view public returns (ToBuy[] l_tobuy) {

        for ((uint32 _iid, ToBuy tobuys) : m_tobuys) {
            l_tobuy.push(tobuys);
        }
        
    }

    function buy(uint32 _id ,uint128 _price) public {
        optional(ToBuy) o_buyItem = m_tobuys[_id];
        require(o_buyItem.hasValue(), 117, 'No item in list with this id');
        tvm.accept();
        ToBuy buyItem = o_buyItem.get();
        buyItem.bought = true;
        buyItem.price = _price;
        m_tobuys[_id] = buyItem;
    }

    function purchStat() public returns(BuysSummary purchStats) {
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