package nomina.servicio;
import java.util.ArrayList;
import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import nomina.bean.EsquemaQuinqueniosBean;
import nomina.dao.EsquemaQuinqueniosDAO;



public class EsquemaQuinqueniosServicio extends BaseServicio{
	
	EsquemaQuinqueniosDAO esquemaQuinqueniosDAO = null;

	// -------------- Tipo Transaccion ----------------
	public static interface Enum_Tipo_Transaccion{
		int grabar     	= 1;			// Grabar Esquema Quinquenios
	}
	
	// -------------- Tipo Consulta ----------------
	public static interface Enum_Con_Eaquema{
		int conPrincipal	= 1;
	}
		
	// -------------- Tipo Lista ----------------
	public static interface Enum_Lis_Esquema{
		int lisEsquemaQuinquenios	= 1;		// Lista de Esquemas de Quinquenios
	}
	
	public static interface Enum_Con_Esquema{
		int ConPrincipal	= 1;		// Consulta principal Esquema Quinquenios
		int ConForanea		= 2;		// Consulta foranea Esquema Quinquenios
		int ConExisteEsqQ	= 3;		// Consulta foranea Esquema Quinquenios
	}
	
	
	/**
	 * 
	 * @param tipoTransaccion : Tipo de Transacción 
	 * @param esquemaQuinqueniosBean : Bean de Esquema de Quinquenios
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,EsquemaQuinqueniosBean esquemaQuinqueniosBean) {
	 	MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tipo_Transaccion.grabar:
				ArrayList listaDetalleGrid = (ArrayList) detalleGrid(esquemaQuinqueniosBean);
				mensaje = esquemaQuinqueniosDAO.grabarEsquemaQuinquenios(esquemaQuinqueniosBean,listaDetalleGrid);
			break;
		}
		return mensaje;
	}
	
	
	/**
	 * 
	 * @param esquemaQuinqueniosBean : Bean de Esquema de Quinquenios
	 * @return
	 */
	private List detalleGrid(EsquemaQuinqueniosBean esquemaQuinqueniosBean){
		// Separa las listas del grid en beans individuales	
		List<String> listaSucursal = esquemaQuinqueniosBean.getLisSucursalID();
		List<String> listaQuinquenio = esquemaQuinqueniosBean.getLisQuinquenioID();
		List<String> listaPlazo = esquemaQuinqueniosBean.getLisPlazoID();
		
		ArrayList listaDetalle = new ArrayList();
		EsquemaQuinqueniosBean iterEsquemaQuinqueniosBean  = null; 
		int tamanio = 0;
		
		if(listaSucursal != null){
			tamanio = listaSucursal.size();
		}
		for(int i = 0; i < tamanio; i++){
			iterEsquemaQuinqueniosBean = new EsquemaQuinqueniosBean();
			iterEsquemaQuinqueniosBean.setInstitNominaID(esquemaQuinqueniosBean.getInstitNominaID());
			iterEsquemaQuinqueniosBean.setConvenioNominaID(esquemaQuinqueniosBean.getConvenioNominaID());
			iterEsquemaQuinqueniosBean.setSucursalID(listaSucursal.get(i));
			iterEsquemaQuinqueniosBean.setQuinquenioID(listaQuinquenio.get(i));
			iterEsquemaQuinqueniosBean.setPlazoID(listaPlazo.get(i));
			
			listaDetalle.add(iterEsquemaQuinqueniosBean);
		}
		return listaDetalle;
	}
	
	/**
	 * 
	 * @param tipoLista : Tipo de Lista
	 * @param esquemaQuinqueniosBean : Bean de Esquema de Quinquenios
	 * @return
	 */
	public List lista(int tipoLista, EsquemaQuinqueniosBean esquemaQuinqueniosBean){
		List esquemaQuinquenioLista = null;
		 switch (tipoLista) {
		    case  Enum_Lis_Esquema.lisEsquemaQuinquenios:          
		    	esquemaQuinquenioLista = esquemaQuinqueniosDAO.listaEsquemaQuinquenios(esquemaQuinqueniosBean, tipoLista);
		    break;
		}
		return esquemaQuinquenioLista;
	}
	
	public EsquemaQuinqueniosBean consulta(int tipoConsulta, EsquemaQuinqueniosBean esquemaQuinqueniosBean) {
		EsquemaQuinqueniosBean resultado = null;

		switch (tipoConsulta) {
		case Enum_Con_Esquema.ConPrincipal:
			resultado = esquemaQuinqueniosDAO.consultaPrincipal(tipoConsulta, esquemaQuinqueniosBean);
			break;
		case Enum_Con_Esquema.ConForanea:
			resultado = esquemaQuinqueniosDAO.consultaForanea(tipoConsulta, esquemaQuinqueniosBean);
			break;
		case Enum_Con_Esquema.ConExisteEsqQ:
			resultado = esquemaQuinqueniosDAO.consultaConExisteEsqQ(tipoConsulta, esquemaQuinqueniosBean);
			break;
			
		}

		return resultado;
	}
	// =========== GETTER & SETTER =========== //

	public EsquemaQuinqueniosDAO getEsquemaQuinqueniosDAO() {
		return esquemaQuinqueniosDAO;
	}

	public void setEsquemaQuinqueniosDAO(EsquemaQuinqueniosDAO esquemaQuinqueniosDAO) {
		this.esquemaQuinqueniosDAO = esquemaQuinqueniosDAO;
	}

}
