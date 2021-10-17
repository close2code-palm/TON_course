pragma ton-solidity >= 0.32.0;
pragma AbiHeader expire;

contract ProductStore {

    uint public product = 1;
    //uint multiplier;

    constructor() public {
        require(tvm.pubkey() != 0, 101);
        require(msg.pubkey() == tvm.pubkey(), 102);
        tvm.accept();
    }

//variable should be in range from 1 to 10
    // modifier check_tenity(uint _multiplier) {
    //     require(_multiplier > 0 && _multiplier < 11, 110, "multiplier not in rel");
    //     tvm.accept();
    //     _;
    // }

    // function mul() public check_tenity(_multiplier) {
    //     product *= _multiplier;
    // }

    function mul_simplier(uint8 _multer) public {
        require(_multer >= 1 && _multer <= 10, 111, "in range from 1 to 10, please");
        product *= _multer;
        tvm.accept();
    }
}