package com.vnext.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ModelAttribute;

@ControllerAdvice
public class GlobalModelAttributes {

    @Value("${app.base-url}")
    private String baseUrl;

    @ModelAttribute("baseUrl")
    public String baseUrl() {
        return baseUrl;
    }
}
