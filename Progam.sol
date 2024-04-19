pragma solidity ^0.8.25;

contract IdentityManagement {
    
    struct Identity {
        uint256 id;
        string name;
        string email;
        bool isVerified;
    }
    
    mapping(uint256 => Identity) private identities;
    mapping(string => address) private emailToAddress;
    uint256[] private identityIds;
    
    event IdentityCreated(uint256 id, string name, string email);
    event IdentityVerified(uint256 id);
    
    modifier onlyOwner(uint256 id) {
        require(identities[id].id != 0, "Identity not found");
        require(identities[id].id == id, "Invalid identity ID");
        _;
    }
    
    function createIdentity(uint256 id, string memory name, string memory email) public {
        require(identities[id].id == 0, "Identity already exists");
        require(emailToAddress[email] == address(0), "Email already in use");
        
        Identity storage newIdentity = identities[id];
        newIdentity.id = id;
        newIdentity.name = name;
        newIdentity.email = email;
        
        emailToAddress[email] = msg.sender;
        identityIds.push(id);
        
        emit IdentityCreated(id, name, email);
    }
    
    function verifyIdentity(uint256 id) public onlyOwner(id) {
        identities[id].isVerified = true;
        emit IdentityVerified(id);
    }
    
    function getIdentityDetails(uint256 id) public view returns (uint256, string memory, string memory, bool) {
        Identity memory identity = identities[id];
        return (identity.id, identity.name, identity.email, identity.isVerified);
    }
    
    function displayAllUsers() public view returns (uint256[] memory, string[] memory) {
        uint256[] memory ids = new uint256[](identityIds.length);
        string[] memory names = new string[](identityIds.length);
        
        for (uint256 i = 0; i < identityIds.length; i++) {
            uint256 id = identityIds[i];
            Identity memory identity = identities[id];
            ids[i] = identity.id;
            names[i] = identity.name;
        }
        
        return (ids, names);
    }
}
