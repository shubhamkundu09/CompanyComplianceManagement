package com.vnext;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import com.vnext.service.EmailService;
import com.vnext.service.PushNotificationService;
import com.vnext.service.SchedulerService;

@SpringBootTest(properties = {
    "scheduler.poll.interval-ms=999999999"
})
class VnextLlpApplicationTests {

    @MockBean
    private EmailService emailService;

    @MockBean
    private PushNotificationService pushNotificationService;

    @MockBean
    private SchedulerService schedulerService;

    @Test
    void contextLoads() {
    }
}
