package cedes.servicio;

import java.util.ArrayList;
import java.util.List;

import cuentas.bean.TasasAhorroBean;
import cuentas.servicio.TasasAhorroServicio.Enum_Lis_TasasAhorro;
import soporte.bean.PlazasBean;
import soporte.servicio.PlazasServicio.Enum_Tra_Plaza;
import cedes.bean.TasasCedesBean;
import cedes.dao.TasasCedesDAO;
import cedes.servicio.MontosCedesServicio.Enum_Con_MontosCedes;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TasasCedesServicio extends BaseServicio{
	TasasCedesDAO tasasCedesDAO = null;

	

	public TasasCedesServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	 
	
	public static interface Enum_Tra_TasasCedes {
		int alta				= 1;
		int modifica			= 2;
		int elimina				= 3;
	}
	
	
	public static interface Enum_Con_TasasCedes {
		int principal				    = 1;
		int tasa				   		= 2;
		int tasaVariable				= 3;
	}
	
	public static interface Enum_Lis_TasasCedes {
		int principal				    = 1;
		int grid 						= 2;
		int reporte						= 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TasasCedesBean tasas, String tasa){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_TasasCedes.alta:	
				ArrayList listaSucursales = (ArrayList) creaListaDetalle(tasas);		
				mensaje = tasasCedesDAO.procesarAlta(tasas,listaSucursales);			
				break;				
			case Enum_Tra_TasasCedes.modifica:
				ArrayList listaSucursalesM = (ArrayList) creaListaDetalle(tasas);	
				mensaje =tasasCedesDAO.procesarModificacion(tasas,listaSucursalesM,tasa);
				break;
			case Enum_Tra_TasasCedes.elimina:
				mensaje = tasasCedesDAO.eliminaTasas(tasas,Enum_Tra_TasasCedes.alta);				
				break;
		
		}
		return mensaje;
	}
	
	
	public TasasCedesBean consulta(int tipoConsulta,TasasCedesBean tasasCedesBean){
		TasasCedesBean tasaCedesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_TasasCedes.principal:		
				tasaCedesBean = tasasCedesDAO.consultaPrincipal(tasasCedesBean, Enum_Con_MontosCedes.principal);
				break;
			case Enum_Con_TasasCedes.tasaVariable:	
				tasaCedesBean = tasasCedesDAO.consultaTasaVariable(tasasCedesBean, tipoConsulta);				
				break;					
			case Enum_Con_TasasCedes.tasa:
				tasaCedesBean = tasasCedesDAO.consultaTasa(tasasCedesBean);
				break;

		}
		return tasaCedesBean;
	}
	
	
	public List lista(int tipoLista, TasasCedesBean bean){		
		List listaTasas = null;
		switch (tipoLista) {
			case Enum_Lis_TasasCedes.principal:		
				listaTasas = tasasCedesDAO.listaPrincipal(bean, tipoLista);				
			break;
			case Enum_Lis_TasasCedes.grid:		
				listaTasas = tasasCedesDAO.listaGrid(bean, tipoLista);				
			break;
		}		
		return listaTasas;
	}
	
	public Object[] listaCombo(int tipoLista, TasasCedesBean bean){		
		List listaTasas = null;
		switch (tipoLista) {
			case Enum_Lis_TasasCedes.reporte:		
				listaTasas = tasasCedesDAO.listaReporte(bean, tipoLista);				
			break;
		}		
		return listaTasas.toArray();
	}
	
	/* Arma la lista de beans */
	public List creaListaDetalle( TasasCedesBean bean) {		
		
		List<String> sucursales  = bean.getlSucursalID();
		List<String> estados	 = bean.getlEstadoID();
		List<String> estatus	 = bean.getlEstatus();

		ArrayList listaDetalle = new ArrayList();
		TasasCedesBean beanAux = null;	
		
		if(sucursales != null){
			int tamanio = sucursales.size();			
			for (int i = 0; i < tamanio; i++ ) {
					beanAux = new TasasCedesBean();				
					beanAux.setTipoCedeID(bean.getTipoCedeID());
					beanAux.setSucursalID(sucursales.get(i));
					beanAux.setEstadoID(estados.get(i));
					beanAux.setEstatus(estatus.get(i));
					listaDetalle.add(beanAux);
	
			}
		}
		
		return listaDetalle;
		
	}

	public TasasCedesDAO getTasasCedesDAO() {
		return tasasCedesDAO;
	}

	public void setTasasCedesDAO(TasasCedesDAO tasasCedesDAO) {
		this.tasasCedesDAO = tasasCedesDAO;
	}
	
}
