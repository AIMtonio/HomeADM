package cuentas.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cuentas.bean.TasasAhorroBean;
import cuentas.dao.TasasAhorroDAO;
public class TasasAhorroServicio extends BaseServicio {

	private TasasAhorroServicio(){
		super();
	}

	TasasAhorroDAO tasasAhorroDAO = null;

	public static interface Enum_Tra_TasasAhorro {
		int alta 		= 1;
		int modificacion= 2;
		int baja 		= 3;
	}

	public static interface Enum_Con_TasasAhorro{
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_TasasAhorro{
		int principal = 1;
		int foranea = 2;
		int portaContrato = 3; // lista de tasas para reporte Portada del contrato de cta
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TasasAhorroBean tasasAhorro){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_TasasAhorro.alta:
				mensaje = tasasAhorroDAO.alta(tasasAhorro);
				break;
			case Enum_Tra_TasasAhorro.modificacion:
				mensaje = tasasAhorroDAO.modifica(tasasAhorro);
				break;
			case Enum_Tra_TasasAhorro.baja:
				mensaje = tasasAhorroDAO.baja(tasasAhorro);
				break;
		}
		return mensaje;
	}

	public TasasAhorroBean consulta(int tipoConsulta, TasasAhorroBean tasasAhorro){
		TasasAhorroBean tasasAhorroBean = null;
		switch(tipoConsulta){
			case Enum_Con_TasasAhorro.principal:
				tasasAhorroBean = tasasAhorroDAO.consultaPrincipal(tasasAhorro, Enum_Con_TasasAhorro.principal);
			break;
			
		}
		return tasasAhorroBean;
	}
	

	public List lista(int tipoLista, TasasAhorroBean tasasAhorro){		
		List listaTiposCuenta = null;
		switch (tipoLista) {
			case Enum_Lis_TasasAhorro.principal:		
				listaTiposCuenta = tasasAhorroDAO.listaTasasAhorro(tasasAhorro, Enum_Lis_TasasAhorro.principal);				
			break;
			case Enum_Lis_TasasAhorro.foranea:		
				listaTiposCuenta = tasasAhorroDAO.listaTasasAhorro(tasasAhorro, Enum_Lis_TasasAhorro.foranea);				
			break;
			case Enum_Lis_TasasAhorro.portaContrato:		
				listaTiposCuenta = tasasAhorroDAO.listaPortadaContrato(tasasAhorro, Enum_Lis_TasasAhorro.portaContrato);				
			break;	
				
		}		
		return listaTiposCuenta;
	}


	public void setTasasAhorroDAO(TasasAhorroDAO tasasAhorroDAO) {
		this.tasasAhorroDAO = tasasAhorroDAO;
	}

}

