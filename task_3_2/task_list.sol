pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

contract TaskList {

    struct task {
        string name;
        bool done;
        uint32 added_at;
    }


    uint8 taskIds;
    mapping (uint8=>task) task_ids;

    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();
    }


    function add_task(string _name) public {
        uint8 task_id = taskIds++;
        task t = task_ids[task_id];
        t.name = _name;
        t.added_at = now;
        tvm.accept();
    }


    function get_undone() public returns (string[]) {
        string[] undones;
        for(uint8 i = 0; i < taskIds; i++){
            if(task_ids[i].done != true){
                undones.push(task_ids[i].name);
            }
        }
        return undones;
    }


    function rem_by_k(uint8 _key) public {
        delete task_ids[_key];
        tvm.accept();
    }

    function get_descr(uint8 _key) public view returns (string) {
        return task_ids[_key].name;
        tvm.accept();
    }

    function ncmark_as_compl(uint8 _key) public {
        task_ids[_key].done = true;
        tvm.accept();
    }
}