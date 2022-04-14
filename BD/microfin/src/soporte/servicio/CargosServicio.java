package soporte.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import soporte.bean.CargosBean;
import soporte.dao.CargosDAO;


public class CargosServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CargosDAO cargosDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Cargos {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Cargos {
		int principal = 1;
		int foranea   = 2;
		int plazas    = 3;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_Cargos {
		int alta = 1;
		int modificacion = 2;
	}
	
	public CargosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CargosBean cargos){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Cargos.alta:		
				mensaje = altaCargos(cargos);				
				break;				
			case Enum_Tra_Cargos.modificacion:
				mensaje = modificaCargos(cargos);				
				break;
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaCargos(CargosBean cargos){
		MensajeTransaccionBean mensaje = null;		
		mensaje = cargosDAO.alta(cargos);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaCargos(CargosBean cargos){
		MensajeTransaccionBean mensaje = null;
		mensaje = cargosDAO.modifica(cargos);		
		return mensaje;
	}
	
	
	public CargosBean consulta(int tipoConsulta, CargosBean cargosBean){
		CargosBean cargos = null;
		System.out.println("tipoConsulta: " + tipoConsulta);
		switch (tipoConsulta) {
		
			case Enum_Con_Cargos.principal:		
				cargos = cargosDAO.consultaPrincipal(cargosBean, tipoConsulta);				
				break;	
			case Enum_Con_Cargos.foranea:		
				cargos = cargosDAO.consultaForanea(cargosBean, tipoConsulta);				
			break;	
		}
				
		return cargos;
	}
	
	public List lista(int tipoLista,CargosBean cargosBean){		
		List listaCargos = null;
		switch (tipoLista) {
			case Enum_Lis_Cargos.principal:
				listaCargos = cargosDAO.listaPrincipal(cargosBean, tipoLista);
				break;
		}
		return listaCargos;
	}


	public CargosDAO getCargosDAO() {
		return cargosDAO;
	}


	public void setCargosDAO(CargosDAO cargosDAO) {
		this.cargosDAO = cargosDAO;
	}

	
		

		
}

