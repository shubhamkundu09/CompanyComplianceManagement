// dto/ChangePasswordResponse.java
package com.vnext.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class ChangePasswordResponse {
    private boolean success;
    private String message;
}