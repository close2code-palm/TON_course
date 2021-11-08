pragma ton-solidity >= 0.5.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

import './ShopListAbc.sol';
import './ShopListStructures.sol';

contract ShopList is HasConstructorWithPubKey  {
    
    mapping (uint32=>ToBuy) m_tobuys;
    uint32 toBuysCnt;


    modifier onlyOwner() {
        require(msg.pubkey() == m_ownerPubkey, 101, 'Only owner can do it.');
        _;
    }

    function addItem(string _naming, uint16 _amount) public {
        m_tobuys[toBuysCnt] = ToBuy(toBuysCnt ,_naming, _amount, now, false, 0);
        ++toBuysCnt;
        tvm.accept();
    }

    function deleteItem(uint32 _id) public {
        require(tobuys.exists(_id), 111, 'Not found.');
        tvm.accept();
        delete tobuys(_id);
    }

    function getList() view public returns (ToBuy_l[] l_tobuy) {

        for ((uint32 _iid, ToBuy tobuys) : m_tobuys) {
            l_tobuy.push(tobuys);
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