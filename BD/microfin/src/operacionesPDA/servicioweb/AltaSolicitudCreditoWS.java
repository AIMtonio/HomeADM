package operacionesPDA.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesPDA.beanWS.request.AltaSolicitudCreditoRequest;
import operacionesPDA.beanWS.response.AltaSolicitudCreditoResponse;
import operacionesPDA.servicio.AltaSolicitudCreditoServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class AltaSolicitudCreditoWS extends AbstractMarshallingPayloadEndpoint {
	// ALTA DE SOLICITUD DE CREDITO PARA SANA TUS FINANZAS
	public ParametrosCajaServicio parametrosCajaServicio = null;
	public AltaSolicitudCreditoServicio altaSolicitudCreditoServicio = null;
	public String tresReyes = "3 REYES";
	public String yanga = "YANGA";
	public String sana = "SANA";

	public AltaSolicitudCreditoWS(Marshaller marshaller){
		super(marshaller);
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaSolicitudCreditoRequest altaSolicitudCredRequest = (AltaSolicitudCreditoRequest)arg0;		
		return altaSolicitudCred(altaSolicitudCredRequest);
	}
	
	private AltaSolicitudCreditoResponse altaSolicitudCred(AltaSolicitudCreditoRequest request){
		AltaSolicitudCreditoResponse solicitudCredito= new AltaSolicitudCreditoResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		altaSolicitudCreditoServicio.getAltaSolicitudCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		AltaSolicitudCreditoRequest beanRequest = new AltaSolicitudCreditoRequest();
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		/* Validacion de campos del Request y despues ejecuta la consulta */
		try {
			
			if (!request.getClienteID().trim().equals("?") 
					 && !request.getProspectoID().trim().equals("?")
					 && !request.getProductoCreditoID().trim().equals("?")
					 && !request.getPeriodicidad().trim().equals("?")
					 && !request.getPlazo().trim().equals("?")
					 && !request.getDestinoCredito().trim().equals("?")
					 && !request.getProyecto().trim().equals("?")
					 && !request.getTipoDispersion().trim().equals("?")
					 && !request.getCuentaCLABE().trim().equals("?")
					 && !request.getTipoPagoCapital().trim().equals("?")
					 && !request.getTipoCredito().trim().equals("?")
					 && !request.getNumeroCredito().trim().equals("?")
					 && !request.getFolio().trim().equals("?")
					 && !request.getClaveUsuario().trim().equals("?")
					 && !request.getDispositivo().trim().equals("?")){
				
					 if(Utileria.convierteDoble(request.getMontoSolici()) > 0 &&
						!request.getMontoSolici().trim().equals("?") &&
						!request.getMontoSolici().trim().equals("")) {
						 
							beanRequest.setClienteID(request.getClienteID());
							beanRequest.setProspectoID(request.getProspectoID());
							beanRequest.setMontoSolici(request.getMontoSolici());
							beanRequest.setProductoCreditoID(request.getProductoCreditoID());
							beanRequest.setPeriodicidad(request.getPeriodicidad());
							beanRequest.setPlazo(request.getPlazo());
							beanRequest.setDestinoCredito(request.getDestinoCredito());
							beanRequest.setProyecto(request.getProyecto());
							beanRequest.setTipoDispersion(request.getTipoDispersion());
							beanRequest.setCuentaCLABE(request.getCuentaCLABE());
							beanRequest.setTipoPagoCapital(request.getTipoPagoCapital());
							beanRequest.setTipoCredito(request.getTipoCredito());
							beanRequest.setNumeroCredito(request.getNumeroCredito());
							beanRequest.setFolio(request.getFolio());
							beanRequest.setClaveUsuario(request.getClaveUsuario());
							beanRequest.setDispositivo(request.getDispositivo());
							
							if(parametrosCajaBean.getVersionWS().equals(yanga)||parametrosCajaBean.getVersionWS().equals(tresReyes)||
									parametrosCajaBean.getVersionWS().equals(sana)){
								solicitudCredito = altaSolicitudCreditoServicio.solicitud(beanRequest);
							}
					} else {
						solicitudCredito.setCodigoRespuesta("3");
						solicitudCredito.setMensajeRespuesta("El Monto Solicitado está vacío.");
						solicitudCredito.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
					}
			} else {
				solicitudCredito.setCodigoRespuesta("999");
				solicitudCredito.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT");
				solicitudCredito.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
			}
		
	} catch (Exception e) {		
			e.printStackTrace();
			System.out.println("ERROR sana tus finanzas: " + e );
			solicitudCredito.setCodigoRespuesta("999");
			solicitudCredito.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
					+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT");
			solicitudCredito.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
		}
		return solicitudCredito;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

	public AltaSolicitudCreditoServicio getAltaSolicitudCreditoServicio() {
		return altaSolicitudCreditoServicio;
	}

	public void setAltaSolicitudCreditoServicio(
			AltaSolicitudCreditoServicio altaSolicitudCreditoServicio) {
		this.altaSolicitudCreditoServicio = altaSolicitudCreditoServicio;
	}
	
}
