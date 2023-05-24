//pragma solidity ^0.8.9;
pragma solidity >=0.4.22 <0.9.0;

// 직접 후보를 등록할 수 있음.
// 단, 등록한 후보는 못 지움! (블록체인 성질)
// 후보 등록이 언제나

contract Election_step2 {

    // track what is happening in the contract
    enum ElectionStatus {
        registerCandStarted,
        registerCandEnded,
        voteStarted,
        voteEnded
    }

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters; // prevent voting more than once (Voter struct 만들 필요 있을까?)

    ElectionStatus public electionStatus;
    address public admin;
    uint public totalCandidateNum; // track candidate id
    uint public totalVoteCount;
    
    // ----- check electionStatus -----

    modifier checkRegisterCandidateStarted() {
        require (electionStatus == ElectionStatus.registerCandStarted, "Error: Status is not registerCandStarted.");
        _;
    }
    modifier checkRegisterCandidateEnded() {
        require (electionStatus == ElectionStatus.registerCandEnded, "Error: Status is not registerCandEnded.");
        _;
    }
    modifier checkVoteStarted() {
        require (electionStatus == ElectionStatus.voteStarted, "Error: Status is not voteStarted.");
        _;
    }
    modifier checkVoteEnded() {
        require (electionStatus == ElectionStatus.voteEnded, "Error: Status is not voteEnded.");
        _;
    }

    // ----- check etc -----
    modifier checkAdmin() {
        require (msg.sender == admin, "Error: only admin is allowed.");
        _;
    }
    modifier checkValidCand(uint candidateId) {
        require (candidateId < totalCandidateNum, "Error: invalid candidateId.");
        _;
    }

    // ------ event : contract 외부로 전해야하는 log 들 ---------
    event statusChangedEvent (ElectionStatus prev, ElectionStatus end);
    event candRegisteredEvent (uint id); // 후보 기호
    event voteDoneEvent (); // TODO: 투표자가 투표를 하고나서 전송해야하는 정보가 있을까용 (ex. voter msg.sender)
    // ------------------------------------------------------
    // the very first contract transaction
    constructor() public {
        admin = msg.sender;
        electionStatus = ElectionStatus.registerCandStarted;
        // 시작하자마자 후보등록시작 상태
    }

    // ================== FUNCTION =======================
    // ------ status 바꿔주는 함수 -------

    // 시작하자마자 후보등록시작 상태 이기 떄문에 startRegisterCandidate 불필요
    function endRegisterCandSession() public 
        checkAdmin checkRegisterCandidateStarted  {
        electionStatus = ElectionStatus.registerCandEnded;
        //emit statusChangedEvent(ElectionStatus.registerCandStarted, ElectionStatus.registerCandEnded);
    }

    function startVoteSession() public
        checkAdmin checkRegisterCandidateEnded {
        electionStatus = ElectionStatus.voteStarted;
        //emit statusChangedEvent(ElectionStatus.registerCandEnded, ElectionStatus.voteStarted);
    }

    function endVoteSession() public
        checkAdmin checkVoteStarted {
        electionStatus = ElectionStatus.voteEnded;
        //emit statusChangedEvent(ElectionStatus.voteStarted, ElectionStatus.voteEnded);
    }
    

    // ------ 투표 시스템을 위한 함수 ------

    // NOTE: addCandidate에서 registerCandidate로 이름을 변경함
    function registerCandidate (string memory name) public 
        checkRegisterCandidateStarted {
        candidates[totalCandidateNum] = Candidate(totalCandidateNum, name, 0);
        totalCandidateNum++; // NOTE: 후보 0번부터 받도록 변경함 (step1.sol에서는 1부터 시작)
        emit candRegisteredEvent(totalCandidateNum - 1); // 등록된 후보의 기호를 log로 내보냄
    }

    function vote(uint candidateId) public 
        checkVoteStarted checkValidCand(candidateId) {
        require(voters[msg.sender] == false, "Error: the voter has already voted.");
        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
        totalVoteCount++;

        //emit voteDoneEvent(); // 과연 필요할까?
    }
    

    // ------ for client (view functions) --------

    // ex. 등록된 후보자가 4명이라면, totalCandidateNum = 4, 후보 아이디는 0~3번까지 존재
    function getTotalCandidateNum() public view returns (uint) {
        return totalCandidateNum;
    }

    function getCandidateName(uint id) public 
        checkValidCand(id) view returns (string memory) {
        return candidates[id].name;
    }

    function getCandidateVoteCount(uint id) public 
        checkAdmin checkVoteEnded checkValidCand(id) view returns (uint) { //NOTE: 중간집계 가능하도록 할까, 아니면 투표 모두 종료 후에만 볼 수 있도록 할까?
        return candidates[id].voteCount;
    }
    
    function getTotalVoteCount() public 
        checkAdmin view returns (uint) { //NOTE: 중간집계 가능하도록 함
        return totalVoteCount;
    }

    function getIsAdmin(address addr) public view returns(bool) {
        return addr == admin;
    }

    function getElectionStatus() public view returns(ElectionStatus) {
        return electionStatus;
    }



    
    

    
}