package soporte.dao;
import org.junit.Assert;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.codec.binary.Base64;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

import com.sun.org.apache.xerces.internal.parsers.DOMParser;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import soporte.FacturacionElectronicaWS;
import soporte.SmarterWebWS;
import soporte.bean.EdoCtaCertificadoBean;
import soporte.bean.EdoCtaParamsBean;
import soporte.bean.InstitucionesBean;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;

public class EdoCtaCertificadoDAO extends BaseDAO{
		ParametrosSisServicio parametrosSisServicio=null;
		EdoCtaParamsDAO edoCtaParamsDAO = null;
		InstitucionesDAO institucionesDAO = null;
		public EdoCtaCertificadoDAO(){
			super();		
		}
		
		public MensajeTransaccionBean guardar(final EdoCtaCertificadoBean edoCtaCertificadoBean) throws IOException{			
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			//SE INSTANCIA LA CLASE PARAMETROSSIS PARA LA CONSULTA DE EL USUARIO, CONTRASEÑA Y RFC NECESARIAS PARA LA FACTURACIÓN ELECTRONICA
			int tipoConsulta=5;
			int tipoConsultaInst = 10;
			ParametrosSisBean paramBean = new ParametrosSisBean();	
			ParametrosSisBean paramInstitBean = new ParametrosSisBean();	
			EdoCtaParamsBean edoCtaParamsBean = new EdoCtaParamsBean(); 		
			paramBean = parametrosSisServicio.consulta(tipoConsulta,paramBean);
			paramInstitBean = parametrosSisServicio.consulta(tipoConsultaInst,paramInstitBean);
			FacturacionElectronicaWS facturacionElectronicaWS = null;
			SmarterWebWS smarterWebWS = null;
			
			if(paramInstitBean.getNombreCortoInst().equals("CREDICLUB"))
			{
				int tipoParams = 3; 
				edoCtaParamsBean = edoCtaParamsDAO.consultaParamSW(tipoParams);
				smarterWebWS=new SmarterWebWS(edoCtaParamsBean.getuRLWSSmarterWeb(), edoCtaParamsBean.getTokenSW());
			}
			else{

				facturacionElectronicaWS=new FacturacionElectronicaWS(paramBean.getUrlWSDLFactElec(), paramBean.getUsuarioFactElect(),
																		paramBean.getPassFactElec(),paramBean.getRfcEmpresa());
			}
			File archivoKey=new File(edoCtaCertificadoBean.getRutaCompletaKey());
			File archivoCer=new File(edoCtaCertificadoBean.getRutaCompletaCer());
			
			String contrasena=edoCtaCertificadoBean.getContrasena();							
			String mensajeSalida="",StringKeyBase64="",StringCerBase64="";
			
			try {										 						
					byte[] bytesKey = 	convierteBase64(archivoKey);
					byte[] bytesCer	=	convierteBase64(archivoCer);
					byte[] codificadoKey = Base64.encodeBase64(bytesKey);
					byte[] codificadoCer = Base64.encodeBase64(bytesCer);
					StringKeyBase64 = new String(codificadoKey);
					StringCerBase64 = new String(codificadoCer);
					
					if(paramInstitBean.getNombreCortoInst().equals("CREDICLUB")){
						String exitoSW = "success";
						mensajeSalida = smarterWebWS.enviarCertificadoSW(StringKeyBase64, StringCerBase64, contrasena);
						
						if(!mensajeSalida.equalsIgnoreCase(exitoSW)){
							mensaje.setNumero(3);			
							mensaje.setDescripcion("Error en la subida de certificado.");	
							mensaje.setNombreControl("contrasena");				
							mensaje.setConsecutivoString("");
						}
						else{
							mensaje.setNumero(0);
							mensaje.setDescripcion("Subida de certificados completada exitosamente");	
							mensaje.setNombreControl("contrasena");				
							mensaje.setConsecutivoString("");
						}
					}
					else{
						mensajeSalida=facturacionElectronicaWS.enviarCertificado(StringKeyBase64,StringCerBase64,contrasena);
						
						if(mensajeSalida.contains("Cancelacion de CFDI se ha activado satisfactoriamente")){											
							mensaje.setNumero(0);
							mensaje.setDescripcion("Cancelación de CFDI se ha activado satisfactoriamente");	
							mensaje.setNombreControl("contrasena");				
							mensaje.setConsecutivoString("");																		
						}else{
							DOMParser parser = new DOMParser();
						    try {
								parser.parse(new InputSource(new java.io.StringReader(mensajeSalida)));
							} catch (SAXException e) {
								mensaje.setNumero(3);			
								mensaje.setDescripcion("Error al codificar mensaje de error.");	
								mensaje.setNombreControl("contrasena");				
								mensaje.setConsecutivoString("");
							}
						    Document doc = parser.getDocument();
						    NodeList listaNodoCodigo = doc.getElementsByTagName("faultcode");
						    Element elemento = (Element) listaNodoCodigo.item(0);
					        String codigoError = elemento.getFirstChild().getNodeValue();
					        NodeList listaNodoNombre = doc.getElementsByTagName("faultstring");
						    Element elemento2 = (Element) listaNodoNombre.item(0);
					        String nombreError = elemento2.getFirstChild().getNodeValue();				        
					        if(nombreError.contains("Contrasenia")){				        	
					        	nombreError=nombreError.replace("Contrasenia","Contraseña");
					        }
					        if(codigoError.contains("-")){
					        	mensaje.setNumero(Integer.parseInt(codigoError.substring(codigoError.lastIndexOf("-"))));	
					        }else{
					        	mensaje.setNumero(Integer.parseInt(codigoError));				       
					        }						
							mensaje.setDescripcion(nombreError);
							mensaje.setNombreControl("contrasena");
							mensaje.setConsecutivoString("");
						}
					}
			} catch (Exception e) {				
				mensaje.setNumero(2);			
				mensaje.setDescripcion("Error al procesar los datos");	
				mensaje.setNombreControl("contrasena");				
				mensaje.setConsecutivoString("");	
				loggerSAFI.error(e);
			}
										
			return mensaje;			
		}
		
		private static byte[] convierteBase64(File archivo) throws IOException {
			InputStream is = new FileInputStream(archivo);			 
			long length = archivo.length();
			
			if (length > Integer.MAX_VALUE) {
						// archivo es muy grande
			}
			byte[] bytes = new byte[(int)length];
			int fueraRango = 0;
			int numLeido = 0;
			while (fueraRango < bytes.length && (numLeido=is.read(bytes, fueraRango, bytes.length-fueraRango)) >= 0) {
				fueraRango += numLeido;
			}			 
			if (fueraRango < bytes.length) {
				throw new IOException("No se pudo completar la lectura del archivo "+archivo.getName());
			}			 
			is.close();
			return bytes;
	    }
		public ParametrosSisServicio getParametrosSisServicio() {
			return parametrosSisServicio;
		}

		public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
			this.parametrosSisServicio = parametrosSisServicio;
		}

		public EdoCtaParamsDAO getEdoCtaParamsDAO() {
			return edoCtaParamsDAO;
		}

		public void setEdoCtaParamsDAO(EdoCtaParamsDAO edoCtaParamsDAO) {
			this.edoCtaParamsDAO = edoCtaParamsDAO;
		}

		public InstitucionesDAO getInstitucionesDAO() {
			return institucionesDAO;
		}

		public void setInstitucionesDAO(InstitucionesDAO institucionesDAO) {
			this.institucionesDAO = institucionesDAO;
		}
}

