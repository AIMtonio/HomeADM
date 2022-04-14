package operacionesVBC.servicioweb;

import operacionesVBC.beanWS.request.VbcAltaSolicitudCreditoRequest;
import operacionesVBC.beanWS.response.VbcAltaSolicitudCreditoResponse;
import operacionesVBC.servicio.VbcAltaSolicitudCreditoServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;

public class VbcAltaSolicitudCreditoWS extends AbstractMarshallingPayloadEndpoint {
	VbcAltaSolicitudCreditoServicio vbcAltaSolicitudCreditoServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	public VbcAltaSolicitudCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
		
	private VbcAltaSolicitudCreditoResponse procesoSolicitudCreditoResponse(VbcAltaSolicitudCreditoRequest request){
		VbcAltaSolicitudCreditoResponse altaReferenciaResponse = new VbcAltaSolicitudCreditoResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcAltaSolicitudCreditoServicio.getVbcAltaSolicitudCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		request.setClave(SeguridadRecursosServicio.encriptaPass(request.getUsuario(),request.getClave()));
		altaReferenciaResponse	= vbcAltaSolicitudCreditoServicio.altaModificaReferencia(request);
		if(altaReferenciaResponse.getMensajeRespuesta() == null){
			altaReferenciaResponse.setCodigoRespuesta("999");
			altaReferenciaResponse.setMensajeRespuesta("Error al ejecutar el proceso de Solicitud de Credito WS");
		}
		return altaReferenciaResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		VbcAltaSolicitudCreditoRequest altaSolicitudCreditoRequest = (VbcAltaSolicitudCreditoRequest)arg0;
		return procesoSolicitudCreditoResponse(altaSolicitudCreditoRequest);
	}

	public VbcAltaSolicitudCreditoServicio getVbcAltaSolicitudCreditoServicio() {
		return vbcAltaSolicitudCreditoServicio;
	}

	public void setVbcAltaSolicitudCreditoServicio(VbcAltaSolicitudCreditoServicio vbcAltaSolicitudCreditoServicio) {
		this.vbcAltaSolicitudCreditoServicio = vbcAltaSolicitudCreditoServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}	
}
