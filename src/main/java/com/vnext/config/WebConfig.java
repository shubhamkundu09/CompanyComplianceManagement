package com.vnext.config;

import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.ViewControllerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

@Configuration
@RequiredArgsConstructor
public class WebConfig implements WebMvcConfigurer {

    private final FileStorageProperties fileStorageProperties;

    @Override
    public void addResourceHandlers(ResourceHandlerRegistry registry) {

        // Uploaded files
        registry.addResourceHandler(fileStorageProperties.getBaseUrl() + "**")
                .addResourceLocations("file:" + fileStorageProperties.getUploadDir())
                .setCachePeriod(3600);

        registry.addResourceHandler("/localimages/**")
        .addResourceLocations("file:/Users/manish/Downloads/");
        
        // Static assets
        registry.addResourceHandler("/assets/**")
                .addResourceLocations(
                        "classpath:/static/assets/",
                        "classpath:/public/assets/",
                        "/assets/")
                .setCachePeriod(0);

        registry.addResourceHandler("/webjars/**")
                .addResourceLocations("classpath:/META-INF/resources/webjars/")
                .resourceChain(false);
    }
/*
    @Override
    public void addViewControllers(ViewControllerRegistry registry) {
        registry.addViewController("/").setViewName("forward:/login");
        registry.addViewController("/login").setViewName("auth/login");
    }*/
}