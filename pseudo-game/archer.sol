pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./combatUnit.sol";


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

    function getAttack() pure public override returns (uint8 attackPower) {
        return 25;
    }

    function getDefense() pure override public returns (uint8) {
        return 6;
    }
    // atck  attack = 25;
    // defense = 10;
    
}
