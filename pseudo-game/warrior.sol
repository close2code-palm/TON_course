pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./combatUnit.sol";
import './baseStation.sol';


contract Warrior is CombatUnit {

    constructor(address baseSide) 
    override 
    public { 
        attack = 30;
        lifeCells = 40; 
        BaseStation baseWr = BaseStation(baseSide);
        baseWr.addUnit(this);
        tvm.accept();
    }

}
