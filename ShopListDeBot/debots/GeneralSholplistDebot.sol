
interface IShopList {
    function deleteItem(uint32 _id) external;
    function getList() external returns(ToBuy_l[] l_tobuy);
    function purchStat() external returns(BuysSummary purchStat);
}

contract ShopDebot is ADeBotShopingList {
    function deleteItem(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        ITodo(m_address).deleteTask{
                abiVer: 2,
                extMsg: true,
                sign: true,
                pubkey: pubkey,
                time: uint64(now),
                expire: 0,
                callbackId: tvm.functionId(onSuccess),
                onErrorId: tvm.functionId(onError)
            }(uint32(num));
    }

    function getList_() public view {
        optional(uint256) none;
        ITodo(m_address).getList{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(getList__),
            onErrorId: 0
        }();

    function getList__( ToBuy_l[]  l_tobuy) public {
        uint32 i;
        if (tasks.length > 0 ) {
            Terminal.print(0, "Your tasks list:");
            for (i = 0; i < l_tobuy.length; i++) {
                ToBuy_l itobuy = l_tobuy[i];
                string bought;
                if (itobuy.bought) {
                    bought = itobuy.price;
                } else {
                    bought = ' ';
                }
                Terminal.print(0, format("{} {}  \"{}\"  at {}", itobuy.id, bought, itobuy.naming, itobuy.addedAt));
            }
        } else {
            Terminal.print(0, "Your tasks list is empty");
        }
        _menu();
    }

    function _purchStat(uint32 answerId) private view {
        optional(uint256) none;
        ITodo(m_address).purchStat{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: answerId,
            onErrorId: 0
        }();
}