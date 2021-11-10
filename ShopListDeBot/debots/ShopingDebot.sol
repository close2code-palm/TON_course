pragma ton-solidity >= 0.40.0;

import 'ADeBotShopingList.sol';


interface IShopping {
    function buy(uint32 _id, uint128 _price) external;
}

contract ShopingDebot is ADeBotShopingList {


    uint32 private buy_id;
    

    function _menu() internal override {
        Terminal.input(tvm.functionId(buy__), "Enter id of purchase.", false);
    }

    function buy__(uint32 _iid) public {
        buy_id = _iid;
        Terminal.input(tvm.functionId(buy__f), "Enter the price you paid.", false);
    }

    function buy__f(uint128 price) public {
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