pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

import "./oop_realisation.sol";


contract Warrior is CombatUnit(msg.sender) {

    uint8 lifeCells = 40;

    constructor() override public {  
        BaseStation baseWr = BaseStation(msg.sender);
        baseWr.addWarrior();
    }

    function getAttack() public pure returns (uint8 attackPower) {
        return 30;
    } 
}
