package activos.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import activos.bean.TiposActivosBean;
import activos.dao.TiposActivosDAO;

public class TiposActivosServicio extends BaseServicio{
	TiposActivosDAO tiposActivosDAO = null; 

	public static interface Enum_Trans_TiposActivos {
		int alta	 = 1;
		int modifica = 2;
	}
	
	public static interface Enum_Lis_TiposActivos{
		int listaTiposActivos		= 1; 
		int listaComboTiposActivos	= 2;
		int listaTiposActivosGastos	= 3; 
	}
	
	public static interface Enum_Lis_ClasifTiposActivos{
		int listaComboClasifTA	= 1; 
	}
	
	public static interface Enum_Con_TiposActivos{
		int tipoActivo 	= 1;
	}
	
	public TiposActivosServicio(){
		super();
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposActivosBean tiposActivosBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Trans_TiposActivos.alta:		
				mensaje = tiposActivosDAO.altaTipoActivo(tiposActivosBean);		
				break;				
			case Enum_Trans_TiposActivos.modifica:
				mensaje = tiposActivosDAO.modificaTipoActivo(tiposActivosBean);
				break;	
		}
		return mensaje;
	}

	public List lista(int tipoLista, TiposActivosBean tiposActivosBean){
		List listaBean = null;
		
		switch(tipoLista){
			case Enum_Lis_TiposActivos.listaTiposActivos:
				listaBean = tiposActivosDAO.listaTiposActivos(tipoLista, tiposActivosBean);
				break;
			case Enum_Lis_TiposActivos.listaTiposActivosGastos:
				listaBean = tiposActivosDAO.listaTiposActivos(tipoLista, tiposActivosBean);
				break;
		}
		
		return listaBean;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {	
		List listaBean = null;
			
		switch(tipoLista){
			case Enum_Lis_ClasifTiposActivos.listaComboClasifTA: 
				listaBean =  tiposActivosDAO.listaClasifTiposActivos(tipoLista);
				break;
			
		}
		return listaBean.toArray();		
	}
	
	// listas para comboBox tipos activos
	public  Object[] listaComboTiposActivos(int tipoLista) {	
		List listaBean = null;
			
		switch(tipoLista){
			case Enum_Lis_TiposActivos.listaComboTiposActivos: 
				listaBean =  tiposActivosDAO.listaComboTiposActivos(tipoLista);
				break;
			
		}
		return listaBean.toArray();		
	}
	
	public TiposActivosBean consulta(int tipoConsulta, TiposActivosBean tiposActivosBean){
		TiposActivosBean consultabean = null;
		
		switch(tipoConsulta){
			case Enum_Con_TiposActivos.tipoActivo:
				consultabean = tiposActivosDAO.consultaTiposActivos(tipoConsulta, tiposActivosBean);
				break;
		}
		
		return consultabean;
	}
	
	public TiposActivosDAO getTiposActivosDAO() {
		return tiposActivosDAO;
	}

	public void setTiposActivosDAO(TiposActivosDAO tiposActivosDAO) {
		this.tiposActivosDAO = tiposActivosDAO;
	}
}
