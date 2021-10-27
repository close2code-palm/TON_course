pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./combatUnit.sol";


contract Warrior is CombatUnit(msg.sender) {

    uint8 lifeCells = 40;

    constructor() override public {  
        BaseStation baseWr = BaseStation(msg.sender);
        baseWr.addWarrior();
    }

    function getAttack() public pure override returns (uint8 attackPower) {
        return 30;
    } 
}
