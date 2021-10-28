pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;
import './exampleWallet.sol';

contract HotWallet is Wallet {

    function denom(address dst) public checkOwnerAndAccept {
        uint16 flag = 160;
        dst.transfer(flag);
    }

    function send_wo_comsn(address dst, uint128 quantity) public checkOwnerAndAccept {
        uint16 flag = 0;
        dst.transfer(quantity, true, flag);
    }

    function send_w_comsn(address dst, uint128 quantity) public checkOwnerAndAccept {
        uint16 flag = 1;
        dst.transfer(quantity, true, flag);
    }

} 