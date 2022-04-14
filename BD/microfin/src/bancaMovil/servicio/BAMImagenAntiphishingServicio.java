package bancaMovil.servicio;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import bancaMovil.bean.BAMImagenAntiphishingBean;
import bancaMovil.dao.BAMImagenAntiphishingDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;




	public class BAMImagenAntiphishingServicio  extends BaseServicio {
		//---------- Variables ------------------------------------------------------------------------
		BAMImagenAntiphishingDAO imagenAntiphishingDAO = null;			   

		//---------- Tipo de Consulta ----------------------------------------------------------------
		public static interface Enum_Con_File {
			int principalC 		= 1;	
		}
		
		//---------- Tipo de Lista ----------------------------------------------------------------
		public static interface Enum_Lis_File {
			int principalC 			= 1;
		}

		//---------- Tipo de Lista ----------------------------------------------------------------	
		public static interface Enum_Tra_File {
			int altaC 			= 1;
			int modificacionC 	= 2;
			int bajaC 			= 3;
			
		}
		
		public static interface Enum_Act_File {
			int baja  			= 1;
			
		}
		public BAMImagenAntiphishingServicio () {
			super();
			// TODO Auto-generated constructor stub
		}	
		
		/*Graba transaccion para archivos de las imagenes*/
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, BAMImagenAntiphishingBean imagen){
			MensajeTransaccionBean mensaje = null;
			switch (tipoTransaccion) {
				case Enum_Tra_File.altaC:		
					mensaje = procesaImagen(imagen);			
					break;				
				case Enum_Tra_File.modificacionC:
					mensaje =  altaImagen(imagen);				
					break;
				case Enum_Tra_File.bajaC:
					mensaje =  bajaImagen(Utileria.convierteEntero(imagen.getImagenAntiphishingID()),Enum_Act_File.baja);				
					break;
				
			}
			return mensaje;
		}
		
		public List lista(int tipoLista, BAMImagenAntiphishingBean imagen){	
			List listaImagenes = null;
			switch (tipoLista) {
			case Enum_Lis_File.principalC:		
				listaImagenes= imagenAntiphishingDAO.listaPrincipal(imagen, tipoLista);				
				break;
			}
			return listaImagenes;
		}
		private MensajeTransaccionBean procesaImagen(BAMImagenAntiphishingBean imagenBean){
			MensajeTransaccionBean mensaje = null;
			String estatusActivo = "A";
			FileInputStream imageInFile;
			MultipartFile multipartFile = imagenBean.getFile();		
	    	
	    	//Convertimos el MultiPartFile a File y trasformamos a BASE64	    	
	        File convFile = new File(multipartFile.getOriginalFilename());
	        try {
	        	loggerSAFI.info(imagenBean.getDescripcion());
				convFile.createNewFile();
				FileOutputStream fos = new FileOutputStream(convFile); 
		        fos.write(multipartFile.getBytes());
		        fos.close(); 
		        imageInFile = new FileInputStream(convFile);
	            byte imageData[] = new byte[(int) convFile.length()];
	            imageInFile.read(imageData);
	            
	            //Converting Image byte array into Base64 String
		        String imageDataString = Utileria.bytesToStr64(imageData);
		        imagenBean.setImagenBinaria(imageDataString);
				imagenBean.setEstatus(estatusActivo);
				imagenBean.setImagenAntiphishingID(Constantes.STRING_CERO);
				
				mensaje = altaImagen(imagenBean);
		
				if (mensaje.getNumero() != Constantes.CODIGO_SIN_ERROR) {
					throw new Exception(mensaje.getDescripcion());
				}
				
		        
			} catch (Exception e) {
				if (mensaje == null) {
					mensaje = new MensajeTransaccionBean();
					mensaje.setNumero(010000);
					mensaje.setDescripcion(e.getMessage());
				}
				loggerSAFI.info("Error al procesar la imagen"+ e.getMessage());
				e.printStackTrace();
			} 
	        return mensaje;
			
		}
		
		public MensajeTransaccionBean altaImagen(BAMImagenAntiphishingBean imagen){
			MensajeTransaccionBean mensaje = null;
			mensaje = imagenAntiphishingDAO.altaImagenes(imagen);		
			return mensaje;
		}
		
		public MensajeTransaccionBean bajaImagen(int imagenID,int tipoAct){
			MensajeTransaccionBean mensaje = null;
			mensaje = imagenAntiphishingDAO.bajaImagenes(imagenID);		
			return mensaje;
		}

		public BAMImagenAntiphishingDAO getImagenAntiphishingDAO() {
			return imagenAntiphishingDAO;
		}

		public void setImagenAntiphishingDAO(
				
				BAMImagenAntiphishingDAO imagenAntiphishingDAO) {
			this.imagenAntiphishingDAO = imagenAntiphishingDAO;
		}

		public BAMImagenAntiphishingBean consulta(int tipoConsulta, int imagenPhishingID){
			BAMImagenAntiphishingBean imagen = null;
			switch (tipoConsulta) {
				case Enum_Con_File.principalC:		
					imagen = imagenAntiphishingDAO.consultaPrincipal(imagenPhishingID, tipoConsulta);	
					break;	
			}
					
			return imagen;
		}


	}
