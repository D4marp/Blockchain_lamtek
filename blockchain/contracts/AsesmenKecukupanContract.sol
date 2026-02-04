// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title AsesmenKecukupanContract
 * @dev Smart Contract untuk modul Asesmen Kecukupan (AK)
 */
contract AsesmenKecukupanContract {
    
    struct AsesmenKecukupan {
        uint256 id;
        string kodeAkreditasi;
        uint256 akreditasiId;
        uint256 keaId;
        uint256 targetWaktu;
        bool lapAKKonsisten;
        string deskripsiLapAK;
        bool hasilDitetapkanKEA;
        string notePenetapan;
        string ipfsHashLaporan;
        uint256 skorAsesmen;
        bool terkonsolidasi;
        uint256 createdAt;
        uint256 updatedAt;
        address createdBy;
    }
    
    struct RincianButirPenilaian {
        uint256 asesmenId;
        uint256 butirId;
        uint256 skor;
        string catatan;
        string ipfsHashBukti;
    }
    
    // Storage
    mapping(uint256 => AsesmenKecukupan) public asesmenRegistry;
    mapping(string => uint256) public asesmenByKodeAkreditasi;
    mapping(uint256 => RincianButirPenilaian[]) public rincianPenilaian;
    
    uint256 public totalAsesmen;
    
    // Events
    event AsesmenKecukupanCreated(
        uint256 indexed id,
        string kodeAkreditasi,
        uint256 keaId,
        uint256 timestamp
    );
    
    event HasilAKDitetapkan(
        uint256 indexed id,
        string kodeAkreditasi,
        bool konsisten,
        uint256 skor,
        address ditetapkanOleh,
        uint256 timestamp
    );
    
    event LaporanAKSubmitted(
        uint256 indexed id,
        string ipfsHash,
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
     * @dev Buat asesmen kecukupan baru
     */
    function createAsesmenKecukupan(
        string memory kodeAkreditasi,
        uint256 akreditasiId,
        uint256 keaId,
        uint256 targetWaktu
    ) external onlyAuthorized returns (uint256) {
        require(asesmenByKodeAkreditasi[kodeAkreditasi] == 0, "Asesmen already exists for this akreditasi");
        
        totalAsesmen++;
        uint256 newId = totalAsesmen;
        
        asesmenRegistry[newId] = AsesmenKecukupan({
            id: newId,
            kodeAkreditasi: kodeAkreditasi,
            akreditasiId: akreditasiId,
            keaId: keaId,
            targetWaktu: targetWaktu,
            lapAKKonsisten: false,
            deskripsiLapAK: "",
            hasilDitetapkanKEA: false,
            notePenetapan: "",
            ipfsHashLaporan: "",
            skorAsesmen: 0,
            terkonsolidasi: false,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            createdBy: msg.sender
        });
        
        asesmenByKodeAkreditasi[kodeAkreditasi] = newId;
        
        emit AsesmenKecukupanCreated(newId, kodeAkreditasi, keaId, block.timestamp);
        
        return newId;
    }
    
    /**
     * @dev Submit laporan AK
     */
    function submitLaporanAK(
        uint256 asesmenId,
        string memory ipfsHashLaporan,
        string memory deskripsi
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        asesmenRegistry[asesmenId].ipfsHashLaporan = ipfsHashLaporan;
        asesmenRegistry[asesmenId].deskripsiLapAK = deskripsi;
        asesmenRegistry[asesmenId].updatedAt = block.timestamp;
        
        emit LaporanAKSubmitted(asesmenId, ipfsHashLaporan, block.timestamp);
    }
    
    /**
     * @dev Tetapkan hasil AK oleh KEA
     */
    function tetapkanHasilAK(
        uint256 asesmenId,
        bool konsisten,
        uint256 skor,
        string memory notePenetapan
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        AsesmenKecukupan storage asesmen = asesmenRegistry[asesmenId];
        asesmen.lapAKKonsisten = konsisten;
        asesmen.skorAsesmen = skor;
        asesmen.hasilDitetapkanKEA = true;
        asesmen.notePenetapan = notePenetapan;
        asesmen.terkonsolidasi = true;
        asesmen.updatedAt = block.timestamp;
        
        emit HasilAKDitetapkan(
            asesmenId,
            asesmen.kodeAkreditasi,
            konsisten,
            skor,
            msg.sender,
            block.timestamp
        );
    }
    
    /**
     * @dev Tambah rincian butir penilaian
     */
    function addRincianPenilaian(
        uint256 asesmenId,
        uint256 butirId,
        uint256 skor,
        string memory catatan,
        string memory ipfsHashBukti
    ) external onlyAuthorized {
        require(asesmenRegistry[asesmenId].id != 0, "Asesmen not found");
        
        rincianPenilaian[asesmenId].push(RincianButirPenilaian({
            asesmenId: asesmenId,
            butirId: butirId,
            skor: skor,
            catatan: catatan,
            ipfsHashBukti: ipfsHashBukti
        }));
    }
    
    /**
     * @dev Get asesmen by ID
     */
    function getAsesmen(uint256 id) external view returns (AsesmenKecukupan memory) {
        return asesmenRegistry[id];
    }
    
    /**
     * @dev Get asesmen by kode akreditasi
     */
    function getAsesmenByKode(string memory kodeAkreditasi) external view returns (AsesmenKecukupan memory) {
        uint256 id = asesmenByKodeAkreditasi[kodeAkreditasi];
        return asesmenRegistry[id];
    }
    
    /**
     * @dev Get rincian penilaian
     */
    function getRincianPenilaian(uint256 asesmenId) external view returns (RincianButirPenilaian[] memory) {
        return rincianPenilaian[asesmenId];
    }
}
