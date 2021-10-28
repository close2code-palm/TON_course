pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./combatUnit.sol";
import './baseStation.sol';


contract Warrior is CombatUnit(msg.sender) {

    constructor() override public { 
        defense = 11;
        lifeCells = 40; 
        BaseStation baseWr = BaseStation(msg.sender);
        baseWr.addUnit(this);
    }

    function getAttack() public pure override returns (uint8 attackPower) {
        return 30;
    } 
}
