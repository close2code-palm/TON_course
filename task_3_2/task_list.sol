pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;


contract TaskList {

    struct task {
        string name;
        bool done;
        uint32 added_at;
    }


    uint8 task_ids_cnt;
    mapping (uint8=>task) task_ids;
    string[] public tsk_descrptns;

//super duper default constructor
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


    function add_task_by_name(string _name) public {
        uint8 t_id = task_ids_cnt++;
        task tsk = task(_name, false, now);
        task_ids[t_id] = tsk;
        tvm.accept();
    }
//worked in tests, returns id
    function add_task(string _name) public returns(uint8) {
        uint8 task_id = task_ids_cnt++;
        task t = task_ids[task_id];//because assigned before setted properties?
        t.name = _name;
        tsk_descrptns.push(_name);//working this way, abusing w/o fixing method in 
        t.added_at = now;
        tvm.accept();
        return task_id;
    }

    //bug within these 2 functions, no name stored or displayed

    function veiw_tasks() public view returns(string[]) {
        string[] all_tasks;
        for(uint8 i = 0; i <= task_ids_cnt; i++){
            all_tasks.push(task_ids[i].name);
        }
        return all_tasks;
        tvm.accept();
    }



//tested, returns quantity of undone
    function get_undone() public view returns (uint) {
        string[] undones;
        for(uint8 i = 0; i < task_ids_cnt; i++){
            if(task_ids[i].done != true){
                undones.push(task_ids[i].name);
            }
        }
        return undones.length;
        tvm.accept();
    }


    function rem_by_k(uint8 _key) public {
        delete task_ids[_key];
        tvm.accept();
    }

    function get_dscr_wk(uint8 _k) public returns(string) {
        return task_ids[_k].name;
    }

    // function get_descr(uint8 _key) public view returns (string) {
    //     return task_ids[_key].name;
    //     tvm.accept();
    // }

//sets done to true, test passed
    function ncmark_as_compl(uint8 _key) public {
        task_ids[_key].done = true;
        tvm.accept();
    }
}