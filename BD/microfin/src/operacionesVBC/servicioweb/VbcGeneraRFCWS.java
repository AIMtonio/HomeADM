package operacionesVBC.servicioweb;

import herramientas.OperacionesFechas;
import operacionesVBC.beanWS.request.VbcGeneraRFCRequest;
import operacionesVBC.beanWS.response.VbcGeneraRFCResponse;
import operacionesVBC.servicio.VbcGeneraRFCServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.ParametrosSisServicio;

public class VbcGeneraRFCWS extends AbstractMarshallingPayloadEndpoint{
	VbcGeneraRFCServicio vbcGeneraRFCServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	public VbcGeneraRFCWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private VbcGeneraRFCResponse generaRFCResponse(VbcGeneraRFCRequest generaRFCRequest){
		VbcGeneraRFCResponse generaRFCResponse = new VbcGeneraRFCResponse();
		
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcGeneraRFCServicio.getVbcGeneraRFCDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		generaRFCRequest.setClave(SeguridadRecursosServicio.encriptaPass(generaRFCRequest.getUsuario(), generaRFCRequest.getClave()));

		generaRFCRequest.setNombre(generaRFCRequest.getNombre().replace("?", ""));
		generaRFCRequest.setApellidoPaterno(generaRFCRequest.getApellidoPaterno().replace("?", ""));
		generaRFCRequest.setApellidoMaterno(generaRFCRequest.getApellidoMaterno().replace("?", ""));
		
		if (generaRFCRequest.getNombre().trim().isEmpty()){
			generaRFCResponse.setCodigoRespuesta("01");
			generaRFCResponse.setMensajeRespuesta("El Nombre no puede estar Vacio.");
		}else if(generaRFCRequest.getApellidoPaterno().trim().isEmpty()){
			generaRFCResponse.setCodigoRespuesta("02");
			generaRFCResponse.setMensajeRespuesta("El Apellido Paterno no puede estar Vacio.");
		}else if (generaRFCRequest.getFechaNacimiento().trim().isEmpty()){
			generaRFCResponse.setCodigoRespuesta("03");
			generaRFCResponse.setMensajeRespuesta("La fecha de nacimiento no puede estar Vacía.");
		}else if (!OperacionesFechas.validarFecha(generaRFCRequest.getFechaNacimiento())){
			generaRFCResponse.setCodigoRespuesta("05");
			generaRFCResponse.setMensajeRespuesta("Formato de Fecha de Nacimiento Invalido. Verifique.");			
		}else{
			generaRFCResponse=vbcGeneraRFCServicio.generaRFCServicio(generaRFCRequest);
		}
		return generaRFCResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		VbcGeneraRFCRequest vbcGeneraRFCRequest= (VbcGeneraRFCRequest)arg0;
		return generaRFCResponse(vbcGeneraRFCRequest);
	}
	
	public VbcGeneraRFCServicio getVbcGeneraRFCServicio() {
		return vbcGeneraRFCServicio;
	}

	public void setVbcGeneraRFCServicio(VbcGeneraRFCServicio vbcGeneraRFCServicio) {
		this.vbcGeneraRFCServicio = vbcGeneraRFCServicio;
	}

	public ParametrosSisServicio getParametrosSisServicio() {
		return parametrosSisServicio;
	}

	public void setParametrosSisServicio(ParametrosSisServicio parametrosSisServicio) {
		this.parametrosSisServicio = parametrosSisServicio;
	}
	
}
	