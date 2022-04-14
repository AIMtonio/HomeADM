package tesoreria.controlador;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.commons.io.FileUtils;
import org.springframework.validation.BindException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.SimpleFormController;

import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import tesoreria.bean.FacturaprovBean;
import tesoreria.servicio.FacturaprovServicio;

public class FacturaprovFileUploadControlador extends SimpleFormController{
	FacturaprovServicio facturaprovServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	public static String  ImagenFactura="I" ;
	public static String  ArchivoXMLFact="A" ;
	public static String  SIActualizaFact="S" ;
	
	protected ModelAndView onSubmit(HttpServletRequest request,
			HttpServletResponse response,
			Object command,
			BindException errors) throws Exception{
		
		String[] extensValidas = {"txt","jpg","png","jpeg","gif","csv","xls","xlsx","tiff","pdf","doc","docx","xml"};
		boolean validaExt = false;
	
		FacturaprovBean facturaprovBean = (FacturaprovBean) command;
		FacturaprovBean facturaProvActBean = new FacturaprovBean();
		
		facturaProvActBean.setProveedorID(facturaprovBean.getProveedorID());
		facturaProvActBean.setNoFactura(facturaprovBean.getNoFactura());
		facturaProvActBean.setRutaImagenFact(facturaprovBean.getRutaImagenFact());
		facturaProvActBean.setRutaXMLFact(facturaprovBean.getRutaXMLFact());
		
		facturaprovServicio.getFacturaprovDAO().getParametrosAuditoriaBean().setNombrePrograma(request.getRequestURI().toString());
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String directorio = "";
		String archivoNombre ="";
		
		String ruta = request.getParameter("ruta");
		String extension = request.getParameter("extarchivo");
		String tipoArchivo =request.getParameter("tipoArchivo"); 
		String actualiza = request.getParameter("actualiza");
		
		for(String w : extensValidas)//Verfica que sea tio de archivo permitido
			validaExt|=extension.toLowerCase().endsWith(w);
		
		if(validaExt){
	
		int tipoTransaccion =(request.getParameter("tipoTransaccion")!=null)?
				Integer.parseInt(request.getParameter("tipoTransaccion")):
			0;
		int tipoActualizacion =(request.getParameter("tipoActualizacion")!=null)?
				Integer.parseInt(request.getParameter("tipoActualizacion")):
					0;

		
		directorio = ruta+"Tesoreria"+System.getProperty("file.separator")+"Facturas"+System.getProperty("file.separator");
		if(tipoArchivo.equals(ImagenFactura)){
			archivoNombre =directorio+"Proveedor"+facturaprovBean.getProveedorID()+System.getProperty("file.separator")+"ImgFactura"+
						   facturaprovBean.getNoFactura()+"_"+facturaprovBean.getProveedorID()+extension;
			facturaProvActBean.setRutaImagenFact(archivoNombre);
		}
		if(tipoArchivo.equals(ArchivoXMLFact)){

			archivoNombre =directorio+"Proveedor"+facturaprovBean.getProveedorID()+System.getProperty("file.separator")+"ArchivoFactura"
						   +facturaprovBean.getNoFactura()+"_"+facturaprovBean.getProveedorID()+extension;
			facturaProvActBean.setRutaXMLFact(archivoNombre);
	}
		
		if(actualiza.equals(SIActualizaFact)){
			mensaje = facturaprovServicio.grabaTransaccion(tipoTransaccion,facturaProvActBean,Constantes.STRING_VACIO,Constantes.STRING_VACIO,tipoActualizacion);
		}
		
		if(tipoArchivo.equals(ArchivoXMLFact)){
			
			
			ParametrosSisBean paramSisBean = new ParametrosSisBean();
			
			paramSisBean.setEmpresaID(facturaprovServicio.getFacturaprovDAO().getParametrosAuditoriaBean().getEmpresaID()+"");
			paramSisBean = parametrosSisServicio.consulta(21, paramSisBean);
			
			//Seccion de validacion de CFDI en el WS de SAT DE Consulta de CFDI
			if(paramSisBean.getValidaFactura().equalsIgnoreCase("S")){
				File archivoXML = null;
				MultipartFile file = facturaprovBean.getFile();
				String archivo=System.getProperty("java.io.tmpdir")+System.getProperty("file.separator")+facturaprovServicio.getFacturaprovDAO().getParametrosAuditoriaBean().getUsuario()+System.getProperty("file.separator")+file.getOriginalFilename();
				if (file != null) {
					archivoXML= new File(archivo);

					
					FileUtils.writeByteArrayToFile(archivoXML, file.getBytes());

				}
				facturaProvActBean = facturaprovServicio.leeXMLFactura(archivo);
				facturaProvActBean = facturaprovServicio.validaCFDI(facturaProvActBean,paramSisBean.getValidaFacturaURL(), paramSisBean.getTiempoEsperaWS());
				
				if(facturaProvActBean.getNumErrFacWS()!=0){
					archivoXML.delete();
					mensaje.setNumero(facturaProvActBean.getNumErrFacWS());
					mensaje.setDescripcion("No se pudo Digitalizar el Archivo XML <br/><br/>"+facturaProvActBean.getMensajeSalidaWS());
					mensaje.setConsecutivoString("");
					mensaje.setConsecutivoInt(tipoArchivo);
				}else{
					boolean exists = (new File(directorio)).exists();
					if (exists) {
						if (file != null) {
							File filespring = new File(archivoNombre);  
							FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
						}
					}else {
						File aDir = new File(directorio);
						aDir.mkdir();
						if (file != null) {
							File filespring = new File(archivoNombre);
							FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
						}
					}
					
					mensaje.setNumero(0);
					mensaje.setDescripcion("Archivo Digitalizado Exitosamente <br/><br/>"+facturaProvActBean.getMensajeSalidaWS());
					mensaje.setConsecutivoString(archivoNombre);
					mensaje.setConsecutivoInt(tipoArchivo);
					mensaje.setCampoGenerico(facturaProvActBean.getFolioUUID());
				}
			}else{
				
				boolean exists = (new File(directorio)).exists();
				if (exists) {
					MultipartFile file = facturaprovBean.getFile();
					
					if (file != null) {
						File filespring = new File(archivoNombre);  
						FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
					}
				}else {
					File aDir = new File(directorio);
					aDir.mkdir();
					MultipartFile file = facturaprovBean.getFile();
					if (file != null) {
						File filespring = new File(archivoNombre);
						FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
					}
				}
				
				facturaProvActBean = facturaprovServicio.leeXMLFactura(archivoNombre);
				
				mensaje.setNumero(0);
				mensaje.setDescripcion("Archivo Digitalizado Exitosamente ");
				mensaje.setConsecutivoString(archivoNombre);
				mensaje.setConsecutivoInt(tipoArchivo);
				mensaje.setCampoGenerico(facturaProvActBean.getFolioUUID());
			}
		}else{
			
			boolean exists = (new File(directorio)).exists();
			if (exists) {
				MultipartFile file = facturaprovBean.getFile();
				
				if (file != null) {
					File filespring = new File(archivoNombre);  
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
				}
			}else {
				File aDir = new File(directorio);
				aDir.mkdir();
				MultipartFile file = facturaprovBean.getFile();
				if (file != null) {
					File filespring = new File(archivoNombre);
					FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
				}
			}
			
			mensaje.setNumero(0);
			mensaje.setDescripcion("Archivo Digitalizado Exitosamente ");
			mensaje.setConsecutivoString(archivoNombre);
			mensaje.setConsecutivoInt(tipoArchivo);
		}
		}
		else 
			return new ModelAndView(getSuccessView(), "mensaje", null);
		return new ModelAndView(getSuccessView(), "mensaje", mensaje);
	}


	public void setFacturaprovServicio(FacturaprovServicio facturaprovServicio) {
		this.facturaprovServicio = facturaprovServicio;
	}


	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}


	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	

}

