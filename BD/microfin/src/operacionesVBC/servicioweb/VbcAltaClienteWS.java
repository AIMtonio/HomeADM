package operacionesVBC.servicioweb;

import herramientas.Utileria;
import operacionesVBC.beanWS.request.VbcAltaClienteRequest;
import operacionesVBC.beanWS.response.VbcAltaClienteResponse;
import operacionesVBC.servicio.VbcAltaClienteServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;

public class VbcAltaClienteWS extends AbstractMarshallingPayloadEndpoint{

	VbcAltaClienteServicio vbcAltaClienteServicio = null;
	
	public VbcAltaClienteWS(Marshaller marshaller){
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_Cliente {
		int alta		 = 1;
		int modificacion = 2;
	}
	
	private VbcAltaClienteResponse altaClienteResponse(VbcAltaClienteRequest altaClienteRequest){
		VbcAltaClienteResponse altaClienteResponse = new VbcAltaClienteResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcAltaClienteServicio.getVbcAltaClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		
		altaClienteRequest.setClave(SeguridadRecursosServicio.encriptaPass(altaClienteRequest.getUsuario(),altaClienteRequest.getClave()));
		
		altaClienteRequest.setOperacionID(altaClienteRequest.getOperacionID().replace("?", ""));
		altaClienteRequest.setClienteID(altaClienteRequest.getClienteID().replace("?", ""));
		
		if (altaClienteRequest.getOperacionID().trim().isEmpty()){
			altaClienteResponse.setClienteID("0");
			altaClienteResponse.setCodigoRespuesta("12");
			altaClienteResponse.setMensajeRespuesta("Especifique la Operacion a Realizar");
		}else{
			try{
				switch(Utileria.convierteEntero(altaClienteRequest.getOperacionID())){
					case (Enum_Tra_Cliente.alta): 
						altaClienteResponse = vbcAltaClienteServicio.altaClienteServicio(altaClienteRequest);
						break;
					case (Enum_Tra_Cliente.modificacion): 
						altaClienteResponse = vbcAltaClienteServicio.modificaClienteServicio(altaClienteRequest);
						break;
					default:
						altaClienteResponse.setClienteID("0");
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
		VbcAltaClienteRequest vbcAltaClienteRequest = (VbcAltaClienteRequest)arg0;
		return altaClienteResponse(vbcAltaClienteRequest);
	}
	public VbcAltaClienteServicio getVbcAltaClienteServicio() {
		return vbcAltaClienteServicio;
	}
	public void setVbcAltaClienteServicio(
			VbcAltaClienteServicio vbcAltaClienteServicio) {
		this.vbcAltaClienteServicio = vbcAltaClienteServicio;
	}	
}
