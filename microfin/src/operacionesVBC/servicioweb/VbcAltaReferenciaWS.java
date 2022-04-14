package operacionesVBC.servicioweb;

import operacionesVBC.beanWS.request.VbcAltaReferenciaRequest;
import operacionesVBC.beanWS.response.VbcAltaReferenciaResponse;
import operacionesVBC.servicio.VbcAltaReferenciaServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;

public class VbcAltaReferenciaWS extends AbstractMarshallingPayloadEndpoint {
	VbcAltaReferenciaServicio vbcAltaReferenciaServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	public VbcAltaReferenciaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
		
	private VbcAltaReferenciaResponse procesoReferenciaResponse(VbcAltaReferenciaRequest request){
		VbcAltaReferenciaResponse altaReferenciaResponse = new VbcAltaReferenciaResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcAltaReferenciaServicio.getVbcAltaReferenciaDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		request.setClave(SeguridadRecursosServicio.encriptaPass(request.getUsuario(),request.getClave()));
		altaReferenciaResponse	= vbcAltaReferenciaServicio.altaModificaReferencia(request);
		if(altaReferenciaResponse.getMensajeRespuesta() == null){
			altaReferenciaResponse.setCodigoRespuesta("999");
			altaReferenciaResponse.setMensajeRespuesta("Error al ejecutar el proceso de Referencia WS");
		}
		return altaReferenciaResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		VbcAltaReferenciaRequest altaReferenciaRequest = (VbcAltaReferenciaRequest)arg0;
		return procesoReferenciaResponse(altaReferenciaRequest);
	}

	public VbcAltaReferenciaServicio getVbcAltaReferenciaServicio() {
		return vbcAltaReferenciaServicio;
	}

	public void setVbcAltaReferenciaServicio(VbcAltaReferenciaServicio vbcAltaReferenciaServicio) {
		this.vbcAltaReferenciaServicio = vbcAltaReferenciaServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}	
}
