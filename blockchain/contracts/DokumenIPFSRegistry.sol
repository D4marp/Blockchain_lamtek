// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title DokumenIPFSRegistry
 * @dev Smart Contract untuk menyimpan referensi dokumen IPFS
 */
contract DokumenIPFSRegistry {
    
    enum TipeDokumen {
        DOKUMEN_REGISTRASI,
        BUKTI_PEMBAYARAN,
        LAPORAN_EVALUASI_DIRI,
        LAPORAN_KINERJA,
        LAPORAN_AK,
        LAPORAN_AL,
        BERITA_ACARA,
        SURAT_TUGAS,
        UMPAN_BALIK,
        TANGGAPAN,
        SK_AKREDITASI,
        SERTIFIKAT,
        LAINNYA
    }
    
    struct Dokumen {
        uint256 id;
        string kodeAkreditasi;
        string ipfsHash;
        string namaFile;
        TipeDokumen tipe;
        uint256 ukuranBytes;
        string mimeType;
        string hashSHA256;
        bool isVerified;
        bool isActive;
        uint256 uploadedAt;
        address uploadedBy;
        string metadata;
    }
    
    struct VerifikasiLog {
        uint256 dokumenId;
        bool verified;
        string catatan;
        address verifiedBy;
        uint256 timestamp;
    }
    
    // Storage
    mapping(uint256 => Dokumen) public dokumenRegistry;
    mapping(string => uint256[]) public dokumenByKodeAkreditasi;
    mapping(string => uint256) public dokumenByIpfsHash;
    mapping(uint256 => VerifikasiLog[]) public verifikasiLogs;
    
    uint256 public totalDokumen;
    
    // Events
    event DokumenUploaded(
        uint256 indexed id,
        string kodeAkreditasi,
        string ipfsHash,
        string namaFile,
        TipeDokumen tipe,
        address uploadedBy,
        uint256 timestamp
    );
    
    event DokumenVerified(
        uint256 indexed id,
        string ipfsHash,
        bool verified,
        address verifiedBy,
        uint256 timestamp
    );
    
    event DokumenDeactivated(
        uint256 indexed id,
        string ipfsHash,
        address deactivatedBy,
        uint256 timestamp
    );
    
    // Access control
    address public owner;
    mapping(address => bool) public isAuthorized;
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner");
        _;
    }
    
    modifier onlyAuthorized() {
        require(isAuthorized[msg.sender] || msg.sender == owner, "Not authorized");
        _;
    }
    
    constructor() {
        owner = msg.sender;
        isAuthorized[msg.sender] = true;
    }
    
    function setAuthorized(address _addr, bool _status) external onlyOwner {
        isAuthorized[_addr] = _status;
    }
    
    /**
     * @dev Upload dokumen baru
     */
    function uploadDokumen(
        string memory kodeAkreditasi,
        string memory ipfsHash,
        string memory namaFile,
        TipeDokumen tipe,
        uint256 ukuranBytes,
        string memory mimeType,
        string memory hashSHA256,
        string memory metadata
    ) external onlyAuthorized returns (uint256) {
        require(dokumenByIpfsHash[ipfsHash] == 0, "Document with this IPFS hash already exists");
        
        totalDokumen++;
        uint256 newId = totalDokumen;
        
        dokumenRegistry[newId] = Dokumen({
            id: newId,
            kodeAkreditasi: kodeAkreditasi,
            ipfsHash: ipfsHash,
            namaFile: namaFile,
            tipe: tipe,
            ukuranBytes: ukuranBytes,
            mimeType: mimeType,
            hashSHA256: hashSHA256,
            isVerified: false,
            isActive: true,
            uploadedAt: block.timestamp,
            uploadedBy: msg.sender,
            metadata: metadata
        });
        
        dokumenByKodeAkreditasi[kodeAkreditasi].push(newId);
        dokumenByIpfsHash[ipfsHash] = newId;
        
        emit DokumenUploaded(
            newId,
            kodeAkreditasi,
            ipfsHash,
            namaFile,
            tipe,
            msg.sender,
            block.timestamp
        );
        
        return newId;
    }
    
    /**
     * @dev Verifikasi dokumen
     */
    function verifyDokumen(
        uint256 dokumenId,
        bool verified,
        string memory catatan
    ) external onlyAuthorized {
        require(dokumenRegistry[dokumenId].id != 0, "Document not found");
        
        dokumenRegistry[dokumenId].isVerified = verified;
        
        verifikasiLogs[dokumenId].push(VerifikasiLog({
            dokumenId: dokumenId,
            verified: verified,
            catatan: catatan,
            verifiedBy: msg.sender,
            timestamp: block.timestamp
        }));
        
        emit DokumenVerified(
            dokumenId,
            dokumenRegistry[dokumenId].ipfsHash,
            verified,
            msg.sender,
            block.timestamp
        );
    }
    
    /**
     * @dev Deactivate dokumen (soft delete)
     */
    function deactivateDokumen(uint256 dokumenId) external onlyAuthorized {
        require(dokumenRegistry[dokumenId].id != 0, "Document not found");
        
        dokumenRegistry[dokumenId].isActive = false;
        
        emit DokumenDeactivated(
            dokumenId,
            dokumenRegistry[dokumenId].ipfsHash,
            msg.sender,
            block.timestamp
        );
    }
    
    /**
     * @dev Get dokumen by ID
     */
    function getDokumen(uint256 id) external view returns (Dokumen memory) {
        return dokumenRegistry[id];
    }
    
    /**
     * @dev Get dokumen by IPFS hash
     */
    function getDokumenByHash(string memory ipfsHash) external view returns (Dokumen memory) {
        uint256 id = dokumenByIpfsHash[ipfsHash];
        return dokumenRegistry[id];
    }
    
    /**
     * @dev Get all dokumen IDs for akreditasi
     */
    function getDokumenByAkreditasi(string memory kodeAkreditasi) external view returns (uint256[] memory) {
        return dokumenByKodeAkreditasi[kodeAkreditasi];
    }
    
    /**
     * @dev Get verifikasi logs
     */
    function getVerifikasiLogs(uint256 dokumenId) external view returns (VerifikasiLog[] memory) {
        return verifikasiLogs[dokumenId];
    }
    
    /**
     * @dev Verify dokumen integrity by comparing hash
     */
    function verifyIntegrity(uint256 dokumenId, string memory hashToVerify) external view returns (bool) {
        require(dokumenRegistry[dokumenId].id != 0, "Document not found");
        return keccak256(bytes(dokumenRegistry[dokumenId].hashSHA256)) == keccak256(bytes(hashToVerify));
    }
}
