package mvc.database;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class YoutubeUtil {
    /**
     * 유튜브 URL에서 동영상 ID를 추출하는 메서드
     * 지원하는 URL 형식:
     * 1. https://www.youtube.com/watch?v=VIDEO_ID
     * 2. https://youtu.be/VIDEO_ID
     * @param url 유튜브 동영상 URL
     * @return 동영상 ID 또는 null
     */
    public static String extractYouTubeId(String url) {
        if (url == null) return null;

        // 패턴 1: https://www.youtube.com/watch?v=VIDEO_ID
        Pattern pattern1 = Pattern.compile("v=([a-zA-Z0-9_-]{11})");
        Matcher matcher1 = pattern1.matcher(url);
        if (matcher1.find()) {
            return matcher1.group(1);
        }

        // 패턴 2: https://youtu.be/VIDEO_ID
        Pattern pattern2 = Pattern.compile("youtu\\.be/([a-zA-Z0-9_-]{11})");
        Matcher matcher2 = pattern2.matcher(url);
        if (matcher2.find()) {
            return matcher2.group(1);
        }

        return null; // ID를 찾지 못한 경우
    }
}
