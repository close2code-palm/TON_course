pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./combatUnit.sol";
import './baseStation.sol';


contract Archer is CombatUnit(msg.sender) {

    constructor()
    override //CombatUnit(BaseStationa 
    public {    
        lifeCells = 30;
        // baseStationAddress.call(bytes4(keccak256("addArcher")));
        BaseStation baseAr = BaseStation(msg.sender);
        baseAr.addUnit(this);
    }

    function getAttack() pure public override returns (uint8 attackPower) {
        return 25;
    }

    function getDefense() pure override public returns (uint8) {
        return 6;
    }
}
