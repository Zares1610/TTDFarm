const CryptoJS = require("crypto-js");

// Danh sách tất cả units xịn nhất
const godlyAndUltimateUnits = [
    "Upgraded Titan Cinemaman", "Axe Upgraded Titan Speakerman", "Mystical Titan", 
    "Titan Present Man", "Golden Future Large Clockman", "Sergeant Drillman", 
    "Mech Bunny Titan", "Chief Clockman", "Titan Firework Man", "Aquatitan Speakerman", 
    "Boss Toilet", "Upgraded Strider Toilet", "Witch Camerawoman", "Love Blade Cameraman", 
    "Gingerbread House", "Volcanic Titan", "King Drillman", "Sinister Titan TV Man", 
    "Large Laser Cameraman", "Upgraded Titan Speakerman", "Titan TV Man", "Large Firework Cameraman", 
    "Green Laser Cameraman", "Titan Speakerman", "Large Scientist Cameraman", "Titan Cameraman", 
    "Scientist Cameraman", "Upgraded Titan Drill Man", "Upgraded Titan Clockman", "Quantum Cameraman", 
    "Titan Warlord Clockman", "Golden Titan Speakerman", "Angelic Guardian", "Titan Glacier TV Man", 
    "Frost Titan Speakerman", "Telanthric Titan", "Upgraded Titan Drilldragon", "Sinister Titan Clockman"
];

// Dữ liệu game (giả lập)
const gameData = {
    playerGems: Math.floor(Math.random() * 100000), // Lấy số gems hiện có
    fee: 100, // Phí gửi
    delay: "5 phút", // Thời gian chờ
    storedUnits: [...godlyAndUltimateUnits] // Danh sách units có trong kho
};

// **Khóa mã hóa**
const secretKey = process.env.SECRET_KEY || "super_secure_key_123";

// Hàm mã hóa dữ liệu (AES)
function encryptData(data) {
    return CryptoJS.AES.encrypt(data, secretKey).toString();
}

// Hàm giải mã dữ liệu (AES)
function decryptData(encryptedData) {
    const bytes = CryptoJS.AES.decrypt(encryptedData, secretKey);
    return bytes.toString(CryptoJS.enc.Utf8);
}

// Hàm gửi một unit + một phần gems trong mỗi đợt
function sendBatch(recipient) {
    if (gameData.storedUnits.length === 0 || gameData.playerGems === 0) {
        console.log("[Auto] Không còn units hoặc gems để gửi.");
        return;
    }

    const unit = gameData.storedUnits.pop(); // Lấy 1 unit xịn để gửi
    const gemsToSend = Math.ceil(gameData.playerGems / (gameData.storedUnits.length + 1)); // Chia đều gems
    gameData.playerGems -= gemsToSend; // Trừ gems sau khi gửi

    const payload = JSON.stringify({ unit, gems: gemsToSend, recipient });
    const encryptedMail = encryptData(payload);

    postOfficeSend(encryptedMail);
}

// Hàm gửi thư đi
function postOfficeSend(encryptedMail) {
    try {
        const decryptedMail = decryptData(encryptedMail);
        if (!decryptedMail) throw new Error("Giải mã thất bại!");

        const { unit, gems, recipient } = JSON.parse(decryptedMail);
        console.log(`[Post Office] Đã gửi ${unit} + ${gems} gems đến ${recipient} (phí: ${gameData.fee} coins)`);
        console.log(`[Trạng thái] Đã gửi, đến trong ${gameData.delay}...`);
    } catch (error) {
        console.error("[LỖI] Không thể gửi mail:", error.message);
    }
}

// **Chạy tự động mỗi 5 phút cho đến khi hết units và gems**
setInterval(() => {
    sendBatch("ubkski12");
}, 300000);

// **Chạy ngay khi khởi động**
sendBatch("ubkski12");
