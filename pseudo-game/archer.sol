pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./combatUnit.sol";
import './baseStation.sol';


contract Archer is CombatUnit {

    constructor(address baseSide)
    override // CombatUnit(address baseC)
    public {    
        attack = 25;
        lifeCells = 30;
        BaseStation baseAr = BaseStation(baseSide);
        baseAr.addUnit(this);
        tvm.accept();
    }

}
