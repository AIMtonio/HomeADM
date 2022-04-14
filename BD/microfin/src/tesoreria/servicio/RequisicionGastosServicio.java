package tesoreria.servicio;

import java.util.List;

import tesoreria.bean.RequisicionGastosBean;
import tesoreria.bean.RequisicionTipoGastoListaBean;
import tesoreria.dao.RequisicionGastosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RequisicionGastosServicio extends BaseServicio{
	//------------------ Variables ----------------------------------------------------------------
	RequisicionGastosDAO requisicionGastosDAO = null;
	
	
	//------------------ Tipo de Consulta ---------------------------------------------------------
	public static interface Enum_Con_Requisicion{
		int consultaPrincipal = 1;
		int consultaxFactura = 2;
		int consPresuGtosFac = 3;
	}
	
	public static interface Enum_Con_TipoGasto{
		int consultaPrincipal = 1;
	}
	
	public static interface Enum_Lis_Requisicion{
		int principal = 1;
	}
	
	public static interface Enum_Lis_TipoGasto{
		int principal = 1;
		
	}
	
	public static interface Enum_Tra_Requisicion{
		int alta = 1;
		int modificacion = 2;
		int eliminar = 3;
	}
	
	public RequisicionGastosServicio(){
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, RequisicionGastosBean requisicionGastosBean){
		MensajeTransaccionBean mensaje = null;			
		
		switch (tipoTransaccion) {
			case Enum_Tra_Requisicion.alta:		
				mensaje = requisicionGastosDAO.altaRequisicion(requisicionGastosBean);				
			break;
			case Enum_Tra_Requisicion.modificacion:
				mensaje = requisicionGastosDAO.modificaRequisicion(requisicionGastosBean);
			break;
		}
		return mensaje;
	}
	
	public RequisicionGastosBean consulta(int tipoConsulta, RequisicionGastosBean requisicionGastosBean){
		RequisicionGastosBean requisicionGastosB = null;
		switch(tipoConsulta){
			case Enum_Con_Requisicion.consultaPrincipal:
				requisicionGastosB = requisicionGastosDAO.consultaPrincipal(requisicionGastosBean, Enum_Con_Requisicion.consultaPrincipal); 
			break;	
			case Enum_Con_Requisicion.consultaxFactura:
				requisicionGastosB = requisicionGastosDAO.consultaPorFactura(requisicionGastosBean, Enum_Con_Requisicion.consultaxFactura); 
			break;	
			case Enum_Con_Requisicion.consPresuGtosFac:
				requisicionGastosB = requisicionGastosDAO.consultaPresupGtosFactura(requisicionGastosBean, Enum_Con_Requisicion.consPresuGtosFac); 
			break;	
		}
		return requisicionGastosB;
	}
									
	public RequisicionTipoGastoListaBean consultaTipoGasto(int tipoConsulta, RequisicionTipoGastoListaBean requisicionTipoGastoListaBean){
		RequisicionTipoGastoListaBean requisicionTipoGastoListaB = null;
		switch(tipoConsulta){
			case Enum_Con_TipoGasto.consultaPrincipal:
				requisicionTipoGastoListaB = requisicionGastosDAO.consultaTipoGas(requisicionTipoGastoListaBean, Enum_Con_TipoGasto.consultaPrincipal);
			break;
			 			
		}
		return requisicionTipoGastoListaB;
	}
	
	public List lista(int tipoLista, RequisicionGastosBean requisicionGastosBean){
		List requisicionGastosLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_Requisicion.principal:
	        	requisicionGastosLista = requisicionGastosDAO.listaPrincipal(requisicionGastosBean, tipoLista);
	        break;

	            
		}
		return requisicionGastosLista;
	}
	
	public List listaTipoGasto(int tipoLista, RequisicionTipoGastoListaBean requisicionTipoGastoListaBean){
		List requisicionTipoGastosLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_TipoGasto.principal:
	        	requisicionTipoGastosLista = requisicionGastosDAO.listaTipoGasto(requisicionTipoGastoListaBean, tipoLista);
	        break;     
		}
		return requisicionTipoGastosLista;
	}

	public void setRequisicionGastosDAO(RequisicionGastosDAO requisicionGastosDAO) {
		this.requisicionGastosDAO = requisicionGastosDAO;
	}
}
