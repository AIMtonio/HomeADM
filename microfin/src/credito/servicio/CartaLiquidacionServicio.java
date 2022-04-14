package credito.servicio;

import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.nio.charset.CharsetEncoder;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.common.BitMatrix;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.client.j2se.MatrixToImageWriter;

import credito.bean.CartaLiquidacionBean;
import credito.bean.CreditosArchivoBean;
import credito.dao.CartaLiquidacionDAO;
import credito.dao.CreditoArchivoDAO;
import general.bean.MensajeTransaccionArchivoBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class CartaLiquidacionServicio extends BaseServicio {
	/*
	* Referencias necesarias
	*/
	CartaLiquidacionDAO cartaLiquidacionDAO = null;
	CreditoArchivoDAO creditoArchivoDAO		= null;

	/*
	* Interface para el control de las transacciones disponibles
	*/
	public static interface Enum_Transaccion {
		int alta = 1;
		int modifica = 2;
	}

	/*
	* Interface para el control de las consultas disponibles
	*/
	public static interface Enum_Consulta {
		int principal = 1;
		int consultaRecurso = 2;
		int montoProyectado = 3;
		int consultaCreditoCliente = 4;
	}

	/*
	* Interface para el control de las listas disponibles
	*/
	public static interface Enum_Lista {
		int principal = 1;
	}

	/*
	* Contructor de la clase
	*/
	public CartaLiquidacionServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * Metodo principal para las transacciones Alta,Modificacion,Actualizacio y Baja
	 * @param instance Modelo requerido
	 * @param tipoTransaccion Tipo de Transaccion
	 * @param tipoActualizacion Tipo de Actualizacion
	 * @return MensajeTransaccionBean Modelo que retorna una vez realizada la operacion
	 * 	
	 * generar el alta
	 * consltar proyectado(si es que es requeriido)
	 * generar el QR
	 * ejecutar el act tipo 2
	 */
	public MensajeTransaccionBean grabaTransaccion(CartaLiquidacionBean instance, int tipoTransaccion, int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Transaccion.alta:
				mensaje = alta(instance);
				break;
			case Enum_Transaccion.modifica:
				mensaje = cartaLiquidacionDAO.modifica(instance, tipoActualizacion);
		}
		return mensaje;
	}

	/**
	 * Metodo para realizar las diferentes consultas
	 * @param instance Modelo requerido
	 * @param tipoConsulta Tipo de Transaccion
	 * @return CartaLiquidacionBean Modelo que retorna una vez realizada la operacion
	 */
	public CartaLiquidacionBean consulta(CartaLiquidacionBean instance, int tipoConsulta){
		CartaLiquidacionBean cartaLiquidacionBean = null;
		switch (tipoConsulta) {
			case Enum_Consulta.principal:
				cartaLiquidacionBean = cartaLiquidacionDAO.consulta(instance, tipoConsulta);
				break;
			case Enum_Consulta.consultaRecurso:
				cartaLiquidacionBean = cartaLiquidacionDAO.consultaRecurso(instance, tipoConsulta);
				break;
			case Enum_Consulta.montoProyectado:
				cartaLiquidacionBean = cartaLiquidacionDAO.consultaMontoPoyectado(instance, tipoConsulta);
				break;
			case Enum_Consulta.consultaCreditoCliente:
				cartaLiquidacionBean = cartaLiquidacionDAO.consulta(instance, tipoConsulta);
				break;
		}
		return cartaLiquidacionBean;
	}
	
	/**
	 * Método para dar de alta una carta de liquidación, generar y guardar código QR
	 * @params CartaLiquidacionBean 
	 **/
	
	public MensajeTransaccionBean alta(CartaLiquidacionBean instance) {
		int tipoConsulta = 3;
		int tipoTransaccion = 2;
		int tipoActualizacion = 2;
		CartaLiquidacionBean cartaLiqBean = null;
		MensajeTransaccionBean mensaje = null;
		MensajeTransaccionBean mensajeQR = null;
		
		// dar de alta la carta Liquidación
		mensaje = cartaLiquidacionDAO.alta(instance);
		if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000) {			
			// consultar el MontoProyectado
			cartaLiqBean = consulta(instance, tipoConsulta);			
			if(cartaLiqBean != null) {				
				byte[] qrImage = generarCodgoQR(cartaLiqBean);
				instance.setCartaLiquidaID(mensaje.getCampoGenerico());
				instance.setQrImage(qrImage);
				mensajeQR = grabaTransaccion(instance, tipoTransaccion, tipoActualizacion);
			}
		}
		
		return mensaje;
	}
	
	
	public MensajeTransaccionArchivoBean altaCredito(CartaLiquidacionBean cartaLiquidBean) {
		int tipoTransaccion = 2;
		int tipoActualizacion = 1;
		MensajeTransaccionArchivoBean mensaje = null;
		MensajeTransaccionBean mensajeAct = null;
		
		CreditosArchivoBean crediArchivos = new CreditosArchivoBean();
		String creditoID = cartaLiquidBean.getCreditoID();
		if(cartaLiquidBean.getClienteID() != null) {
			crediArchivos.setRecurso("Creditos/Credito"+creditoID+"/CartaLiquidacion");
			crediArchivos.setCreditoID(cartaLiquidBean.getCreditoID());
			crediArchivos.setTipoDocumentoID("9995");
			crediArchivos.setComentario(cartaLiquidBean.getCreditoID() + " - Cliente " + cartaLiquidBean.getClienteID() + " "
										+ cartaLiquidBean.getCliente() + " - Carta de liquidación Interna al " 
										+ Utileria.convertirFechaLetras(cartaLiquidBean.getFechaVencimiento()));
			crediArchivos.setExtension(".pdf");
			
			mensaje = creditoArchivoDAO.altaArchivosCredito(crediArchivos);
			
			if(mensaje.getNumero() == 0 || mensaje.getNumero() == 000) {
				cartaLiquidBean = consulta(cartaLiquidBean, 1);
				cartaLiquidBean.setCreditoID(creditoID);
				cartaLiquidBean.setArchivoIdCarta(mensaje.getConsecutivoString());

				mensajeAct = grabaTransaccion(cartaLiquidBean, tipoTransaccion, tipoActualizacion);
			}
		}	
		
		return mensaje;
	}
	
	/**
	 * Método para la generación de QR
	 **/
	public byte[] generarCodgoQR(CartaLiquidacionBean cartaLiqBean) {
		byte[] qrImage = null;
		try {			
			Charset charset = Charset.forName("ISO-8859-1");
			CharsetEncoder encoder = charset.newEncoder();
			
			String textoQR = cartaLiqBean.getCreditoID() + " | " + cartaLiqBean.getMontoProyectado() + " | " + cartaLiqBean.getUsuarioGenara() + " | " + Utileria.convertirFechaLetras(cartaLiqBean.getFechaGeneracion());
			
			ByteBuffer bbuf = encoder.encode(CharBuffer.wrap(textoQR));
			byte[] b = bbuf.array();
			String data = new String(b, "ISO-8859-1");
			QRCodeWriter writter = new QRCodeWriter();
			
			BitMatrix matrix = writter.encode(data, BarcodeFormat.QR_CODE, 500, 500);
			
			// genera la imagen del QR
			ByteArrayOutputStream baos = new ByteArrayOutputStream();
			MatrixToImageWriter.writeToStream(matrix, "PNG", baos);
			qrImage = baos.toByteArray();
		}catch (Exception ex) { 
			ex.printStackTrace();
			return qrImage;
		}
		
		return qrImage;
	}

	/**
	 * Método para la generación del reporte en PDF 
	 **/
	public ByteArrayOutputStream reporteCartaLiquidacionPDF(CartaLiquidacionBean cartaLiquidacionBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_CreditoID", cartaLiquidacionBean.getCreditoID());	
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/** 
	 * Setters y Getters
	 **/
	
	public CartaLiquidacionDAO getCartaLiquidacionDAO() {
		return cartaLiquidacionDAO;
	}
	public void setCartaLiquidacionDAO(CartaLiquidacionDAO dao) {
		this.cartaLiquidacionDAO = dao;
	}
	
	public CreditoArchivoDAO getCreditoArchivoDAO() {
		return creditoArchivoDAO;
	}
	public void setCreditoArchivoDAO(CreditoArchivoDAO dao) {
		this.creditoArchivoDAO = dao;
	}
}
