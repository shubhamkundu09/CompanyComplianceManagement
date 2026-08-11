// exception/ResourceNotFoundException.java
package com.vnext.exception;

public class ResourceNotFoundException extends RuntimeException {
    public ResourceNotFoundException(String message) {
        super(message);
    }
}