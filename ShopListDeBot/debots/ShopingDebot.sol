pragma ton-solidity >= 0.40.0;

import 'ADeBotShopingList.sol';

/// @dev calling to function buy of Shoplist contract
interface IShopping {
    function buy(uint32 _id, uint128 _price) external;
}

/// @title Buying Listed
/// @dev _menu func doesnt provide menu functionality
/// @notice represents buy function state 
contract ShopingDebot is ADeBotShopingList {

/// @notice id of item user wants to buy
/// @dev there is no other than function and contract variable scopes in ton-sol, as seems so far
    uint32 private buy_id;
    
/// @notice menu with one "dish"
/// @dev just in case of code reuse we loose a bit of sense in func title
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
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(buy_id, price);
    }
}