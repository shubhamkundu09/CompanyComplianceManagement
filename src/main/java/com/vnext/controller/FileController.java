package com.vnext.controller;

import com.vnext.service.DocumentStorageService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;

@RestController
@RequestMapping("/api/files")
@RequiredArgsConstructor
@Slf4j
public class FileController {

    private final DocumentStorageService documentStorageService;

    @GetMapping("/documents/{fileName}")
    public ResponseEntity<byte[]> getDocument(@PathVariable String fileName) {
        try {
            byte[] data = documentStorageService.load(fileName);
            MediaType type = resolveMediaType(fileName);
            return ResponseEntity.ok().contentType(type).body(data);
        } catch (IOException e) {
            log.error("Failed to load document: {}", e.getMessage());
            return ResponseEntity.notFound().build();
        }
    }

    private MediaType resolveMediaType(String name) {
        String ext = name.contains(".") ? name.substring(name.lastIndexOf('.')+1).toLowerCase() : "";
        return switch (ext) {
            case "pdf" -> MediaType.APPLICATION_PDF;
            case "png" -> MediaType.IMAGE_PNG;
            case "jpg", "jpeg" -> MediaType.IMAGE_JPEG;
            case "doc", "docx" -> MediaType.parseMediaType(
                    "application/vnd.openxmlformats-officedocument.wordprocessingml.document");
            case "xls", "xlsx" -> MediaType.parseMediaType(
                    "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet");
            default -> MediaType.APPLICATION_OCTET_STREAM;
        };
    }
}