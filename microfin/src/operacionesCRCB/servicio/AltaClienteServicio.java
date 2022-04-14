package operacionesCRCB.servicio;


import operacionesCRCB.beanWS.request.AltaClienteRequest;
import operacionesCRCB.beanWS.response.AltaClienteResponse;
import operacionesCRCB.dao.AltaClienteDAO;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import general.servicio.BaseServicio;

public class AltaClienteServicio extends BaseServicio{
	
	AltaClienteDAO altaClienteDAO = null;
	ParametrosSisServicio		parametrosSisServicio	= null;
	
	private AltaClienteServicio(){
		super();
	}
	
	public AltaClienteResponse altaCliente(AltaClienteRequest requestBean){
		
		AltaClienteResponse response = null;
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisBean.setEmpresaID("1");
		parametrosSisBean = parametrosSisServicio.consulta(1, parametrosSisBean);
				
		if(parametrosSisBean.getUnificaCI().contentEquals("S")) {
			if(requestBean.getClienteId().equals("0")) {
				response = altaClienteDAO.altaClienteVal(requestBean,parametrosSisBean.getOrigenReplica());
				
				if(response.getCodigoRespuesta().equalsIgnoreCase("0")) {
					response = altaClienteDAO.altaClienteCartera(requestBean, parametrosSisBean.getOrigenReplica());
					
					if(response.getCodigoRespuesta().contentEquals("0")) {
						requestBean.setClienteId(response.getClienteID());
						response = altaClienteDAO.altaClienteWS(requestBean);
					}
					
				}else {
					response = new AltaClienteResponse();
					response.setCodigoRespuesta("999");
					response.setMensajeRespuesta("El cliente ya existe en el ambiente cartera.");
				}
			}else {
				//Buscar datos del cliente en cartera
				requestBean = altaClienteDAO.consultaClienteCRSB(requestBean, parametrosSisBean.getOrigenReplica());
				//Alta en captación
				if(requestBean.getCodigoRespuesta() == "0") {
					response = altaClienteDAO.altaClienteWS(requestBean);
				}else {
					response = new AltaClienteResponse(); 
					response.setClienteID(requestBean.getClienteId());
					response.setCodigoRespuesta(requestBean.getCodigoRespuesta());
					response.setMensajeRespuesta(requestBean.getMensajeRespuesta());
				}
			}
		}
		
		if(parametrosSisBean.getUnificaCI().contentEquals("N")) {
			response = altaClienteDAO.altaClienteWS(requestBean);
		}
		
		return response;
	}

	// ========== GETTER & SETTER ============

	public AltaClienteDAO getAltaClienteDAO() {
		return altaClienteDAO;
	}

	public void setAltaClienteDAO(AltaClienteDAO altaClienteDAO) {
		this.altaClienteDAO = altaClienteDAO;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}
