package soporte;
import com.octo.captcha.service.captchastore.FastHashMapCaptchaStore;
import com.octo.captcha.service.image.ImageCaptchaService;
import com.octo.captcha.service.image.DefaultManageableImageCaptchaService;

public class CaptchaServiceSingleton {
    private static ImageCaptchaService instance;
    static {
    	instance = new DefaultManageableImageCaptchaService(
    			 new FastHashMapCaptchaStore(),new MyCaptchaEngine(),180,100000,75000);
    }
    public static ImageCaptchaService getInstance(){
        return instance;
    }
}
