package herramientas;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.FileOutputStream;
import javax.imageio.ImageIO;

import org.apache.log4j.Logger;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.Writer;
import com.google.zxing.WriterException;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
// QR Code Generator in Java using opensource library ZXing
public class GenerateQRCode {
    // Image properties
	 private static final int qr_image_width = 400;
	    private static final int qr_image_height = 400;

	    private static final String IMAGE_FORMAT = "png";
     

    // Let's do it
   // public static void main(String[] args) throws Exception {
    	public static  void genera(String data)throws Exception{

    	   // private static final String IMG_PATH = "c:/temp/qrcode.png";
    	    String IMG_PATH =System.getProperty("file.separator")+"opt"+
    		   System.getProperty("file.separator")+"tomcat6"+
    			   System.getProperty("file.separator")+"webapps"+
    			   System.getProperty("file.separator")+ "microfin"+
    			   System.getProperty("file.separator")+ "Archivos"+
    			   System.getProperty("file.separator")+ "Codigos";
    	    	  // System.getProperty("file.separator")+ "qrcode.png";
    		Logger log = Logger.getLogger( "GenerateQRCode");
    		log.info("cadena:"+data);
        // URL to be encoded
    //data = "http://www.google.com";

        // Encode URL in QR format

        BitMatrix matrix;

        Writer writer = new QRCodeWriter();

        try {

            matrix = writer.encode(data, BarcodeFormat.QR_CODE, qr_image_width, qr_image_height);

        } catch (WriterException e) {
            e.printStackTrace(System.err);
            return;
        }
        // Create buffered image to draw to

        BufferedImage image = new BufferedImage(qr_image_width,

                   qr_image_height, BufferedImage.TYPE_INT_RGB);

 
        // Iterate through the matrix and draw the pixels to the image

        for (int y = 0; y < qr_image_height; y++) {

            for (int x = 0; x < qr_image_width; x++) {

                int grayValue = (matrix.get(x, y) ? 1 : 0) & 0xff;

                image.setRGB(x, y, (grayValue == 0 ? 0 : 0xFFFFFF));

            }

        }

        boolean exists = (new File(IMG_PATH)).exists();
    	if (exists) {
    		IMG_PATH =IMG_PATH+System.getProperty("file.separator")+"Cuenta"+data+".png";
    	
    		log.info("path: "+IMG_PATH);
        // Write the image to a file
        image=invertirColores(image);
        FileOutputStream qrCode = new FileOutputStream(IMG_PATH);

        ImageIO.write(image, IMAGE_FORMAT, qrCode);

        qrCode.close();
    	}else {
   		 File aDir = new File(IMG_PATH);
			aDir.mkdir();
			IMG_PATH =IMG_PATH+System.getProperty("file.separator")+"Cuenta"+data+".png";
	    	
	    	log.info("pathcrea: "+IMG_PATH);
	        // Write the image to a file
	        image=invertirColores(image);
	        FileOutputStream qrCode = new FileOutputStream(IMG_PATH);

	        ImageIO.write(image, IMAGE_FORMAT, qrCode);

	        qrCode.close();
    	}

    }
    	
    	  private static  BufferedImage invertirColores(BufferedImage imagen) { 
    	        for (int x = 0; x < qr_image_height; x++) { 
    	            for (int y = 0; y < qr_image_width; y++) { 
    	                int rgb = imagen.getRGB(x, y); 
    	                if (rgb == -16777216) { 
    	                    imagen.setRGB(x, y, -1); 
    	                } else { 
    	                    imagen.setRGB(x, y, -16777216); 
    	                } 
    	            } 
    	        } 
    	        return imagen; 
    	    } 

}
