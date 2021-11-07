pragma ton-solidity >= 0.5.0;
pragma AbiHeader pubkey;
pragma AbiHeader expire;

import 'https://raw.githubusercontent.com/tonlabs/debots/main/Debot.sol';
import 'https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Menu/Menu.sol';
import 'https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Terminal/Terminal.sol';
import 'https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Sdk/Sdk.sol';

interface IMsig {
    function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload  ) external;
}

interface IShopList {
    function deleteItem(uint32 _id) external;
    function getList() external returns(ToBuy_l[] l_tobuy);
    function purchStat() external returns(BuysSummary purchStat);
}

abstract contract ADeBotShopingList is Debot {

    TvmCell listCode;
    uint32 INITIAL_BALANCE = 100000000;

    function setListCode(TvmCell _code) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        listCode = _code;
    }

    function savePubKey(string _pubk) public {
        (uint hKey, bool status) = stoi("0x" + _pubk);
        if (status) {
            Terminal.print(0, "Checking for existing lists...");
            TvmCell deployState = tvm.insertPubkey(listCode, hKey);
            deployAddress = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format("Your list contract address is {}"), deployAddress);
            Sdk.getAccountType(tvm.functionId(checkStatus), deployAddress);
        } else {
            Terminal.input(tvm.functionId(savePubKey), "Wrong public key. Enter public key again!", false);
        }
    }

    function creditAccount(address value) public {
        m_msigAddress = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        IMsig(m_msigAddress).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit)  // Just repeat if something went wrong
        }(m_address, INITIAL_BALANCE, false, 3, empty);
    }

    function waitBeforeDeploy() public  {
        Sdk.getAccountType(tvm.functionId(checkIfStatusIs0), m_address);
    }

    function checkIfStatusIs0(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitBeforeDeploy();
        }
    }

    function deploy() private view {
            TvmCell image = tvm.insertPubkey(m_todoCode, m_masterPubKey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: m_address,
                callbackId: tvm.functionId(onSuccess),
                onErrorId:  tvm.functionId(onErrorRepeatDeploy),    // Just repeat if something went wrong
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {ATodo, m_masterPubKey}
            });
            tvm.sendrawmsg(deployMsg, 1);
    }


    function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public view {
        // TODO: check errors if needed.
        sdkError;
        exitCode;
        deploy();
    }

    function onSuccess() public view {
        _getStat(tvm.functionId(setStat));
    }
}