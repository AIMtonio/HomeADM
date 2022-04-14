package aportaciones.servicio;

import java.util.ArrayList;
import java.util.List;

import cuentas.bean.TasasAhorroBean;
import cuentas.servicio.TasasAhorroServicio.Enum_Lis_TasasAhorro;
import soporte.bean.PlazasBean;
import soporte.servicio.PlazasServicio.Enum_Tra_Plaza;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import aportaciones.bean.TasasAportacionesBean;
import aportaciones.dao.TasasAportacionesDAO;
import aportaciones.servicio.MontosAportacionesServicio.Enum_Con_MontosAportaciones;

public class TasasAportacionesServicio extends BaseServicio {
	
	TasasAportacionesDAO tasasAportacionesDAO = null;
	
	public TasasAportacionesServicio() {
		super();
	}
	
	public static interface Enum_Tra_TasasAportaciones {
		int alta				= 1;
		int modifica			= 2;
		int elimina				= 3;
	}
	
	
	public static interface Enum_Con_TasasAportaciones {
		int principal				    = 1;
		int tasa				   		= 2;
		int tasaVariable				= 3;
	}
	
	public static interface Enum_Lis_TasasAportaciones {
		int principal				    = 1;
		int grid 						= 2;
		int reporte						= 3;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TasasAportacionesBean tasas, String tasa){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion) {
			case Enum_Tra_TasasAportaciones.alta:	
				ArrayList listaSucursales = (ArrayList) creaListaDetalle(tasas);		
				mensaje = tasasAportacionesDAO.procesarAlta(tasas,listaSucursales);			
				break;				
			case Enum_Tra_TasasAportaciones.modifica:
				ArrayList listaSucursalesM = (ArrayList) creaListaDetalle(tasas);	
				mensaje =tasasAportacionesDAO.procesarModificacion(tasas,listaSucursalesM,tasa);
				break;
			case Enum_Tra_TasasAportaciones.elimina:
				mensaje = tasasAportacionesDAO.eliminaTasas(tasas,Enum_Tra_TasasAportaciones.alta);				
				break;
		
		}
		return mensaje;
	}
	
	public TasasAportacionesBean consulta(int tipoConsulta,TasasAportacionesBean tasasAportacionesBean){
		TasasAportacionesBean tasaAportacionesBean = null;
		switch (tipoConsulta) {
			case Enum_Con_TasasAportaciones.principal:		
				tasaAportacionesBean = tasasAportacionesDAO.consultaPrincipal(tasasAportacionesBean, Enum_Con_MontosAportaciones.principal);
				break;
			case Enum_Con_TasasAportaciones.tasaVariable:	
				tasaAportacionesBean = tasasAportacionesDAO.consultaTasaVariable(tasasAportacionesBean, tipoConsulta);				
				break;					
			case Enum_Con_TasasAportaciones.tasa:
				tasaAportacionesBean = tasasAportacionesDAO.consultaTasa(tasasAportacionesBean);
				break;

		}
		return tasaAportacionesBean;
	}
	
	public List lista(int tipoLista, TasasAportacionesBean bean){		
		List listaTasas = null;
		switch (tipoLista) {
			case Enum_Lis_TasasAportaciones.principal:		
				listaTasas = tasasAportacionesDAO.listaPrincipal(bean, tipoLista);				
			break;
			case Enum_Lis_TasasAportaciones.grid:		
				listaTasas = tasasAportacionesDAO.listaGrid(bean, tipoLista);				
			break;
		}		
		return listaTasas;
	}
	
	public Object[] listaCombo(int tipoLista, TasasAportacionesBean bean){		
		List listaTasas = null;
		switch (tipoLista) {
			case Enum_Lis_TasasAportaciones.reporte:		
				listaTasas = tasasAportacionesDAO.listaReporte(bean, tipoLista);				
			break;
		}		
		return listaTasas.toArray();
	}
	
	/* Arma la lista de beans */
	public List creaListaDetalle( TasasAportacionesBean bean) {		
		
		List<String> sucursales  = bean.getlSucursalID();
		List<String> estados	 = bean.getlEstadoID();
		List<String> estatus	 = bean.getlEstatus();

		ArrayList listaDetalle = new ArrayList();
		TasasAportacionesBean beanAux = null;	
		
		if(sucursales != null){
			int tamanio = sucursales.size();			
			for (int i = 0; i < tamanio; i++ ) {
					beanAux = new TasasAportacionesBean();				
					beanAux.setTipoAportacionID(bean.getTipoAportacionID());
					beanAux.setSucursalID(sucursales.get(i));
					beanAux.setEstadoID(estados.get(i));
					beanAux.setEstatus(estatus.get(i));
					listaDetalle.add(beanAux);
	
			}
		}
		
		return listaDetalle;
		
	}

	public TasasAportacionesDAO getTasasAportacionesDAO() {
		return tasasAportacionesDAO;
	}

	public void setTasasAportacionesDAO(TasasAportacionesDAO tasasAportacionesDAO) {
		this.tasasAportacionesDAO = tasasAportacionesDAO;
	}
	
	
}
