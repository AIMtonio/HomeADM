package operacionesPDM.servicioweb;

import operacionesPDM.beanWS.request.SP_PDM_Server_FechaHoraRequest;
import operacionesPDM.beanWS.response.SP_PDM_Server_FechaHoraResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosSisBean;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class SP_PDM_Server_FechaHoraWS extends AbstractMarshallingPayloadEndpoint {
	ParametrosSisServicio parametrosSisServicio = null;

	public SP_PDM_Server_FechaHoraWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SP_PDM_Server_FechaHoraResponse SP_PDM_Server_FechaHora(SP_PDM_Server_FechaHoraRequest request){	
		SP_PDM_Server_FechaHoraResponse  sP_PDA_Server_FechaHoraResponse = new SP_PDM_Server_FechaHoraResponse();
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		parametrosSisServicio.getParametrosSisDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
    	
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.fechaHora, parametrosSisBean);
		
		sP_PDA_Server_FechaHoraResponse.setFechaHora(parametrosSisBean.getFechaSistema());
		
		return sP_PDA_Server_FechaHoraResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		SP_PDM_Server_FechaHoraRequest FechaServerRequest = (SP_PDM_Server_FechaHoraRequest)arg0; 			
		return SP_PDM_Server_FechaHora(FechaServerRequest);
		
	}
	
	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
}
