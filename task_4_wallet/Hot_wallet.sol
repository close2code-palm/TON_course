pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import 'https://github.com/tonlabs/samples/blob/master/solidity/10_Wallet.sol' as dWallt;

contract HotWallet is dWallt {

    function denom(address dst) public checkOwnerAndAccept {
        uint16 flag = 160;
        dst.transfer(flag);
    }

    function send_wo_comsn(address dst, uint quantity) public checkOwnerAndAccept {
        uint16 flag = 0;
        dst.transfer(quantity, true, flag);
    }

    function send_w_comsn(address dst, uint128 quantity) public checkOwnerAndAccept {
        uint16 flag = 1;
        dst.transfer(quantity, true, flag);
    }

} 