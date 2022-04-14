package operacionesCRCB.servicio;

import operacionesCRCB.beanWS.request.ActCuentaDestinoRequest;
import operacionesCRCB.beanWS.request.AltaCuentaDestinoRequest;
import operacionesCRCB.beanWS.response.ActCuentaDestinoResponse;
import operacionesCRCB.beanWS.response.AltaCuentaDestinoResponse;
import operacionesCRCB.dao.CuentasDestinoDAO;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;

public class CuentasDestinoServicio extends BaseServicio{

	CuentasDestinoDAO cuentasDestinoDAO = null;
	private TransaccionDAO transaccionDAO 	= null;
	
	private CuentasDestinoServicio(){
		super();
	}
	
	public static interface Enum_Tra_CuentaDestino_WS {
		int altaCtaDestino		= 1;
		int actCtaDestino 		= 2;

	}
	
	// Metodo general para grabar transacciones
	public Object grabaTransaccion(Object beanRequest, int tipoTransaccion){
		Object response = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CuentaDestino_WS.altaCtaDestino:
				response = altaCuentaDestino((AltaCuentaDestinoRequest)beanRequest);
			break;
			
			case Enum_Tra_CuentaDestino_WS.actCtaDestino:
				response = actualizaCtaDestino((ActCuentaDestinoRequest)beanRequest);
			break;
		}
		return response;
	}
	
	// Metodo alta cuenta destino
	public AltaCuentaDestinoResponse altaCuentaDestino(AltaCuentaDestinoRequest requestBean){
			
		AltaCuentaDestinoResponse mensaje = null;
		
		int tipoAlta = 1;
		
		mensaje = cuentasDestinoDAO.altaCtaDestinoWS(requestBean, tipoAlta);
			
		return mensaje;
	}
	
	// Metodo actualizacion cuenta destino
	public ActCuentaDestinoResponse actualizaCtaDestino(ActCuentaDestinoRequest requestBean){
			
		ActCuentaDestinoResponse mensaje = null;
		
		int tipoModifica = 2;
		
		mensaje = cuentasDestinoDAO.actCtaDestinoWS(requestBean, tipoModifica);
			
		return mensaje;
	}



	public CuentasDestinoDAO getCuentasDestinoDAO() {
		return cuentasDestinoDAO;
	}

	public void setCuentasDestinoDAO(CuentasDestinoDAO cuentasDestinoDAO) {
		this.cuentasDestinoDAO = cuentasDestinoDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}
	
	
	
}
