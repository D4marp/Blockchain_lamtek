// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AkreditasiRegistry
 * @dev Smart Contract untuk menyimpan hash dan status akreditasi di blockchain
 * @notice Digunakan untuk akreditasi reguler, PJJ, dan prodi baru LAM Teknik
 */
contract AkreditasiRegistry {
    
    // ============================================
    // Enums
    // ============================================
    
    enum TipeAkreditasi {
        REGULER,
        PJJ,
        PRODI_BARU_PTNBH,
        PRODI_BARU_NON_PTNBH
    }
    
    enum StatusAkreditasi {
        REGISTRASI,
        VERIFIKASI_DOKUMEN,
        PEMBAYARAN,
        PENAWARAN_ASESOR,
        ASESMEN_KECUKUPAN,
        PENGESAHAN_AK,
        ASESMEN_LAPANGAN,
        TANGGAPAN_AL,
        PENGESAHAN_AL,
        PENETAPAN_PERINGKAT,
        SINKRONISASI_BANPT,
        SELESAI
    }
    
    enum PeringkatAkreditasi {
        BELUM_TERAKREDITASI,
        BAIK,
        BAIK_SEKALI,
        UNGGUL
    }
    
    // ============================================
    // Structs
    // ============================================
    
    struct Akreditasi {
        string kodeAkreditasi;
        uint256 institusiId;
        uint256 prodiId;
        uint256 uppsId;
        TipeAkreditasi tipe;
        StatusAkreditasi status;
        PeringkatAkreditasi peringkat;
        uint256 nilaiAkreditasi;
        string ipfsHashDokumen;
        string ipfsHashSK;
        string ipfsHashSertifikat;
        uint256 tanggalRegistrasi;
        uint256 tanggalTerakreditasi;
        uint256 tanggalBerakhir;
        address registeredBy;
        bool isActive;
    }
    
    struct AuditLog {
        string kodeAkreditasi;
        StatusAkreditasi fromStatus;
        StatusAkreditasi toStatus;
        string ipfsHashBukti;
        string keterangan;
        address changedBy;
        uint256 timestamp;
    }
    
    struct Dokumen {
        string ipfsHash;
        string namaDokumen;
        string tipeDokumen;
        uint256 uploadedAt;
        address uploadedBy;
        bool isVerified;
    }
    
    // ============================================
    // State Variables
    // ============================================
    
    address public owner;
    address public admin;
    
    // Tenant management for SaaS
    mapping(uint256 => bool) public registeredTenants; // institusiId => isRegistered
    mapping(uint256 => string) public tenantNames;
    
    // Main storage
    mapping(string => Akreditasi) public akreditasiRegistry; // kodeAkreditasi => Akreditasi
    mapping(string => AuditLog[]) public auditLogs; // kodeAkreditasi => AuditLog[]
    mapping(string => Dokumen[]) public dokumenAkreditasi; // kodeAkreditasi => Dokumen[]
    
    // Indexes
    string[] public allKodeAkreditasi;
    mapping(uint256 => string[]) public akreditasiByInstitusi; // institusiId => kodeAkreditasi[]
    mapping(uint256 => string[]) public akreditasiByProdi; // prodiId => kodeAkreditasi[]
    
    // Access control
    mapping(address => bool) public isAsesor;
    mapping(address => bool) public isValidator;
    mapping(address => bool) public isKEA; // Komite Evaluasi Akreditasi
    mapping(address => bool) public isMA; // Majelis Akreditasi
    mapping(address => bool) public isSekretariat;
    
    // ============================================
    // Events
    // ============================================
    
    event AkreditasiRegistered(
        string indexed kodeAkreditasi,
        uint256 indexed institusiId,
        uint256 indexed prodiId,
        TipeAkreditasi tipe,
        address registeredBy,
        uint256 timestamp
    );
    
    event StatusChanged(
        string indexed kodeAkreditasi,
        StatusAkreditasi fromStatus,
        StatusAkreditasi toStatus,
        address changedBy,
        uint256 timestamp
    );
    
    event DokumenUploaded(
        string indexed kodeAkreditasi,
        string ipfsHash,
        string namaDokumen,
        address uploadedBy,
        uint256 timestamp
    );
    
    event PeringkatDitetapkan(
        string indexed kodeAkreditasi,
        PeringkatAkreditasi peringkat,
        uint256 nilai,
        address ditetapkanOleh,
        uint256 timestamp
    );
    
    event TenantRegistered(
        uint256 indexed institusiId,
        string nama,
        uint256 timestamp
    );
    
    // ============================================
    // Modifiers
    // ============================================
    
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }
    
    modifier onlyAdmin() {
        require(msg.sender == admin || msg.sender == owner, "Only admin can call this function");
        _;
    }
    
    modifier onlyAuthorized() {
        require(
            msg.sender == owner || 
            msg.sender == admin || 
            isAsesor[msg.sender] || 
            isValidator[msg.sender] || 
            isKEA[msg.sender] || 
            isMA[msg.sender] ||
            isSekretariat[msg.sender],
            "Not authorized"
        );
        _;
    }
    
    modifier onlyKEAOrMA() {
        require(isKEA[msg.sender] || isMA[msg.sender] || msg.sender == owner, "Only KEA or MA can call this");
        _;
    }
    
    modifier akreditasiExists(string memory kodeAkreditasi) {
        require(bytes(akreditasiRegistry[kodeAkreditasi].kodeAkreditasi).length > 0, "Akreditasi not found");
        _;
    }
    
    // ============================================
    // Constructor
    // ============================================
    
    constructor() {
        owner = msg.sender;
        admin = msg.sender;
    }
    
    // ============================================
    // Tenant Management (SaaS)
    // ============================================
    
    function registerTenant(uint256 institusiId, string memory nama) external onlyAdmin {
        require(!registeredTenants[institusiId], "Tenant already registered");
        registeredTenants[institusiId] = true;
        tenantNames[institusiId] = nama;
        emit TenantRegistered(institusiId, nama, block.timestamp);
    }
    
    // ============================================
    // Akreditasi Management
    // ============================================
    
    /**
     * @dev Registrasi akreditasi baru
     */
    function registerAkreditasi(
        string memory kodeAkreditasi,
        uint256 institusiId,
        uint256 prodiId,
        uint256 uppsId,
        TipeAkreditasi tipe,
        string memory ipfsHashDokumen
    ) external onlyAuthorized returns (bool) {
        require(bytes(akreditasiRegistry[kodeAkreditasi].kodeAkreditasi).length == 0, "Kode akreditasi already exists");
        require(registeredTenants[institusiId], "Institution not registered as tenant");
        
        Akreditasi memory newAkreditasi = Akreditasi({
            kodeAkreditasi: kodeAkreditasi,
            institusiId: institusiId,
            prodiId: prodiId,
            uppsId: uppsId,
            tipe: tipe,
            status: StatusAkreditasi.REGISTRASI,
            peringkat: PeringkatAkreditasi.BELUM_TERAKREDITASI,
            nilaiAkreditasi: 0,
            ipfsHashDokumen: ipfsHashDokumen,
            ipfsHashSK: "",
            ipfsHashSertifikat: "",
            tanggalRegistrasi: block.timestamp,
            tanggalTerakreditasi: 0,
            tanggalBerakhir: 0,
            registeredBy: msg.sender,
            isActive: true
        });
        
        akreditasiRegistry[kodeAkreditasi] = newAkreditasi;
        allKodeAkreditasi.push(kodeAkreditasi);
        akreditasiByInstitusi[institusiId].push(kodeAkreditasi);
        akreditasiByProdi[prodiId].push(kodeAkreditasi);
        
        // Create initial audit log
        _createAuditLog(
            kodeAkreditasi,
            StatusAkreditasi.REGISTRASI,
            StatusAkreditasi.REGISTRASI,
            ipfsHashDokumen,
            "Akreditasi terdaftar"
        );
        
        emit AkreditasiRegistered(
            kodeAkreditasi,
            institusiId,
            prodiId,
            tipe,
            msg.sender,
            block.timestamp
        );
        
        return true;
    }
    
    /**
     * @dev Update status akreditasi
     */
    function updateStatus(
        string memory kodeAkreditasi,
        StatusAkreditasi newStatus,
        string memory ipfsHashBukti,
        string memory keterangan
    ) external onlyAuthorized akreditasiExists(kodeAkreditasi) returns (bool) {
        Akreditasi storage akred = akreditasiRegistry[kodeAkreditasi];
        StatusAkreditasi oldStatus = akred.status;
        
        // Validate status transition
        require(_isValidTransition(oldStatus, newStatus), "Invalid status transition");
        
        akred.status = newStatus;
        
        _createAuditLog(kodeAkreditasi, oldStatus, newStatus, ipfsHashBukti, keterangan);
        
        emit StatusChanged(kodeAkreditasi, oldStatus, newStatus, msg.sender, block.timestamp);
        
        return true;
    }
    
    /**
     * @dev Penetapan peringkat akreditasi oleh Majelis Akreditasi
     */
    function tetapkanPeringkat(
        string memory kodeAkreditasi,
        PeringkatAkreditasi peringkat,
        uint256 nilai,
        string memory ipfsHashSK,
        string memory ipfsHashSertifikat,
        uint256 tanggalBerakhir
    ) external onlyKEAOrMA akreditasiExists(kodeAkreditasi) returns (bool) {
        Akreditasi storage akred = akreditasiRegistry[kodeAkreditasi];
        
        require(
            akred.status == StatusAkreditasi.PENGESAHAN_AL || 
            akred.status == StatusAkreditasi.PENETAPAN_PERINGKAT,
            "Invalid status for rating"
        );
        
        akred.peringkat = peringkat;
        akred.nilaiAkreditasi = nilai;
        akred.ipfsHashSK = ipfsHashSK;
        akred.ipfsHashSertifikat = ipfsHashSertifikat;
        akred.tanggalTerakreditasi = block.timestamp;
        akred.tanggalBerakhir = tanggalBerakhir;
        akred.status = StatusAkreditasi.PENETAPAN_PERINGKAT;
        
        _createAuditLog(
            kodeAkreditasi,
            StatusAkreditasi.PENGESAHAN_AL,
            StatusAkreditasi.PENETAPAN_PERINGKAT,
            ipfsHashSK,
            string(abi.encodePacked("Peringkat ditetapkan: ", _peringkatToString(peringkat)))
        );
        
        emit PeringkatDitetapkan(kodeAkreditasi, peringkat, nilai, msg.sender, block.timestamp);
        
        return true;
    }
    
    /**
     * @dev Upload dokumen ke akreditasi
     */
    function uploadDokumen(
        string memory kodeAkreditasi,
        string memory ipfsHash,
        string memory namaDokumen,
        string memory tipeDokumen
    ) external onlyAuthorized akreditasiExists(kodeAkreditasi) returns (bool) {
        Dokumen memory newDokumen = Dokumen({
            ipfsHash: ipfsHash,
            namaDokumen: namaDokumen,
            tipeDokumen: tipeDokumen,
            uploadedAt: block.timestamp,
            uploadedBy: msg.sender,
            isVerified: false
        });
        
        dokumenAkreditasi[kodeAkreditasi].push(newDokumen);
        
        emit DokumenUploaded(kodeAkreditasi, ipfsHash, namaDokumen, msg.sender, block.timestamp);
        
        return true;
    }
    
    /**
     * @dev Verifikasi dokumen
     */
    function verifyDokumen(
        string memory kodeAkreditasi,
        uint256 dokumenIndex
    ) external onlyAuthorized akreditasiExists(kodeAkreditasi) returns (bool) {
        require(dokumenIndex < dokumenAkreditasi[kodeAkreditasi].length, "Invalid document index");
        dokumenAkreditasi[kodeAkreditasi][dokumenIndex].isVerified = true;
        return true;
    }
    
    // ============================================
    // Access Control Management
    // ============================================
    
    function setAdmin(address _admin) external onlyOwner {
        admin = _admin;
    }
    
    function setAsesor(address _asesor, bool _status) external onlyAdmin {
        isAsesor[_asesor] = _status;
    }
    
    function setValidator(address _validator, bool _status) external onlyAdmin {
        isValidator[_validator] = _status;
    }
    
    function setKEA(address _kea, bool _status) external onlyAdmin {
        isKEA[_kea] = _status;
    }
    
    function setMA(address _ma, bool _status) external onlyOwner {
        isMA[_ma] = _status;
    }
    
    function setSekretariat(address _sekretariat, bool _status) external onlyAdmin {
        isSekretariat[_sekretariat] = _status;
    }
    
    // ============================================
    // View Functions
    // ============================================
    
    function getAkreditasi(string memory kodeAkreditasi) 
        external 
        view 
        akreditasiExists(kodeAkreditasi) 
        returns (Akreditasi memory) 
    {
        return akreditasiRegistry[kodeAkreditasi];
    }
    
    function getAuditLogs(string memory kodeAkreditasi) 
        external 
        view 
        returns (AuditLog[] memory) 
    {
        return auditLogs[kodeAkreditasi];
    }
    
    function getDokumen(string memory kodeAkreditasi) 
        external 
        view 
        returns (Dokumen[] memory) 
    {
        return dokumenAkreditasi[kodeAkreditasi];
    }
    
    function getAkreditasiByInstitusi(uint256 institusiId) 
        external 
        view 
        returns (string[] memory) 
    {
        return akreditasiByInstitusi[institusiId];
    }
    
    function getAkreditasiByProdi(uint256 prodiId) 
        external 
        view 
        returns (string[] memory) 
    {
        return akreditasiByProdi[prodiId];
    }
    
    function getTotalAkreditasi() external view returns (uint256) {
        return allKodeAkreditasi.length;
    }
    
    // ============================================
    // Internal Functions
    // ============================================
    
    function _createAuditLog(
        string memory kodeAkreditasi,
        StatusAkreditasi fromStatus,
        StatusAkreditasi toStatus,
        string memory ipfsHashBukti,
        string memory keterangan
    ) internal {
        AuditLog memory log = AuditLog({
            kodeAkreditasi: kodeAkreditasi,
            fromStatus: fromStatus,
            toStatus: toStatus,
            ipfsHashBukti: ipfsHashBukti,
            keterangan: keterangan,
            changedBy: msg.sender,
            timestamp: block.timestamp
        });
        
        auditLogs[kodeAkreditasi].push(log);
    }
    
    function _isValidTransition(StatusAkreditasi from, StatusAkreditasi to) internal pure returns (bool) {
        // Allow same status (update without transition)
        if (from == to) return true;
        
        // Define valid transitions based on workflow
        if (from == StatusAkreditasi.REGISTRASI && to == StatusAkreditasi.VERIFIKASI_DOKUMEN) return true;
        if (from == StatusAkreditasi.VERIFIKASI_DOKUMEN && to == StatusAkreditasi.PEMBAYARAN) return true;
        if (from == StatusAkreditasi.PEMBAYARAN && to == StatusAkreditasi.PENAWARAN_ASESOR) return true;
        if (from == StatusAkreditasi.PENAWARAN_ASESOR && to == StatusAkreditasi.ASESMEN_KECUKUPAN) return true;
        if (from == StatusAkreditasi.ASESMEN_KECUKUPAN && to == StatusAkreditasi.PENGESAHAN_AK) return true;
        if (from == StatusAkreditasi.PENGESAHAN_AK && to == StatusAkreditasi.ASESMEN_LAPANGAN) return true;
        if (from == StatusAkreditasi.ASESMEN_LAPANGAN && to == StatusAkreditasi.TANGGAPAN_AL) return true;
        if (from == StatusAkreditasi.TANGGAPAN_AL && to == StatusAkreditasi.PENGESAHAN_AL) return true;
        if (from == StatusAkreditasi.PENGESAHAN_AL && to == StatusAkreditasi.PENETAPAN_PERINGKAT) return true;
        if (from == StatusAkreditasi.PENETAPAN_PERINGKAT && to == StatusAkreditasi.SINKRONISASI_BANPT) return true;
        if (from == StatusAkreditasi.SINKRONISASI_BANPT && to == StatusAkreditasi.SELESAI) return true;
        
        // Allow skip for prodi baru (no asesor offering)
        if (from == StatusAkreditasi.PEMBAYARAN && to == StatusAkreditasi.ASESMEN_KECUKUPAN) return true;
        
        return false;
    }
    
    function _peringkatToString(PeringkatAkreditasi peringkat) internal pure returns (string memory) {
        if (peringkat == PeringkatAkreditasi.BAIK) return "Baik";
        if (peringkat == PeringkatAkreditasi.BAIK_SEKALI) return "Baik Sekali";
        if (peringkat == PeringkatAkreditasi.UNGGUL) return "Unggul";
        return "Belum Terakreditasi";
    }
}
