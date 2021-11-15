pragma ton-solidity >= 0.40.0;


pragma AbiHeader time;
pragma AbiHeader expire;
pragma AbiHeader pubkey;

import '../funcContracts/ShopListStructures.sol';
import './ADeBotShopingList.sol';

interface IShopList {
    function deleteItem(uint32 _id) external;
    function getList() external returns(ToBuy[] l_tobuy);
    function purchStat() external returns(BuysSummary allPurchStat);
}

contract ShopDebot is ADeBotShopingList {
    function deleteItem(string value) public view {
        (uint256 num,) = stoi(value);
        optional(uint256) pubkey = 0;
        IShopList(deployAddress).deleteItem{
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
        IShopList(deployAddress).getList{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(getList__),
            onErrorId: 0
        }();
    }

    function getList__(ToBuy[]  l_tobuy) public {
        uint32 i;
        if (l_tobuy.length > 0 ) {
            Terminal.print(0, "Your tasks list:");
            for (i = 0; i < l_tobuy.length; i++) {
                ToBuy itobuy = l_tobuy[i];
                string _bought;
                if (itobuy.bought) {
                    _bought = '✓';
                } else {
                    _bought ='x';
                }
            Terminal.print(0, format("{} {} {}  \"{}\"  at {}", itobuy.id, _bought, itobuy.price, itobuy.naming, itobuy.addedAt));
            }
        } else {
            Terminal.print(0, "Your tasks list is empty");
        }
        _menu();
    }

    function _purchStat(uint32 answerId) public view {
        optional(uint256) none;
        IShopList(deployAddress).purchStat{
            abiVer: 2,
            extMsg: true,
            sign: false,
            pubkey: none,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: 0
        }();
    }

    function _menu() override internal {
        Menu.select("General shoplist options", "", [
            MenuItem("Delete item", "", tvm.functionId(deleteItem)),
            MenuItem("Get info about all items", "", tvm.functionId(getList_)),
            MenuItem("Statisctics on your purchases", "", tvm.functionId(_purchStat))
        ]);
    }
}