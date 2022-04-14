package ventanilla.servicio;

import java.util.List;

import cliente.bean.ClienteArchivosBean;
import cliente.servicio.ClienteArchivosServicio.Enum_Tra_ArchivoClienteBaja;
import general.bean.MensajeTransaccionArchivoBean;
import general.servicio.BaseServicio;
import ventanilla.bean.UsuarioServiciosBean;
import ventanilla.dao.UsuarioArchivosDAO;

public class UsuarioArchivosServicio extends BaseServicio {
	UsuarioArchivosDAO usuarioArchivosDAO = null;
	
	 
	public static interface Enum_Tra_File {
		int altaArchivo		= 1;
		int modificacionC 	= 2;
	}
	
	public static interface Enum_Tra_ArchivoUsuarioBaja{
		int bajaPorFolio    = 1; //baja principal de archivos de crédito
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Archivo {
		int principal 			= 1;
		int porInstrumento		= 2;
	}

	public UsuarioArchivosServicio() {
		// TODO Auto-generated constructor stub
	}
	

	/*Graba transaccion para archivos de los Clientes*/
	public MensajeTransaccionArchivoBean grabaTransaccion(int tipoTransaccion, UsuarioServiciosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_File.altaArchivo:		
				mensaje = altaArchivoUsuario(file);				
				break;				
			/*case Enum_Tra_File.modificacionC:
				mensaje = altaArchivosCliente(file);				
				break;
			case Enum_Tra_File.bajaC: 
				mensaje = altaArchivoCliente(file);			
				break;
				*/
		}
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean altaArchivoUsuario(UsuarioServiciosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		mensaje = usuarioArchivosDAO.altaArchivo(file);		
		return mensaje;
	}
	
	public MensajeTransaccionArchivoBean bajaArchivos(int tipoBaja,UsuarioServiciosBean file){
		MensajeTransaccionArchivoBean mensaje = null;
		try{
			switch (tipoBaja) {
			case Enum_Tra_ArchivoUsuarioBaja.bajaPorFolio:		
				mensaje = usuarioArchivosDAO.bajaArchivos(file);		
				break;				
		}
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en transaccion de usuario", e);
		}
		
		return mensaje;
	}
	
	/*Lista de archivos del Usuario de Servicios*/
	public List listaArchivosUsuario(int tipoLista, UsuarioServiciosBean fileBean){		
		List listaArchClient = null;
		switch (tipoLista) {
			case Enum_Lis_Archivo.principal:		
				listaArchClient = usuarioArchivosDAO.listaArchivosUsuario(fileBean, tipoLista);				
				break;
		}		
		return listaArchClient;
	}


	public UsuarioArchivosDAO getUsuarioArchivosDAO() {
		return usuarioArchivosDAO;
	}


	public void setUsuarioArchivosDAO(UsuarioArchivosDAO usuarioArchivosDAO) {
		this.usuarioArchivosDAO = usuarioArchivosDAO;
	}
	
	

}
