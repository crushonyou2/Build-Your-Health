package mvc.database;

public class UserUtils {
    public static String maskUserId(String userId) {
        if (userId == null || userId.length() < 2) {
            return userId; // 너무 짧은 경우 그대로 반환
        }
        return userId.substring(0, 2) + "**";
    }
}
