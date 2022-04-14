package herramientas;

import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;

import javax.imageio.ImageIO;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.client.j2se.MatrixToImageWriter;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.oned.Code128Writer;

public class GenerateBarCode {
	
	// generar codigo de baras con barbecue 350 150
	public static BufferedImage generaCodigoBarra(String codigo, int ancho, int alto) throws Exception{
		BitMatrix  bitMatrix = new Code128Writer().encode( codigo,
                BarcodeFormat.CODE_128,
                ancho,
                alto,
                null
                );		
		return MatrixToImageWriter.toBufferedImage(bitMatrix);
	}

	public static byte[] generaCodigoBarraByte(String codigo, int ancho, int alto) throws Exception{
		ByteArrayOutputStream salida = new ByteArrayOutputStream();
		BufferedImage imagen = null;
		byte[] imagenByte = null;
		try {
			
			System.out.println("Codigo a pasar = "+codigo);
			imagen = GenerateBarCode.generaCodigoBarra(codigo,ancho,alto);
			ImageIO.write(imagen, "png", salida);
			salida.flush();
			imagenByte = salida.toByteArray();
			System.out.println("codigo base 64 "+Utileria.bytesToStr64(imagenByte));
			salida.close();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			System.err.println("Erro al "+e);
			salida.close();
		}
		return imagenByte;
	}
	public static String generaCodigoBarraStr64(String codigo, int ancho, int alto) throws Exception{
		ByteArrayOutputStream salida = new ByteArrayOutputStream();
		BufferedImage imagen = null;
		byte[] imagenByte = null;
		try {
			
			System.out.println("Codigo a pasar = "+codigo);
			imagen = GenerateBarCode.generaCodigoBarra(codigo,ancho,alto);
			ImageIO.write(imagen, "png", salida);
			salida.flush();
			imagenByte = salida.toByteArray();
			System.out.println("codigo base 64 "+Utileria.bytesToStr64(imagenByte));
			salida.close();
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			System.err.println("Erro al "+e);
			salida.close();
		}
		return Utileria.bytesToStr64(imagenByte);
	}
}
