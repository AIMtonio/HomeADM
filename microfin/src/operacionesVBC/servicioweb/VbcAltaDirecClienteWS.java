package operacionesVBC.servicioweb;

import herramientas.Utileria;
import operacionesVBC.beanWS.request.VbcAltaDirecClienteRequest;
import operacionesVBC.beanWS.response.VbcAltaDirecClienteResponse;
import operacionesVBC.servicio.VbcAltaDirecClienteServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;

public class VbcAltaDirecClienteWS extends AbstractMarshallingPayloadEndpoint{

	VbcAltaDirecClienteServicio vbcAltaDirecClienteServicio = null;
	public VbcAltaDirecClienteWS(Marshaller marshaller){
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_Cliente {
		int alta		 = 1;
		int modificacion = 2;
	}

	private VbcAltaDirecClienteResponse altaDireccionResponse(VbcAltaDirecClienteRequest altaClienteRequest){
		VbcAltaDirecClienteResponse altaClienteResponse = new VbcAltaDirecClienteResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcAltaDirecClienteServicio.getVbcAltaDirecClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		altaClienteRequest.setClave(SeguridadRecursosServicio.encriptaPass(altaClienteRequest.getUsuario(), altaClienteRequest.getClave()));
		
		altaClienteRequest.setOperacionID(altaClienteRequest.getOperacionID().replace("?", ""));
		altaClienteRequest.setClienteID(altaClienteRequest.getClienteID().replace("?", ""));
		
		if (altaClienteRequest.getOperacionID().trim().isEmpty() ){
			altaClienteResponse.setDireccionID("0");
			altaClienteResponse.setCodigoRespuesta("12");
			altaClienteResponse.setMensajeRespuesta("Especifique la Operacion a Realizar");
		}else{
			try{
				switch(Utileria.convierteEntero(altaClienteRequest.getOperacionID())){
					case (Enum_Tra_Cliente.alta): 
						altaClienteResponse = vbcAltaDirecClienteServicio.altaDireccionServicio(altaClienteRequest);
						break;
					case (Enum_Tra_Cliente.modificacion): 
						altaClienteResponse = vbcAltaDirecClienteServicio.modificaDireccionServicio(altaClienteRequest);
						break;
					default:
						altaClienteResponse.setDireccionID("0");
						altaClienteResponse.setCodigoRespuesta("12");
						altaClienteResponse.setMensajeRespuesta("La Operacion ID No es Valida.");
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return altaClienteResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		// TODO Auto-generated method stub
		VbcAltaDirecClienteRequest vbcAltaDireccionRequest = (VbcAltaDirecClienteRequest)arg0;
		return altaDireccionResponse(vbcAltaDireccionRequest);
	}

	public VbcAltaDirecClienteServicio getVbcAltaDirecClienteServicio() {
		return vbcAltaDirecClienteServicio;
	}

	public void setVbcAltaDirecClienteServicio(
			VbcAltaDirecClienteServicio vbcAltaDirecClienteServicio) {
		this.vbcAltaDirecClienteServicio = vbcAltaDirecClienteServicio;
	}

}
