package soporte.servicio;

import java.util.List;

import soporte.bean.NotariaBean;
import soporte.bean.OpcionMenuBean;
import soporte.dao.NotariaDAO;
import soporte.dao.OpcionMenuDAO;
import soporte.servicio.NotariaServicio.Enum_Con_Notaria;
import soporte.servicio.NotariaServicio.Enum_Lis_Notaria;
import soporte.servicio.NotariaServicio.Enum_Tra_Notaria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class OpcionMenuServico extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	OpcionMenuDAO opcionMenuDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_OpcionMenu {
		int principal = 1;
		int foranea = 2;		
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_OpcionMenu {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_OpcionMenu {
		int alta = 1;
		int modificacion = 2;
	}
	
	public OpcionMenuServico() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,OpcionMenuBean opcionMenu){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_OpcionMenu.alta:		
				mensaje = altaOpcion(opcionMenu);				
				break;				
			case Enum_Tra_OpcionMenu.modificacion:
				mensaje = modificaOpcion(opcionMenu);				
				break;
			
			
		}
		return mensaje;
	}
	
	
	public MensajeTransaccionBean altaOpcion(OpcionMenuBean opcionMenu){
		MensajeTransaccionBean mensaje = null;
		mensaje = opcionMenuDAO.alta(opcionMenu);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaOpcion(OpcionMenuBean opcionMenu){
		MensajeTransaccionBean mensaje = null;
		mensaje = opcionMenuDAO.modifica(opcionMenu);		
		return mensaje;
	}
	
	public OpcionMenuBean consulta(int tipoConsulta, OpcionMenuBean opcionMenuBean){
		OpcionMenuBean opcionMenu = null;
		switch (tipoConsulta) {
			case Enum_Con_OpcionMenu.principal:		
				opcionMenu = opcionMenuDAO.consultaPrincipal(opcionMenuBean, tipoConsulta);				
				break;	
			case Enum_Con_OpcionMenu.foranea:		
				opcionMenu = opcionMenuDAO.consultaForanea(opcionMenuBean, tipoConsulta);				
				break;				
		}
				
		return opcionMenu;
	}
	
	public List lista(int tipoLista, OpcionMenuBean opcionMenuBean){		
		List listaOpciones = null;
		switch (tipoLista) {
			case Enum_Lis_OpcionMenu.principal:		
				listaOpciones = opcionMenuDAO.listaPrincipal(opcionMenuBean, tipoLista);				
				break;				
		}		
		return listaOpciones;
	}	
		
	//------------------ Geters y Seters ------------------------------------------------------	

	public void setOpcionMenuDAO(OpcionMenuDAO opcionMenuDAO) {
		this.opcionMenuDAO = opcionMenuDAO;
	}
}
