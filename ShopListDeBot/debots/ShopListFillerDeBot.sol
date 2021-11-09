pragma ton-solidity >= 0.51.0;
pragma AbiHeader time;

import './ADeBotShopingList.sol';
import "https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/ConfirmInput/ConfirmInput.sol";

interface IFiller {
    function addItem(string _naming, uint16 _amount) external;
}

contract ShopListFillerDeBot is ADeBotShopingList {

    string private add_naming;
    
    function addItem(uint32 index) public {
        Terminal.input(tvm.functionId(addItem_), "Enter item's name:", false);
    }

    function addItem_(string naming_) public {
        add_naming = naming_;
        ConfirmInput.get(tvm.functionId(addItem__), "How much is needed?");
    }

    function addItem__(uint16 amount_) public {
        optional(uint256) pubkey = 0;
        IFiller(deployAddress).addItem{
            abiVer:2,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(add_naming, 
        amount_).extMsg;
    }

    function _menu() internal override {
        Menu.select("Fill the list", "Smart-contract purposed for planning future shopping" , [
            MenuItem("Add item", "", tvm.functionId(addItem))
        ]);
    }
}