//pragma solidity ^0.8.9;
pragma solidity >=0.4.22 <0.9.0;

contract Election_step1 {
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }
    uint public totalCandidateNum; // track candidate id
    mapping(uint => Candidate) public candidates;
    mapping(address => bool) public voters; // prevent voting more than once

    // register candidate
    function addCandidate (string memory name) public {
        totalCandidateNum++;
        candidates[totalCandidateNum] = Candidate(totalCandidateNum, name, 0);
    }

    function validCandidate(uint candidateId) private view returns (bool){
        return true;
    }

    function vote(uint candidateId) public {
        require(validCandidate(candidateId),"The candidate is not valid.");
        voters[msg.sender] = true;
        candidates[candidateId].voteCount++;
    }

    function voteResultFor(uint candidateId) public view returns(uint){
        require(validCandidate(candidateId),"The candidate is not valid.");
        return candidates[candidateId].voteCount;
    }

    
    constructor() public {
        addCandidate('Geese');
        addCandidate('Nupjuki');
        addCandidate('Kaist President');
        addCandidate('Cat');
    }

    
}