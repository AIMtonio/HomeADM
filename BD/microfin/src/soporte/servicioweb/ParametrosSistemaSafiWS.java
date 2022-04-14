package soporte.servicioweb;

import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosSisBean;
import soporte.beanWS.request.ParametrosSistemaSafiRequest;
import soporte.beanWS.response.ParametrosSistemaSafiResponse;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.ParametrosSisServicio.Enum_Con_ParametrosSis;

public class ParametrosSistemaSafiWS extends AbstractMarshallingPayloadEndpoint{
	ParametrosSisServicio parametrosSisServicio = null;
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ParametrosSistemaSafiWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ParametrosSistemaSafiResponse parametrosSistemaSafi(ParametrosSistemaSafiRequest parametrosSistemaSafiRequest){	
		ParametrosSistemaSafiResponse parametrosSistemaSafiResponse = new ParametrosSistemaSafiResponse();
		ParametrosSisBean parametrosSisBean = new ParametrosSisBean();
		parametrosSisServicio.getParametrosSisDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
	
		parametrosSisBean.setEmpresaID(parametrosSistemaSafiRequest.getEmpresaID());
		parametrosSisBean = parametrosSisServicio.consulta(Enum_Con_ParametrosSis.principal, parametrosSisBean);
		
		if(parametrosSisBean==null){
			parametrosSistemaSafiResponse.setFechaSistema(Constantes.STRING_VACIO);
		}else{
		
		parametrosSistemaSafiResponse.setFechaSistema(parametrosSisBean.getFechaSistema());
		}
		return parametrosSistemaSafiResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ParametrosSistemaSafiRequest parametrosSistemaSafiRequest = (ParametrosSistemaSafiRequest)arg0; 
		return parametrosSistemaSafi(parametrosSistemaSafiRequest);
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}

}
