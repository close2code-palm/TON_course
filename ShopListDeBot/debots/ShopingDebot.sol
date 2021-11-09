import 'ADeBotShopingList.sol';



interface IShopping {
    function buy(uint32 _id, uint128 _price) external;
}

contract ShopingDebot {

    uint32 private buy_id;

    function _menu() internal {
        Terminal.input(tvm.functionId(buy), "Enter id of purchase.", false);
    }

    function buy__(uint32 _iid) private {
        buy_id = _iid;
        Terminal.input(tvm.functionId(buy__f), "Enter the price you paid.", false);
    }

    function buy__f(uint128 price) private {
        optional(uint) pubkey = 0;
        IShopping(deployAddress).buy{
            abiVer: 2,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(buy_id, price).extMsg;
    }
}