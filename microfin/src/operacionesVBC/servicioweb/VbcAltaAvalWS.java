package operacionesVBC.servicioweb;

import operacionesVBC.beanWS.request.VbcAltaAvalRequest;
import operacionesVBC.beanWS.response.VbcAltaAvalResponse;
import operacionesVBC.servicio.VbcAltaAvalServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;

public class VbcAltaAvalWS extends AbstractMarshallingPayloadEndpoint {
	VbcAltaAvalServicio vbcAltaAvalServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	public VbcAltaAvalWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
		
	private VbcAltaAvalResponse procesoReferenciaResponse(VbcAltaAvalRequest request){
		VbcAltaAvalResponse altaAvalResponse = new VbcAltaAvalResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcAltaAvalServicio.getVbcAltaAvalDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		request.setClave(SeguridadRecursosServicio.encriptaPass(request.getUsuario(),request.getClave()));
		altaAvalResponse	= vbcAltaAvalServicio.altaAval(request);
		if(altaAvalResponse.getMensajeRespuesta() == null){
			altaAvalResponse.setCodigoRespuesta("999");
			altaAvalResponse.setMensajeRespuesta("Error al ejecutar el proceso de Referencia WS");
		}
		return altaAvalResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		VbcAltaAvalRequest altaAvalRequest = (VbcAltaAvalRequest)arg0;
		return procesoReferenciaResponse(altaAvalRequest);
	}

	public VbcAltaAvalServicio getVbcAltaAvalServicio() {
		return vbcAltaAvalServicio;
	}

	public void setVbcAltaAvalServicio(VbcAltaAvalServicio vbcAltaAvalServicio) {
		this.vbcAltaAvalServicio = vbcAltaAvalServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}	
}
