pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//import "../../node_modules/@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "../../node_modules/@openzeppelin/contracts/access/Ownable.sol";

contract NFTToken is Ownable, ERC721URIStorage { 
    uint constant public MAX_TOKEN_AVAIL = 32; //NOTE: 내가 ipfs에 올려놓은 json 파일의 개수
    uint constant public MAX_TOKEN_TOMINT = 32; // 총 발행할 nft 개수, MAX_TOKEN_ONSALE값보다 작아야함
    string constant public metadataURI = 'https://gateway.pinata.cloud/ipfs/QmfT1SF7fx9vZ1Vy8BygiReKMbqo1YHGuiFgyWrRDHjpw8';

    uint[] public availTokenList; // 아직 발행되지 않은 nft index 저장, realId, (1~MAX_TOKEN_ONSALE).json
    uint public totalMintedTokenCount; // 발행한 총 NFT 토큰 개수 (keeps tokenId)

    mapping(uint => uint) tokenIdToRealId;

   
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol){
        //metadataURI = _metadataURI;
        for (uint i = 0; i < MAX_TOKEN_AVAIL; i++) {
            availTokenList.push(i+1);
        }
    }
    // --------- FUNCTIONS ----------

    function mintToken(address voter_addr) public returns (uint) {
        require(totalMintedTokenCount <= MAX_TOKEN_TOMINT, "Error: Token is not available anymore.");
        uint tokenId = totalMintedTokenCount;
        uint realId = getRandomToken(voter_addr, tokenId);
        tokenIdToRealId[tokenId] = realId;
        totalMintedTokenCount += 1;
        _mint(voter_addr, tokenId); // mintToken함수를 호출한 계정에 NFT발행, Emits a {Transfer(address(0), to, tokenId} event.
        _setTokenURI(tokenId, tokenURI(tokenId));

        return tokenId;
    }

    function getRandomToken(address _owner, uint _tokenId) private returns (uint) {
        uint randSeed = 123;
        uint randN = uint(keccak256(abi.encodePacked(_owner, _tokenId, randSeed))) % availTokenList.length;
        uint randomToken = availTokenList[randN];
        availTokenList[randN] = availTokenList[availTokenList.length - 1];
        availTokenList.pop();

        return randomToken;
    }

    // --------- Getter ---------

    // ERC721.sol에 있는 함수 override (조회 함수, 아무것도 저장x)
    function tokenURI (uint _tokenId) public override view returns (string memory) {
        string memory realId = Strings.toString(tokenIdToRealId[_tokenId]);        
        return string(abi.encodePacked(metadataURI, "/", realId,".json"));
    }

    function getTotalMintedTokenCount() public view returns (uint) { 
        return totalMintedTokenCount;
    }

    function getAvailTokenList() public view returns (uint[] memory) {
        return availTokenList;
    }

    function getTotalAvailTokenCount() public view returns (uint) { 
        return availTokenList.length;
    }

    // --------- Setter ---------

    // onlyOwner : 컨트랙트 배포자만 호출할수 있는 함수 (Ownable.sol)
    /*
    function setMetadataURI(string memory _uri) public onlyOwner{
        metadataURI = _uri;
    }
    */
    
}