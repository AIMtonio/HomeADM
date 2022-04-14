package operacionesVBC.servicioweb;

import operacionesVBC.beanWS.request.VbcAsignaAvalRequest;
import operacionesVBC.beanWS.response.VbcAsignaAvalResponse;
import operacionesVBC.servicio.VbcAsignaAvalServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;

public class VbcAsignaAvalWS extends AbstractMarshallingPayloadEndpoint {
	VbcAsignaAvalServicio vbcAsignaAvalServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	public VbcAsignaAvalWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
		
	private VbcAsignaAvalResponse procesoReferenciaResponse(VbcAsignaAvalRequest request){
		VbcAsignaAvalResponse asignaAvalResponse = new VbcAsignaAvalResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcAsignaAvalServicio.getVbcAsignaAvalDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		request.setClave(SeguridadRecursosServicio.encriptaPass(request.getUsuario(),request.getClave()));
		asignaAvalResponse	= vbcAsignaAvalServicio.asignaAvales(request);
		if(asignaAvalResponse.getMensajeRespuesta() == null){
			asignaAvalResponse.setCodigoRespuesta("999");
			asignaAvalResponse.setMensajeRespuesta("Error al ejecutar el proceso de Referencia WS");
		}
		return asignaAvalResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		VbcAsignaAvalRequest asignaAvalRequest = (VbcAsignaAvalRequest)arg0;
		return procesoReferenciaResponse(asignaAvalRequest);
	}

	public VbcAsignaAvalServicio getVbcAsignaAvalServicio() {
		return vbcAsignaAvalServicio;
	}

	public void setVbcAsignaAvalServicio(VbcAsignaAvalServicio vbcAsignaAvalServicio) {
		this.vbcAsignaAvalServicio = vbcAsignaAvalServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}	
}
