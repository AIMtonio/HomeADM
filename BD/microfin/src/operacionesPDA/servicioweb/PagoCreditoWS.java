package operacionesPDA.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesPDA.beanWS.request.PagoCreditoRequest;
import operacionesPDA.beanWS.response.PagoCreditoResponse;
import operacionesPDA.servicio.PagoCreditoServico;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import credito.bean.CreditosBean;
import credito.servicio.CreditosServicio;
import credito.servicio.CreditosServicio.Enum_Con_Creditos;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class PagoCreditoWS extends AbstractMarshallingPayloadEndpoint {
	// ALTA DE SOLICITUD DE CREDITO PARA SANA TUS FINANZAS
	public ParametrosCajaServicio parametrosCajaServicio = null;
	public PagoCreditoServico pagoCreditoServicio = null;
	public CreditosServicio creditosServicio = null;
	public String tresReyes = "3 REYES";
	public String yanga = "YANGA";
	public String sana = "SANA";

	public PagoCreditoWS(Marshaller marshaller){
		super(marshaller);
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		PagoCreditoRequest pagoCreditoRequest = (PagoCreditoRequest)arg0;		
		return pagoCreditoWS(pagoCreditoRequest);
	}
	
	private PagoCreditoResponse pagoCreditoWS(PagoCreditoRequest request){
		PagoCreditoResponse pagoCredito= new PagoCreditoResponse();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		pagoCreditoServicio.getPagoCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		//CreditosBean creditosBean = new CreditosBean();
		
		/* Validacion de campos del Request y despues ejecuta la consulta */
		try {
			
			if (!request.getCreditoID().trim().equals("?") 
					 && !request.getMonto().trim().equals("?")
					 && !request.getMontoGL().trim().equals("?")
					 && !request.getFolio().trim().equals("?")
					 && !request.getClaveUsuario().trim().equals("?")
					 && !request.getDispositivo().trim().equals("?")){
				
				if(Utileria.convierteDoble(request.getMonto()) > 0 &&
					!request.getMonto().trim().equals("?") &&
					!request.getMonto().trim().equals("")) {
					
					if(parametrosCajaBean.getVersionWS().equals(yanga)||parametrosCajaBean.getVersionWS().equals(tresReyes)||
							parametrosCajaBean.getVersionWS().equals(sana)){
						pagoCredito = pagoCreditoServicio.pagoCreditoServcio(request);
					} else {
						pagoCredito.setCodigoRespuesta("27");
						pagoCredito.setMensajeRespuesta("La Transacción No puede Ser Aplicada. Verifique la Versión de WS.");
						throw new Exception("La Transacción No puede Ser Aplicada. Verifique la Versión de WS.");
					}
					
				} else {
					pagoCredito.setCodigoRespuesta("2");
					pagoCredito.setMensajeRespuesta("El Monto debe de ser mayor a 0.");
					throw new Exception("El Monto debe de ser mayor a 0.");
				}
			} else {
				pagoCredito.setCreditoID(request.getCreditoID());
				pagoCredito.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				pagoCredito.setSaldoExigible(String.valueOf(Constantes.DOUBLE_VACIO));
				pagoCredito.setSaldoTotalActual(String.valueOf(Constantes.DOUBLE_VACIO));
				pagoCredito.setCodigoRespuesta("999");
				pagoCredito.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDWSPRO");
			}
		
		} catch (Exception e) {
			e.printStackTrace();
			if(pagoCredito.getCodigoRespuesta().isEmpty()){
				pagoCredito.setCodigoRespuesta("999");
				pagoCredito.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-PAGOCREDWSPRO");
			}
			pagoCredito.setCreditoID(request.getCreditoID());
			pagoCredito.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
			pagoCredito.setSaldoExigible(String.valueOf(Constantes.DOUBLE_VACIO));
			pagoCredito.setSaldoTotalActual(String.valueOf(Constantes.DOUBLE_VACIO));
		}
		return pagoCredito;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

	public PagoCreditoServico getPagoCreditoServicio() {
		return pagoCreditoServicio;
	}

	public void setPagoCreditoServicio(PagoCreditoServico pagoCreditoServicio) {
		this.pagoCreditoServicio = pagoCreditoServicio;
	}

	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

}
