package contabilidad.servicio;

import general.bean.MensajeTransaccionArchivoBean;
import general.servicio.BaseServicio;

import java.io.File;
import java.util.List;

import org.apache.commons.io.FileUtils;
import org.springframework.web.multipart.MultipartFile;

import contabilidad.bean.PolizaArchivosBean;
import contabilidad.dao.PolizaArchivosDAO;

public class PolizaArchivosServicio extends BaseServicio{
	PolizaArchivosDAO polizaArchivosDAO=null;
	
	public PolizaArchivosServicio(){
		super();
	}
	//
	public static interface Enum_Tra_PolizaArchivos{
		int altaArchivosPoliza 			= 1;
		int cargaMasivaPoliza			= 2;
	}
	public static interface Enum_Con_archivosGarantia{
		int listaGRidArchivosPoliza 			= 2;
	}
	public static interface Enum_lis_CargaArchivos{
		int listaGRidArchivosPolizaExito		=1;
	}
	
	public static interface Enum_Baja_archivosGarantia{
		int bajaArchivosPoliza			=1;
	}
	
	
	
	public MensajeTransaccionArchivoBean grabaTransaccion(int tipoTransaccion, PolizaArchivosBean file, String directorio){
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_PolizaArchivos.altaArchivosPoliza:		
				mensaje = grabarDocumentos(file, directorio);
				break;	
			case Enum_Tra_PolizaArchivos.cargaMasivaPoliza:		
				mensaje = polizaArchivosDAO.cargaMasivaPoliza(file);				
				break;	
		}
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean bajaArchivosPoliza( PolizaArchivosBean file,int tipoBaja){
		MensajeTransaccionArchivoBean mensaje = null;
		try{
			switch (tipoBaja) {
			case Enum_Baja_archivosGarantia.bajaArchivosPoliza:		
				mensaje =  polizaArchivosDAO.bajaArchivosPoliza(file, Enum_Baja_archivosGarantia.bajaArchivosPoliza);	
				break;				
		}
		}catch(Exception e){
			e.printStackTrace();	
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en  baja de archivo poliza", e);
		}
		
		return mensaje;
	}

	public List lista(int tipoLista,  PolizaArchivosBean polizaArchivosBean){	
		List listaArchivosPoliza = null;
		switch (tipoLista) {
		case Enum_Con_archivosGarantia.listaGRidArchivosPoliza:		
			listaArchivosPoliza = polizaArchivosDAO.listaPolizaArchivos(polizaArchivosBean, tipoLista);				
			break;	
		}		
		return listaArchivosPoliza;
	}
	
	
	public MensajeTransaccionArchivoBean grabarDocumentos(PolizaArchivosBean poliArchivoBean, String directorio){
		MensajeTransaccionArchivoBean mensaje = null;
		
		String[] arrSplit = poliArchivoBean.getCadenaArchivos().trim().split("-");   
		try{
			for(int i = 0; i<poliArchivoBean.getListaArchivos().size(); i++){
				PolizaArchivosBean poliFileBean = new PolizaArchivosBean();
				poliFileBean.setPolizaID(poliArchivoBean.getPolizaID());
				poliFileBean.setObservacion(poliArchivoBean.getObservacion());
				poliFileBean.setRecurso(poliArchivoBean.getRecurso());
				poliFileBean.setExtension(arrSplit[i]);
				
				mensaje = polizaArchivosDAO.altaArchivosPoliza(poliFileBean);
				String recursoOrigen = mensaje.getRecursoOrigen();
				
				boolean grabarArchivo = grabarArchivo(poliFileBean, directorio, recursoOrigen, poliArchivoBean.getListaArchivos().get(i));
				
				if(mensaje.getNumero() != 0 || !grabarArchivo){
					throw new Exception(mensaje.getDescripcion());
				}
			}
		}catch(Exception e){
			return mensaje;
		}
		return mensaje;
	}
	
	private boolean grabarArchivo(PolizaArchivosBean polizaArchivosBean, String directorio, String recursoOrigen, Object archivo){
		try{
				boolean exists = (new File(directorio)).exists();
	    		if (exists) {
	    			MultipartFile file =  (MultipartFile) archivo;
	    			if (file != null) {
	    				File filespring = new File(recursoOrigen);  
	    				FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	          	   
	    		}else { 
	    			File aDir = new File(directorio);
	    			aDir.mkdir();
	    			MultipartFile file = (MultipartFile) archivo;
	            
	    			if (file != null) {
	    				File filespring = new File(recursoOrigen);  
	                  	FileUtils.writeByteArrayToFile(filespring, file.getBytes());  
	    			}
	    		}  
			return true;
		}catch(Exception e){
			return false;
		}		
	}
	

	public List listaCargaArchivos(String  numTransaccion, int tipoLista){	
		List listaArchivosPoliza = null;
		switch (tipoLista) {
		case Enum_lis_CargaArchivos.listaGRidArchivosPolizaExito:		
			listaArchivosPoliza = polizaArchivosDAO.listaRegistrosCargaPolizasETL(numTransaccion, tipoLista);				
			break;	
		}		
		return listaArchivosPoliza;
	}
	
	//---------------------setter y getter--------------------
	
	public PolizaArchivosDAO getPolizaArchivosDAO() {
		return polizaArchivosDAO;
	}


	public void setPolizaArchivosDAO(PolizaArchivosDAO polizaArchivosDAO) {
		this.polizaArchivosDAO = polizaArchivosDAO;
	}


	
	

}
