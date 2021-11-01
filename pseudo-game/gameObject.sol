pragma ton-solidity >= 0.5.0;
pragma AbiHeader expire;

import "./GameObjectInterface.sol";

abstract contract GameObject is GameObjectInterface {

    int16 internal lifeCells = 50;
    int16 constant internal defense_power = 17;

    event LoseOne(address owned, address eliminator, uint reward);

    function getDefense() 
    public 
    virtual 
    view 
    returns(int16 def) {
        return defense_power;
    }
    
    /// @notice figth math: how much damage your attack will cause through base's defense
    /// @dev may be its better to use signed variables? expr repeats
    /// @param damage is given from caller function
    function underAttack(int16 damage) external override {
        if (damage <= getDefense()) {
            revert(101, "your attack is too weak");
        } 
        int16 effectiveDamage = damage - getDefense();
        if (isLethal(lifeCells, effectiveDamage)) {
            death(msg.sender);
        } else {
            lifeCells -= effectiveDamage;
        }
    }

    function isLethal(int16 _cells, int16 _damage) internal pure returns (bool) {
        if (_cells <= _damage) {
            return true;
        } else {
            return false;
        }
        
    }

    function death(address _killed_by) public virtual {
        emit LoseOne(address(this), _killed_by, address(this).balance);
        _killed_by.transfer(160);
        tvm.accept();
    }

}