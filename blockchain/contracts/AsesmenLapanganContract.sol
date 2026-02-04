// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AsesmenLapanganContract
 * @dev Smart Contract untuk modul Asesmen Lapangan (AL)
 */
contract AsesmenLapanganContract {
    
    struct AsesmenLapangan {
        uint256 id;
        string kodeAkreditasi;
        uint256 akreditasiId;
        uint256 keaId;
        uint256 tanggalVisitasiAwal;
        uint256 tanggalVisitasiAkhir;
        bool jadwalDisetujui;
        uint256 targetWaktu;
        bool laporanSubmitted;
        bool hasilDitetapkanKEA;
        string notePenetapan;
        string noSuratTugas;
        string ipfsHashSuratTugas;
        string ipfsHashBeritaAcara;
        string ipfsHashUmpanBalik;
        string ipfsHashLaporanAL;
        string rekomendasiPeringkat;
        uint256 createdAt;
        uint256 updatedAt;
        address createdBy;
    }
    
    struct TanggapanAL {
        uint256 asesmenId;
        string ipfsHashTanggapan;
        bool uppsMenunggapi;
        bool asesorMenanggapi;
        uint256 deadlineTanggapan;
        uint256 tanggalTanggapan;
    }
    
    struct JadwalVisitasi {
        uint256 asesmenId;
        uint256 tanggal;
        uint256 jamMulai;
        uint256 jamSelesai;
        string agenda;
        string lokasi;
        bool isOnline;
    }
    
    // Storage
    mapping(uint256 => AsesmenLapangan) public asesmenRegistry;
    mapping(string => uint256) public asesmenByKodeAkreditasi;
    mapping(uint256 => TanggapanAL) public tanggapanRegistry;
    mapping(uint256 => JadwalVisitasi[]) public jadwalVisitasi;
    
    uint256 public totalAsesmen;
    
    // Events
    event AsesmenLapanganCreated(
        uint256 indexed id,
        string kodeAkreditasi,
        uint256 keaId,
        uint256 timestamp
    );
    
    event JadwalVisitasiSet(
        uint256 indexed id,
        uint256 tanggalAwal,
        uint256 tanggalAkhir,
        uint256 timestamp
    );
    
    event LaporanALSubmitted(
        uint256 indexed id,
        string ipfsHash,
        uint256 timestamp
    );
    
    event HasilALDitetapkan(
        uint256 indexed id,
        string kodeAkreditasi,
        string rekomendasiPeringkat,
        address ditetapkanOleh,
        uint256 timestamp
    );
    
    event TanggapanALSubmitted(
        uint256 indexed id,
        string ipfsHash,
        bool dariUPPS,
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
     * @dev Buat asesmen lapangan baru
     */
    function createAsesmenLapangan(
        string memory kodeAkreditasi,
        uint256 akreditasiId,
        uint256 keaId,
        uint256 targetWaktu
    ) external onlyAuthorized returns (uint256) {
        require(asesmenByKodeAkreditasi[kodeAkreditasi] == 0, "Asesmen already exists for this akreditasi");
        
        totalAsesmen++;
        uint256 newId = totalAsesmen;
        
        asesmenRegistry[newId] = AsesmenLapangan({
            id: newId,
            kodeAkreditasi: kodeAkreditasi,
            akreditasiId: akreditasiId,
            keaId: keaId,
            tanggalVisitasiAwal: 0,
            tanggalVisitasiAkhir: 0,
            jadwalDisetujui: false,
            targetWaktu: targetWaktu,
            laporanSubmitted: false,
            hasilDitetapkanKEA: false,
            notePenetapan: "",
            noSuratTugas: "",
            ipfsHashSuratTugas: "",
            ipfsHashBeritaAcara: "",
            ipfsHashUmpanBalik: "",
            ipfsHashLaporanAL: "",
            rekomendasiPeringkat: "",
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            createdBy: msg.sender
        });
        
        asesmenByKodeAkreditasi[kodeAkreditasi] = newId;
        
        emit AsesmenLapanganCreated(newId, kodeAkreditasi, keaId, block.timestamp);
        
        return newId;
    }
    
    /**
     * @dev Set jadwal visitasi
     */
    function setJadwalVisitasi(
        uint256 asesmenId,
        uint256 tanggalAwal,
        uint256 tanggalAkhir,
        string memory noSuratTugas,
        string memory ipfsHashSuratTugas
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        AsesmenLapangan storage asesmen = asesmenRegistry[asesmenId];
        asesmen.tanggalVisitasiAwal = tanggalAwal;
        asesmen.tanggalVisitasiAkhir = tanggalAkhir;
        asesmen.noSuratTugas = noSuratTugas;
        asesmen.ipfsHashSuratTugas = ipfsHashSuratTugas;
        asesmen.jadwalDisetujui = true;
        asesmen.updatedAt = block.timestamp;
        
        emit JadwalVisitasiSet(asesmenId, tanggalAwal, tanggalAkhir, block.timestamp);
    }
    
    /**
     * @dev Tambah detail jadwal visitasi
     */
    function addJadwalDetail(
        uint256 asesmenId,
        uint256 tanggal,
        uint256 jamMulai,
        uint256 jamSelesai,
        string memory agenda,
        string memory lokasi,
        bool isOnline
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        jadwalVisitasi[asesmenId].push(JadwalVisitasi({
            asesmenId: asesmenId,
            tanggal: tanggal,
            jamMulai: jamMulai,
            jamSelesai: jamSelesai,
            agenda: agenda,
            lokasi: lokasi,
            isOnline: isOnline
        }));
    }
    
    /**
     * @dev Submit laporan AL
     */
    function submitLaporanAL(
        uint256 asesmenId,
        string memory ipfsHashLaporanAL,
        string memory ipfsHashBeritaAcara,
        string memory ipfsHashUmpanBalik
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        AsesmenLapangan storage asesmen = asesmenRegistry[asesmenId];
        asesmen.ipfsHashLaporanAL = ipfsHashLaporanAL;
        asesmen.ipfsHashBeritaAcara = ipfsHashBeritaAcara;
        asesmen.ipfsHashUmpanBalik = ipfsHashUmpanBalik;
        asesmen.laporanSubmitted = true;
        asesmen.updatedAt = block.timestamp;
        
        emit LaporanALSubmitted(asesmenId, ipfsHashLaporanAL, block.timestamp);
    }
    
    /**
     * @dev Submit tanggapan AL
     */
    function submitTanggapanAL(
        uint256 asesmenId,
        string memory ipfsHashTanggapan,
        bool dariUPPS
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        TanggapanAL storage tanggapan = tanggapanRegistry[asesmenId];
        tanggapan.asesmenId = asesmenId;
        tanggapan.ipfsHashTanggapan = ipfsHashTanggapan;
        tanggapan.tanggalTanggapan = block.timestamp;
        
        if (dariUPPS) {
            tanggapan.uppsMenunggapi = true;
        } else {
            tanggapan.asesorMenanggapi = true;
        }
        
        emit TanggapanALSubmitted(asesmenId, ipfsHashTanggapan, dariUPPS, block.timestamp);
    }
    
    /**
     * @dev Tetapkan hasil AL oleh KEA
     */
    function tetapkanHasilAL(
        uint256 asesmenId,
        string memory rekomendasiPeringkat,
        string memory notePenetapan
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        AsesmenLapangan storage asesmen = asesmenRegistry[asesmenId];
        asesmen.rekomendasiPeringkat = rekomendasiPeringkat;
        asesmen.notePenetapan = notePenetapan;
        asesmen.hasilDitetapkanKEA = true;
        asesmen.updatedAt = block.timestamp;
        
        emit HasilALDitetapkan(
            asesmenId,
            asesmen.kodeAkreditasi,
            rekomendasiPeringkat,
            msg.sender,
            block.timestamp
        );
    }
    
    /**
     * @dev Get asesmen by ID
     */
    function getAsesmen(uint256 id) external view returns (AsesmenLapangan memory) {
        return asesmenRegistry[id];
    }
    
    /**
     * @dev Get asesmen by kode akreditasi
     */
    function getAsesmenByKode(string memory kodeAkreditasi) external view returns (AsesmenLapangan memory) {
        uint256 id = asesmenByKodeAkreditasi[kodeAkreditasi];
        return asesmenRegistry[id];
    }
    
    /**
     * @dev Get tanggapan AL
     */
    function getTanggapanAL(uint256 asesmenId) external view returns (TanggapanAL memory) {
        return tanggapanRegistry[asesmenId];
    }
    
    /**
     * @dev Get jadwal visitasi
     */
    function getJadwalVisitasi(uint256 asesmenId) external view returns (JadwalVisitasi[] memory) {
        return jadwalVisitasi[asesmenId];
    }
}
