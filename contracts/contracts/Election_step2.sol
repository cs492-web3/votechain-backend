pragma solidity >=0.4.22 <0.9.0;

import "./NFTToken.sol";

contract Election_step2 {

    NFTToken public VoteNFT;
    address public NFTTokenCA;

    // track what is happening in the contract
    enum ElectionStatus {
        registerCandStarted,
        voteStarted,
        voteEnded
    }

    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    struct Voter {
        uint8 flag;
        bool hasVoted;
        uint registerNum; // 후보 등록 횟수
        uint[] tokenIds; // 발급 받은 nft token들
    }

    mapping(uint => Candidate) public candidates;
    mapping(address => Voter) public voters;
   
    ElectionStatus public electionStatus;
    address public admin; // NOTE: onlyOwner (Ownable.sol)로 바꿀까??
    uint public totalCandidateNum; // track candidate id
    uint public totalVoteCount;
    string description;
    uint constant public MAXREGISTERNUM = 3; // 한 사람이 등록할 수 있는 후보자 최대 개수
    uint public isShowResultImm; // 1: 투표 즉시 바로 결과 공개, 0: 투표 종료 후 결과 공개
    
    constructor(address _NFTTokenCA, string memory _description, uint _isShowResultImm) public {
        admin = msg.sender;
        description = _description;
        NFTTokenCA = _NFTTokenCA;
        isShowResultImm = _isShowResultImm;

        electionStatus = ElectionStatus.registerCandStarted; // 시작하자마자 후보등록시작 상태
        VoteNFT = NFTToken(NFTTokenCA);
    }

    // ----- check electionStatus -----
    modifier checkRegisterCandidateStarted() {
        require (electionStatus == ElectionStatus.registerCandStarted, "Error: Status is not registerCandStarted.");
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
    modifier checkValidCands(uint[] memory candidateIds) {
        bool valid = true;
        for (uint i = 0; i < candidateIds.length; i++) {
            if (candidateIds[i] >= totalCandidateNum) {
                valid = false;
            }  
        }
        require (valid, "Error: invalid candidateId.");
        _;
    }
    modifier checkNotVoted() {
        require (voters[msg.sender].hasVoted == false, "Error: you can vote only once.");
        _;
    }

    modifier checkResultCanbeShowed() {
        if (isShowResultImm == 1) {
            require (voters[msg.sender].hasVoted, "Error: Only can see the result when you vote");
        } else { // 투표 모두 종료 후에만 공개
            require (electionStatus == ElectionStatus.voteEnded, "Error: Vote result can be shownwhen the voting session endss.");
        }
        _;
    }


    // ================== FUNCTION =======================
    // ------ status 바꿔주는 함수 -------

    // 시작하자마자 후보등록 시작 상태 이기 떄문에 startRegisterCandidate 불필요
    function startVoteSession() public 
        checkAdmin checkRegisterCandidateStarted  {
        electionStatus = ElectionStatus.voteStarted;
    }

    function endVoteSession() public
        checkAdmin checkVoteStarted {
        electionStatus = ElectionStatus.voteEnded;
    }

    // special function~~
    function restartVoteSession()  public
        checkAdmin checkVoteEnded {
        electionStatus = ElectionStatus.voteStarted;
    }
    
    // ------ 투표 시스템을 위한 함수 ------

    function registerCandidate (string memory name) private 
        checkRegisterCandidateStarted {
        require(voters[msg.sender].registerNum < MAXREGISTERNUM, "Error: voter has limit on number of registering candidates");
        candidates[totalCandidateNum] = Candidate(totalCandidateNum, name, 0);
        totalCandidateNum++;
        if (voters[msg.sender].flag>0) {
            voters[msg.sender].registerNum += 1;
        } else {
            voters[msg.sender].flag = 1;
            voters[msg.sender].registerNum = 1;
        }
    }  

    function registerCandidateAndGetNFT(string memory name) public {
        registerCandidate(name);
        uint tokenId = VoteNFT.mintToken(msg.sender);
        voters[msg.sender].tokenIds.push(tokenId);
    }


    function vote(uint[] memory candidateIds) private 
        checkVoteStarted checkNotVoted checkValidCands(candidateIds) {
        for (uint i=0; i<candidateIds.length; i++) {
            candidates[candidateIds[i]].voteCount++;
        }
        totalVoteCount++;
        voters[msg.sender].hasVoted =  true;
    }

    function voteAndGetNFT(uint[] memory candidateIds) public returns(uint){
        vote(candidateIds);
        uint tokenId = VoteNFT.mintToken(msg.sender);
        voters[msg.sender].tokenIds.push(tokenId);
        return tokenId; //NOTE: 없앨까 말까 고민
    }

    // ------ Getter --------

    // ex. 등록된 후보자가 4명이라면, totalCandidateNum = 4, 후보 아이디는 0~3번까지 존재
    function getTotalCandidateNum() public view returns(uint) {
        return totalCandidateNum;
    }
    
    function getCandidateName(uint id) public 
        checkValidCand(id) view returns (string memory) {
        return candidates[id].name;
    }

    function getAllCandidateNames() public view returns (string[] memory) {
        string[] memory names = new string[](totalCandidateNum);
        for (uint i = 0; i < totalCandidateNum; i++) {
            names[i] = candidates[i].name;
        }
        return names;
    }

    function getCandidateVoteCount(uint id) public 
        checkResultCanbeShowed checkValidCand(id) view returns (uint) {
        return candidates[id].voteCount;
    }

    function getAllCandidateVoteCounts() public
        checkResultCanbeShowed view returns (uint[] memory) {
        uint[] memory votes = new uint[](totalCandidateNum);
        for (uint i = 0; i < totalCandidateNum; i++) {
            votes[i] = candidates[i].voteCount;
        }
        return votes;
    }
    
    function getTotalVoteCount() public view returns (uint) { //NOTE: 중간집계 가능하도록 함, 모든 사람이 확인 가능
        return totalVoteCount;
    }

    function getIsAdmin(address addr) public view returns(bool) {
        return addr == admin;
    }

    function getElectionStatus() public view returns(ElectionStatus) {
        return electionStatus;
    }

    function getHasVoted(address addr) public view returns(bool) {
        return voters[addr].hasVoted;
    }

    function getRegisterNum(address addr) public view returns(uint) {
        return voters[addr].registerNum;
    }

    function getTokenIds(address addr) public view returns(uint[] memory) {
        return voters[addr].tokenIds;
    }

    function getRecentTokenId(address addr) public view returns(int) {
        if (voters[addr].flag>0) {
            return int(voters[addr].tokenIds[voters[addr].tokenIds.length - 1]);
        }
        return -1;
    }

    function getNFTTokenCA() public view returns(address) {
        return NFTTokenCA;
    }

    function getDescription() public view returns(string memory) {
        return description;
    }

    function getIsShowResultImm() public view returns(uint) {
        return isShowResultImm;
    }
    
}
