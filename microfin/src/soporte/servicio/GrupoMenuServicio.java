package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;

import soporte.bean.GrupoMenuBean;
import soporte.dao.GrupoMenuDAO;


public class GrupoMenuServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	GrupoMenuDAO grupoMenuDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_GrupoMenu {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_GrupoMenu {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_GrupoMenu {
		int alta = 1;
		int modificacion = 2;
	}
	
	public GrupoMenuServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, GrupoMenuBean grupoMenu){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_GrupoMenu.alta:		
				mensaje = altaGrupo(grupoMenu);				
				break;				
			case Enum_Tra_GrupoMenu.modificacion:
				mensaje = modificaGrupo(grupoMenu);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaGrupo(GrupoMenuBean grupoMenu){
		MensajeTransaccionBean mensaje = null;
		mensaje = grupoMenuDAO.alta(grupoMenu);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaGrupo(GrupoMenuBean grupoMenu){
		MensajeTransaccionBean mensaje = null;
		mensaje = grupoMenuDAO.modifica(grupoMenu);		
		return mensaje;
	}
	
	public GrupoMenuBean consulta(int tipoConsulta, GrupoMenuBean grupoMenuBean){
		GrupoMenuBean grupoMenu = null;
		switch (tipoConsulta) {
			case Enum_Con_GrupoMenu.principal:		
				grupoMenu = grupoMenuDAO.consultaPrincipal(grupoMenuBean, tipoConsulta);				
				break;	
			case Enum_Con_GrupoMenu.foranea:		
				grupoMenu = grupoMenuDAO.consultaForanea(grupoMenuBean, tipoConsulta);				
			break;	
		}
				
		return grupoMenu;
	}
	
	public List lista(int tipoLista, GrupoMenuBean grupoMenuBean){		
		List listaGrupos = null;
		switch (tipoLista) {
			case Enum_Lis_GrupoMenu.principal:		
				listaGrupos = grupoMenuDAO.listaPrincipal(grupoMenuBean, tipoLista);				
				break;				
		}		
		return listaGrupos;
	}
	
	//------------------ Geters y Seters ------------------------------------------------------	

	public void setGrupoMenuDAO(GrupoMenuDAO grupoMenuDAO) {
		this.grupoMenuDAO = grupoMenuDAO;
	}	

}
