// dto/ApiResponse.java
package com.vnext.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import com.fasterxml.jackson.annotation.JsonInclude;

@Data
@AllArgsConstructor
@NoArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    private boolean success;
    private String message;
    private T data;
    private String error;
    private int status;

    public static <T> ApiResponse<T> success(T data, String message) {
        return new ApiResponse<>(true, message, data, null, 200);
    }

    public static <T> ApiResponse<T> success(String message) {
        return new ApiResponse<>(true, message, null, null, 200);
    }

    public static <T> ApiResponse<T> error(String error, int status) {
        return new ApiResponse<>(false, null, null, error, status);
    }

    public static <T> ApiResponse<T> error(String message, String error, int status) {
        return new ApiResponse<>(false, message, null, error, status);
    }
}