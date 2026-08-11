package com.vnext.service;

import com.vnext.config.FileStorageProperties;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.*;
import java.text.SimpleDateFormat;
import java.util.*;

@Service
@Slf4j
public class DocumentStorageService {

    private final Path storageLocation;
    private final String baseUrl;
    private final SimpleDateFormat df = new SimpleDateFormat("yyyyMMddHHmmssSSS");

    // Allowed mime types / extensions for company docs
    private static final List<String> ALLOWED_EXTENSIONS =
            Arrays.asList(".pdf", ".jpg", ".jpeg", ".png", ".doc", ".docx", ".xls", ".xlsx");
    private static final long MAX_SIZE = 10 * 1024 * 1024; // 10 MB

    public DocumentStorageService(FileStorageProperties props) throws IOException {
        this.storageLocation = Paths.get(props.getUploadDir()).toAbsolutePath().normalize();
        this.baseUrl = props.getBaseUrl();
        Files.createDirectories(this.storageLocation);
        log.info("Document storage location: {}", this.storageLocation);
    }

    /** Store one file, return its URL (relative, served via /api/files/documents/{name}) */
    public String store(MultipartFile file, String prefix) throws IOException {
        if (file == null || file.isEmpty()) throw new IOException("File is empty");
        if (file.getSize() > MAX_SIZE) throw new IOException("File too large (max 10 MB)");

        String originalName = Objects.requireNonNull(file.getOriginalFilename(), "Missing filename");
        String ext = getExtension(originalName).toLowerCase();
        if (!ALLOWED_EXTENSIONS.contains(ext))
            throw new IOException("Unsupported file type: " + ext +
                    ". Allowed: " + String.join(", ", ALLOWED_EXTENSIONS));

        String safeName = prefix + "_" + df.format(new Date()) + "_"
                + UUID.randomUUID().toString().substring(0, 8) + ext;
        Files.copy(file.getInputStream(), storageLocation.resolve(safeName),
                StandardCopyOption.REPLACE_EXISTING);
        log.info("Stored document: {}", safeName);
        return safeName; // stored name; convert to URL with getUrl()
    }

    /** Store for company documents specifically */
    public String storeCompanyDocument(MultipartFile file) throws IOException {
        return store(file, "company_doc");
    }

    public void delete(String fileName) throws IOException {
        if (fileName == null || fileName.isBlank()) return;
        String name = extractName(fileName); // strip any path prefix
        Path target = storageLocation.resolve(name);
        boolean deleted = Files.deleteIfExists(target);
        log.info("Delete {}: {}", name, deleted ? "ok" : "not found");
    }

    public byte[] load(String fileName) throws IOException {
        Path p = storageLocation.resolve(extractName(fileName));
        if (!Files.exists(p)) throw new IOException("File not found: " + fileName);
        return Files.readAllBytes(p);
    }

    public String getUrl(String fileName) {
        if (fileName == null || fileName.isBlank()) return null;
        return baseUrl + extractName(fileName);
    }

    public boolean exists(String fileName) {
        if (fileName == null || fileName.isBlank()) return false;
        return Files.exists(storageLocation.resolve(extractName(fileName)));
    }

    // ── helpers ────────────────────────────────────────────────────────────
    private String getExtension(String name) {
        int dot = name.lastIndexOf('.');
        return dot >= 0 ? name.substring(dot) : "";
    }

    private String extractName(String path) {
        // Handle stored values that might be full paths
        if (path.contains("/") || path.contains("\\")) {
            String[] parts = path.split("[/\\\\]");
            return parts[parts.length - 1];
        }
        return path;
    }
}