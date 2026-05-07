package com.findjob_tt.findjob_tt.service.cv;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;

@Service
public class CvScoringAsyncService {

    private static final Logger log = LoggerFactory.getLogger(CvScoringAsyncService.class);

    private final CvAiProperties properties;
    private final CvAiClient cvAiClient;
    private final CvScoringPersistenceService persistenceService;

    public CvScoringAsyncService(
            CvAiProperties properties,
            CvAiClient cvAiClient,
            CvScoringPersistenceService persistenceService) {
        this.properties = properties;
        this.cvAiClient = cvAiClient;
        this.persistenceService = persistenceService;
    }

    @Async("cvScoringExecutor")
    public void scoreApplicationAsync(Long applicationId) {
        if (!properties.hasApiKey()) {
            log.warn("Bỏ qua chấm CV cho application {} vì thiếu cv.ai.api-key", applicationId);
            return;
        }

        try {
            CvScoringContext context = persistenceService.buildContext(applicationId);
            CvAiAnalysisResult result = cvAiClient.analyze(context);
            persistenceService.saveResult(applicationId, result);
            log.info("Đã chấm CV thành công cho application {}", applicationId);
        } catch (Exception e) {
            log.error("Không thể chấm CV cho application {}", applicationId, e);
        }
    }
}
