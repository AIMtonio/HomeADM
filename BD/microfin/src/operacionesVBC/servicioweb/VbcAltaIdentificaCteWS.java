package operacionesVBC.servicioweb;

import herramientas.Utileria;
import operacionesVBC.beanWS.request.VbcAltaIdentificaCteRequest;
import operacionesVBC.beanWS.response.VbcAltaIdentificaCteResponse;
import operacionesVBC.servicio.VbcAltaIdentificaCteServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;

public class VbcAltaIdentificaCteWS extends AbstractMarshallingPayloadEndpoint{
	VbcAltaIdentificaCteServicio vbcAltaIdentificaCteServicio = null;
	
	public VbcAltaIdentificaCteWS(Marshaller marshaller){
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	public static interface Enum_Tra_Cliente {
		int alta		 = 1;
		int modificacion = 2;
	}

	private VbcAltaIdentificaCteResponse altaIdentificaWSResponse(VbcAltaIdentificaCteRequest altaIdentificaRequest){
		VbcAltaIdentificaCteResponse altaIdentificaResponse = new VbcAltaIdentificaCteResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosVBC");
		vbcAltaIdentificaCteServicio.getVbcAltaIdentificaCteDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		altaIdentificaRequest.setClave(SeguridadRecursosServicio.encriptaPass(altaIdentificaRequest.getUsuario(), altaIdentificaRequest.getClave()));
		
		altaIdentificaRequest.setOperacionID(altaIdentificaRequest.getOperacionID().replace("?", ""));
		altaIdentificaRequest.setClienteID(altaIdentificaRequest.getClienteID().replace("?", ""));
		altaIdentificaRequest.setIdentificaID(altaIdentificaRequest.getIdentificaID().replace("?", ""));
		altaIdentificaRequest.setTipoIdentiID(altaIdentificaRequest.getTipoIdentiID().replace("?", ""));
		altaIdentificaRequest.setNumIdentifica(altaIdentificaRequest.getNumIdentifica().replace("?", ""));
		altaIdentificaRequest.setFecExIden(altaIdentificaRequest.getFecExIden().replace("?", ""));
		altaIdentificaRequest.setFecVenIden(altaIdentificaRequest.getFecVenIden().replace("?", ""));
		
		if (altaIdentificaRequest.getOperacionID().trim().isEmpty()){
			altaIdentificaResponse.setIdentificaID("0");
			altaIdentificaResponse.setCodigoRespuesta("12");
			altaIdentificaResponse.setMensajeRespuesta("Especifique la Operacion a Realizar");
		}else{
		
			try{
				switch(Utileria.convierteEntero(altaIdentificaRequest.getOperacionID())){
					case (Enum_Tra_Cliente.alta): 
						altaIdentificaResponse = vbcAltaIdentificaCteServicio.altaIdentificaServicio(altaIdentificaRequest);
						break;
					case (Enum_Tra_Cliente.modificacion): 
						altaIdentificaResponse = vbcAltaIdentificaCteServicio.modificaIdentificaServicio(altaIdentificaRequest);
						break;
					default:
						altaIdentificaResponse.setIdentificaID("0");
						altaIdentificaResponse.setCodigoRespuesta("12");
						altaIdentificaResponse.setMensajeRespuesta("La Operacion ID No es Valida.");
				}
			}
			catch(Exception e){
				e.printStackTrace();
			}
		}
		return altaIdentificaResponse;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		// TODO Auto-generated method stub
		VbcAltaIdentificaCteRequest vbcAltaIdentificaCteRequest = (VbcAltaIdentificaCteRequest)arg0;
		return altaIdentificaWSResponse(vbcAltaIdentificaCteRequest);
	}
	public VbcAltaIdentificaCteServicio getVbcAltaIdentificaCteServicio() {
		return vbcAltaIdentificaCteServicio;
	}
	public void setVbcAltaIdentificaCteServicio(
			VbcAltaIdentificaCteServicio vbcAltaIdentificaCteServicio) {
		this.vbcAltaIdentificaCteServicio = vbcAltaIdentificaCteServicio;
	}

	
}
