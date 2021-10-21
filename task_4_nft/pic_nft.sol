pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract Artisty {

    struct PicNFT {
        uint8 id;
        string name;
        bytes code;
        string[] meaning;
        address creator;
    }
    
    uint8 id_cnt;
    mapping (string => uint) on_sale;
    PicNFT[] pic_collection;

    function isUnique (string _name) private returns (bool) {
        for (uint8 i = 0; i < pic_collection.length; i++) {
            if (pic_collection[i].name == _name) {
                return false;
            }
        }
        return true;
    }


    function create_nft(string _name, bytes _code, 
    string[] _descrtn) public {
        require(isUnique(_name), 101, "NFT with this name allready exists.");
        uint8 n_id = id_cnt++;
        pic_collection.push(PicNFT(n_id ,_name, _code, _descrtn, msg.sender));
    }

    modifier only_creator(uint8 _id) {
        if (pic_collection[_id].creator == msg.sender) {
            _;
        }
    }

    //uint8 id; //fixed smart completion error by declaring outside
    function put_up_for_sale(uint8 id, uint price) 
    public only_creator(id) {
        on_sale[pic_collection[id].name] = price;
    }
}