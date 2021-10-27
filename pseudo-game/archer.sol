pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "./oop_realisation.sol";


contract Archer is CombatUnit(msg.sender) {

    uint8 lifeCells = 30;

    constructor()
    override //CombatUnit(BaseStationa 
    public {    
        // addArcher();
        // baseStationAddress.call(bytes4(keccak256("addArcher")));
        BaseStation baseAr = BaseStation(msg.sender);
        baseAr.addArcher();
    }

    function getAttack() pure public returns (uint8 attackPower) {
        return 25;
    }
    // atck  attack = 25;
    // defense = 10;
    
}
