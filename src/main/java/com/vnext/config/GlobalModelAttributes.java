package com.vnext.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributes {

    @Value("${app.base-url:}")
    private String configuredBaseUrl;

    @ModelAttribute("baseUrl")
    public String baseUrl() {
        if (configuredBaseUrl != null && !configuredBaseUrl.trim().isEmpty()) {
            String url = configuredBaseUrl.trim();
            while (url.endsWith("/")) {
                url = url.substring(0, url.length() - 1);
            }
            return url;
        }
        return "";
    }
}
