pragma ton-solidity <= 0.51.0;

pragma AbiHeader pubkey;
pragma AbiHeader expire;
pragma AbiHeader time;

import 'https://raw.githubusercontent.com/tonlabs/debots/main/Debot.sol';
import 'https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Menu/Menu.sol';
import 'https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Terminal/Terminal.sol';
import 'https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/Sdk/Sdk.sol';
import "https://raw.githubusercontent.com/tonlabs/DeBot-IS-consortium/main/AddressInput/AddressInput.sol";
import '../funcContracts/ShopListAbc.sol';

interface IMsig {
    function sendTransaction(address dest, uint128 value, bool bounce, uint8 flags, TvmCell payload  ) external;
}


abstract contract ADeBotShopingList is Debot {

    address deployAddress;
    TvmCell listCode;
    uint32 INITIAL_BALANCE = 100000000;
    uint256 masterPubKey;
    address masterWallet;

/// @notice point atfter list init, represents uer possibilitie
    function _menu() virtual internal {}

    function setListCode(TvmCell code) public {
        require(msg.pubkey() == tvm.pubkey(), 101);
        tvm.accept();
        listCode = code;
    }

/// @notice any interaction with debot starts here
    function start() public override {
        Terminal.input(tvm.functionId(savePubKey), "Enter your pubic key: ", false);
    }


    function savePubKey(string _pubk) public {
        (uint hKey, bool status) = stoi("0x" + _pubk);
        if (status) {
            masterPubKey = hKey;
            Terminal.print(0, "Checking for existing lists...");
            TvmCell deployState = tvm.insertPubkey(listCode, hKey);
            deployAddress = address.makeAddrStd(0, tvm.hash(deployState));
            Terminal.print(0, format("Your list contract address is {}", deployAddress));
            Sdk.getAccountType(tvm.functionId(accStatusBranching), deployAddress);
        } else {
            Terminal.input(tvm.functionId(savePubKey), "Wrong public key. Enter public key again!", false);
        }
    }

    function creditAccount(address value) public {
        masterWallet = value;
        optional(uint256) pubkey = 0;
        TvmCell empty;
        IMsig(masterWallet).sendTransaction{
            abiVer: 2,
            extMsg: true,
            sign: true,
            pubkey: pubkey,
            time: uint64(now),
            expire: 0,
            callbackId: tvm.functionId(waitBeforeDeploy),
            onErrorId: tvm.functionId(onErrorRepeatCredit)  // Just repeat if something went wrong
        }(masterWallet, INITIAL_BALANCE, false, 3, empty);
    }


    function onErrorRepeatCredit(uint32 sdkError, uint32 exitCode) public {
        sdkError;
        exitCode;
        creditAccount(masterWallet);
    }

    function waitBeforeDeploy() public  {
        Sdk.getAccountType(tvm.functionId(deployIf0rwait), masterWallet);
    }

    function accStatusBranching(int8 acc_type) public {
        if (acc_type == 1) { // acc is active and  contract is already deployed
            Terminal.print(0, format("You have shoplist allready at {}.", deployAddress));
        } else if (acc_type == -1)  { // acc is inactive
            Terminal.print(0, "You don't have a TODO list yet, so a new contract with an initial balance of 0.1 tokens will be deployed");
            AddressInput.get(tvm.functionId(creditAccount),"Select a wallet for payment. We will ask you to sign two transactions");
        } else  if (acc_type == 0) { // acc is uninitialized
            Terminal.print(0, format(
                "Deploying new contract. If an error occurs, check if your TODO contract has enough tokens on its balance"
            ));
            deploy();
        } else if (acc_type == 2) {  // acc is frozen
            Terminal.print(0, format("Can not continue: account {} is frozen", deployAddress));
        }
    }

    function deployIf0rwait(int8 acc_type) public {
        if (acc_type ==  0) {
            deploy();
        } else {
            waitBeforeDeploy();
        }
    }

    function deploy() private view {
            TvmCell image = tvm.insertPubkey(listCode, masterPubKey);
            optional(uint256) none;
            TvmCell deployMsg = tvm.buildExtMsg({
                abiVer: 2,
                dest: deployAddress,
                callbackId: tvm.functionId(onSuccess),
                onErrorId:  tvm.functionId(onErrorRepeatDeploy),    // Just repeat if something went wrong
                time: 0,
                expire: 0,
                sign: true,
                pubkey: none,
                stateInit: image,
                call: {HasConstructorWithPubKey, masterPubKey}
            });
            tvm.sendrawmsg(deployMsg, 1);
    }

    function onError(uint32 sdkError, uint32 exitCode) public {
        Terminal.print(0, format("Operation failed. sdkError {}, exitCode {}", sdkError, exitCode));
        _menu();
    }

    function onErrorRepeatDeploy(uint32 sdkError, uint32 exitCode) public {
        // TODO: check errors if needed.
        sdkError;
        exitCode;
        deploy();
    }

    function onSuccess() public {
        Terminal.print(0, "Keep on going.");
        _menu();
    }

    function getDebotInfo() public functionID(0xDEB) override view returns(
        string name, string version, string publisher, string key, string author,
        address support, string hello, string language, string dabi, bytes icon
    ) {
        name = "Shopman Debot";
        version = "0.0.1";
        publisher = "Juriax Golesshikov";
        key = "Intuitive control";
        author = "Juriax Golesshikov";
        support = address.makeAddrStd(0, 0x000000000000000000000000000000000000000000000000000000000000);
        hello = "Hello, let's shop.";
        language = "en";
        dabi = m_debotAbi.get();
        icon = '';
    }
    
    function getRequiredInterfaces() public view override returns (uint256[] interfaces) {
        return [ Terminal.ID, Sdk.ID, AddressInput.ID ];
    }
    
}