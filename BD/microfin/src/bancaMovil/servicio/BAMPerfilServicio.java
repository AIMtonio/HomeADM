package bancaMovil.servicio;

import java.util.List;

import org.apache.log4j.Logger;
import bancaMovil.bean.BAMPerfilBean;
import bancaMovil.dao.BAMPerfilDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class BAMPerfilServicio  extends BaseServicio{
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");
	//---------- Variables ------------------------------------------------------------------------
	BAMPerfilDAO perfilDAO = null;

	public static interface Enum_Tra_Perfil {
		int alta		 = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_Perfil {
		int principal 		= 1;
	}

	public static interface Enum_Lis_Perfil {
		int principal 		= 1;	
	}

	public BAMPerfilServicio() {
		super();
		// TODO Auto-generated constructor stub
	}


	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, BAMPerfilBean perfil){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Perfil.alta:		
			mensaje = altaPerfil(perfil);				
			break;

		case Enum_Tra_Perfil.modificacion:		
			mensaje = modificaPerfil(perfil);				
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaPerfil(BAMPerfilBean perfil){
		MensajeTransaccionBean mensaje = null;
		mensaje = perfilDAO.altaPerfil(perfil);		
		return mensaje;
	}


	public MensajeTransaccionBean modificaPerfil(BAMPerfilBean perfil){
		MensajeTransaccionBean mensaje = null;
		mensaje = perfilDAO.modificaPerfil(perfil);		
		return mensaje;
	}


	public BAMPerfilBean consulta(int tipoConsulta, String numeroPerfil){
		BAMPerfilBean perfil = null;
		switch (tipoConsulta) {
		case Enum_Con_Perfil.principal:		
			perfil = perfilDAO.consultaPrincipal(Utileria.convierteEntero(numeroPerfil));				
			break;		
		}
		if(perfil!=null){
			perfil.setPerfilID(Utileria.completaCerosIzquierda(perfil.getPerfilID(), 3));
		}

		return perfil;
	}

	public List<?> lista(int tipoLista, BAMPerfilBean perfil){		
		List<?> listaPerfiles = null;
		switch (tipoLista) {
		case Enum_Lis_Perfil.principal:		
			listaPerfiles = perfilDAO.listaPrincipal(perfil);				
			break;
		}
		return listaPerfiles;
	}	
	
	public BAMPerfilDAO getPerfilDAO() {
		return perfilDAO;
	}


	public void setPerfilDAO(BAMPerfilDAO perfilDAO) {
		this.perfilDAO = perfilDAO;
	}

}
