import './ADeBotShopingList.sol';

interface IFiller {
    function addItem(string _naming, uint16 _amount) external;
}

contract ShopListFillerDeBot is ADeBotShopingList {
    
    function addItem(index) public {
        Terminal.input(tvm.functionId(addItem_), "Enter item's name:", false);
    }

    function addItem_(string naming_) public {
        ConfirmInput.get(tvm.functionId(addItem__), "How much is needed?");
    }

    function addItem__(uint16 amount_) public {
        IFiller(deployAddress).addItem{
            abiVer:2,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(onSuccess),
            onErrorId: tvm.functionId(onError)
        }(naming_, amount_).extMsg;
    }
}