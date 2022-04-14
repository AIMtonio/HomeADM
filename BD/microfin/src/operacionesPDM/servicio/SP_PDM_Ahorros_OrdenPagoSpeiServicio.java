package operacionesPDM.servicio;

import operacionesPDM.beanWS.request.SP_PDM_Ahorros_OrdenPagoSpeiRequest;
import operacionesPDM.beanWS.response.SP_PDM_Ahorros_OrdenPagoSpeiResponse;
import operacionesPDM.dao.SP_PDM_Ahorros_OrdenPagoSpeiDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class SP_PDM_Ahorros_OrdenPagoSpeiServicio extends BaseServicio{
	
	SP_PDM_Ahorros_OrdenPagoSpeiDAO	sP_PDM_Ahorros_OrdenPagoSpeiDAO = null;
	
	public SP_PDM_Ahorros_OrdenPagoSpeiServicio(){
		super();
	}
	
	public SP_PDM_Ahorros_OrdenPagoSpeiResponse grabaTransaccion(SP_PDM_Ahorros_OrdenPagoSpeiRequest ordenPagoSpeiBean){
		SP_PDM_Ahorros_OrdenPagoSpeiResponse mensaje = null;
		
		mensaje = sP_PDM_Ahorros_OrdenPagoSpeiDAO.altaOrdenPagoSpeiWS(ordenPagoSpeiBean);
		
		return mensaje;	
		
	}	
	
	public SP_PDM_Ahorros_OrdenPagoSpeiDAO getSP_PDM_Ahorros_ConsultaCtaDestinoDAO() {
		return sP_PDM_Ahorros_OrdenPagoSpeiDAO;
	}

	public void setSP_PDM_Ahorros_OrdenPagoSpeiDAO(
			SP_PDM_Ahorros_OrdenPagoSpeiDAO sP_PDM_Ahorros_OrdenPagoSpeiDAO) {
		this.sP_PDM_Ahorros_OrdenPagoSpeiDAO = sP_PDM_Ahorros_OrdenPagoSpeiDAO;
	}

}
