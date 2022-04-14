package tesoreria.servicio;

import java.util.List;

import tesoreria.bean.RenovacionOrdenPagoBean;
import tesoreria.dao.RenovacionOrdenPagoDAO;
import ventanilla.bean.ChequesEmitidosBean;
import ventanilla.servicio.ChequesEmitidosServicio.Enum_Con_ChequesEmitidos;
import ventanilla.servicio.ChequesEmitidosServicio.Enum_Lis_ChequesEmitidos;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class RenovacionOrdenPagoServicio extends BaseServicio{
	RenovacionOrdenPagoDAO renovacionOrdenPagoDAO = null;
	
	public RenovacionOrdenPagoServicio(){
		super();
	}
	
	public static interface Enum_Transaccion{
		int renovarOrdenPago = 1;
	}
	public static interface Enum_Lis_OrdenesPago {
		int OrdenesEmitidas	 = 1;
	}
	
	public static interface Enum_Con_OrdenesPago {
		int ConOrdenEmitidas	 = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(RenovacionOrdenPagoBean renovacionOrdenPagoBean,int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();	
		switch (tipoTransaccion) {	
			case Enum_Transaccion.renovarOrdenPago:		
				mensaje = renovacionOrdenPagoDAO.renovacionOrdenPago(renovacionOrdenPagoBean);	
				break;
		}
		return mensaje;
	}
	
	public RenovacionOrdenPagoBean consulta(int tipoConsulta, RenovacionOrdenPagoBean renovacionOrdenPagoBean){
		RenovacionOrdenPagoBean renovacionOrdenPago = null;
		switch (tipoConsulta) {
			case Enum_Con_OrdenesPago.ConOrdenEmitidas:	
				renovacionOrdenPago = renovacionOrdenPagoDAO.consultaOrdenEmitidas(renovacionOrdenPagoBean,tipoConsulta);
				break;	
		}
		return renovacionOrdenPago;
	}
	
	
	public List listaOrdenesPago(int tipoLista, RenovacionOrdenPagoBean renovacionOrdenPagoBean){		
		List listaOrdenes = null;		
		switch(tipoLista){
			case Enum_Lis_OrdenesPago.OrdenesEmitidas:
				listaOrdenes = renovacionOrdenPagoDAO.listaOrdenesEmitidas(renovacionOrdenPagoBean, tipoLista); 
				break; 			
		}
		
		return listaOrdenes;
	}
	

	public RenovacionOrdenPagoDAO getRenovacionOrdenPagoDAO() {
		return renovacionOrdenPagoDAO;
	}

	public void setRenovacionOrdenPagoDAO(
			RenovacionOrdenPagoDAO renovacionOrdenPagoDAO) {
		this.renovacionOrdenPagoDAO = renovacionOrdenPagoDAO;
	}
	

}
