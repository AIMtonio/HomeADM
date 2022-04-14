package soporte;

import java.awt.Font;
import com.octo.captcha.component.image.backgroundgenerator.BackgroundGenerator;
import com.octo.captcha.component.image.backgroundgenerator.FunkyBackgroundGenerator;
import com.octo.captcha.component.image.color.RandomRangeColorGenerator;
import com.octo.captcha.component.image.fontgenerator.FontGenerator;
import com.octo.captcha.component.image.fontgenerator.RandomFontGenerator;
import com.octo.captcha.component.image.textpaster.RandomTextPaster;
import com.octo.captcha.component.image.textpaster.TextPaster;
import com.octo.captcha.component.image.wordtoimage.ComposedWordToImage;
import com.octo.captcha.component.image.wordtoimage.WordToImage;
import com.octo.captcha.component.word.wordgenerator.RandomWordGenerator;
import com.octo.captcha.component.word.wordgenerator.WordGenerator;
import com.octo.captcha.engine.image.ListImageCaptchaEngine;
import com.octo.captcha.image.gimpy.GimpyFactory;

public class MyCaptchaEngine extends ListImageCaptchaEngine {

 protected void buildInitialFactories() {

  WordGenerator wgen = new RandomWordGenerator(
    "ABCDEFGHIJKLMNPQRSTUVWXYZ123456789");
  RandomRangeColorGenerator cgen = new RandomRangeColorGenerator(
    new int[] { 0, 50},new int[] { 0, 80 },new int[] { 0, 60 });

  TextPaster textPaster = new RandomTextPaster(new Integer(4),
    new Integer(6), cgen, true);

  BackgroundGenerator backgroundGenerator = new FunkyBackgroundGenerator(
    new Integer(120), new Integer(50));

  /**
   * BackgroundGenerator backgroundGenerator = new
   * GradientBackgroundGenerator(new Integer(200),new
   * Integer(100),Color.blue,Color.white);
   */

  Font[] fontsList = new Font[] {
		  new Font("Arial", 1, 10),new Font("Tahoma", 10, 15),new Font("Verdana", 11, 12),
		  };

  FontGenerator fontGenerator = new RandomFontGenerator(new Integer(20),
    new Integer(35), fontsList);

  WordToImage wordToImage = new ComposedWordToImage(fontGenerator,
    backgroundGenerator, textPaster);

  this.addFactory(new GimpyFactory(wgen, wordToImage));

 }
}
