package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import pld.dao.EstadosPreocupantesDAO;


public class EstadosPreocupantesServicio extends BaseServicio{

	private EstadosPreocupantesServicio(){
		super();
	}

	EstadosPreocupantesDAO estadosPreocupantesDAO = null;

/*	public static interface Enum_Tra_EstadosPreocupantes {
		int alta = 1;
		int modificacion = 2;
	}*/

	/*public static interface Enum_Con_EstadosPreocupantes{
		int principal = 1;
		int foranea = 2;	
		int tiposCuenta = 3;	
	}*/

	public static interface Enum_Lis_EstadosPreocupantes{
		int principal = 1;
		//int foranea = 2;
	}

	/*public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposCuentaBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_TiposCuenta.alta:
			mensaje = altaCuentasAho(cuentasAho);
			break;
		case Enum_Tra_TiposCuenta.modificacion:
			mensaje = modificaCuentasAho(cuentasAho);
			break;
		}

		return mensaje;
	}

	public MensajeTransaccionBean altaCuentasAho(TiposCuentaBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposCuentaDAO.altaTiposCuenta(cuentasAho);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaCuentasAho(TiposCuentaBean cuentasAho){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposCuentaDAO.modifica(cuentasAho);		
		return mensaje;
	}	


	public TiposCuentaBean consulta(int tipoConsulta, TiposCuentaBean tiposCuenta){
		TiposCuentaBean tiposCuentaBean = null;
		switch (tipoConsulta) {
			case Enum_Con_TiposCuenta.principal:		
				tiposCuentaBean = tiposCuentaDAO.consultaPrincipal(tiposCuenta, tipoConsulta);				
				break;				
			case Enum_Con_TiposCuenta.foranea:
				tiposCuentaBean = tiposCuentaDAO.consultaForanea(tiposCuenta, tipoConsulta);
				break;
			case Enum_Con_TiposCuenta.tiposCuenta:
				tiposCuentaBean = tiposCuentaDAO.consultaTiposCuenta(tiposCuenta, tipoConsulta);
				break;
			
		}
		if(tiposCuentaBean!=null){
			tiposCuentaBean.setTipoCuentaID(tiposCuentaBean.getTipoCuentaID());
		}
		
		return tiposCuentaBean;
	}
	*/

	
	/*public List lista(int tipoLista, TiposCuentaBean tiposCuentaBean){		
		List listaTiposCuenta = null;
		switch (tipoLista) {
			case Enum_Lis_TiposCuenta.principal:		
				listaTiposCuenta = tiposCuentaDAO.listaPrincipal(tiposCuentaBean, tipoLista);				
				break;				
		}		
		return listaTiposCuenta;
	}*/

	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		
		List listaEstadosPreocupantes = null;
		
		switch(tipoLista){
			case (Enum_Lis_EstadosPreocupantes.principal): 
				listaEstadosPreocupantes =  estadosPreocupantesDAO.listaPrincipal(tipoLista);
				break;
			
		}
		
		return listaEstadosPreocupantes.toArray();		
	}

	public void setEstadosPreocupantesDAO(EstadosPreocupantesDAO estadosPreocupantesDAO) {
		this.estadosPreocupantesDAO = estadosPreocupantesDAO;
	}

}
