pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import './gameObject.sol';
import './IFieldCleaner.sol';

abstract contract CombatUnit is GameObject {

    address internal baseStationAddress;
    uint8 internal attack;

    // this technic makes possible authorization of basestations
    function struckByUnit() pure public returns(uint attackingCodeHash) {
        attackingCodeHash = tvm.hash(tvm.code());
    }

    modifier commandsFromBase {
        require(msg.sender == baseStationAddress, 
        102, 
        "Only my basestation can command");
        _;
    }

    function getAttack() view public returns (uint8) {
        return attack;
    }

    function death(address name) commandsFromBase override public {  
        IFieldCleaner(baseStationAddress).removeCorpse(address(this));
    }

    function doAttack(address _target) public virtual {
        CombatUnit target = CombatUnit(_target);
        target.underAttack(getAttack());
    }

}
