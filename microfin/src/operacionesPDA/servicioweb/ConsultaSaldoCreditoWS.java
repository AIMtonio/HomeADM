package operacionesPDA.servicioweb;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesPDA.beanWS.request.ConsultaSaldoCreditoRequest;
import operacionesPDA.beanWS.response.ConsultaSaldoCreditoResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.ParametrosCajaServicio;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
import credito.bean.AmortizacionCreditoBean;
import credito.bean.CreditosBean;
import credito.bean.GruposCreditoBean;
import credito.bean.ProductosCreditoBean;
import credito.servicio.AmortizacionCreditoServicio;
import credito.servicio.CreditosServicio;
import credito.servicio.CreditosServicio.Enum_Con_Creditos;
import credito.servicio.GruposCreditoServicio;
import credito.servicio.ProductosCreditoServicio;

public class ConsultaSaldoCreditoWS  extends AbstractMarshallingPayloadEndpoint{
	ParametrosCajaServicio parametrosCajaServicio = null;
	CreditosServicio creditosServicio  = null;
	UsuarioServicio usuarioServicio = null;
	AmortizacionCreditoServicio amortizacionCreditoServicio = null;
	ProductosCreditoServicio productosCreditoServicio = null;
	GruposCreditoServicio gruposCreditoServicio = null; 
	
	public String varSana = "SANA";

	public ConsultaSaldoCreditoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ConsultaSaldoCreditoResponse consultaSaldoCredito(ConsultaSaldoCreditoRequest consultaSaldoCreditoRequest){
		String estatusCredito;
		String esGrupal = "";
		String cicloGpo = "";
		ConsultaSaldoCreditoResponse consultaSaldoCreditoResponse= new ConsultaSaldoCreditoResponse();
		
		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuarioBeans = new UsuarioBean();
		UsuarioBean usuarioBeanWS = new UsuarioBean();
		
		CreditosBean creditosBean = new CreditosBean();
		AmortizacionCreditoBean amortizaBean = new AmortizacionCreditoBean();
		ProductosCreditoBean productosCredBean = new ProductosCreditoBean();
		GruposCreditoBean gruposBean = new GruposCreditoBean();
		
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		String var_OrigenDatos = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		creditosServicio.getCreditosDAO().getParametrosAuditoriaBean().setOrigenDatos(var_OrigenDatos);
		
		try {
			// Validar que los Datos, no esten vacíos.
			if (consultaSaldoCreditoRequest.getCreditoID().isEmpty()) {
				creditosBean.setCreditoID(Constantes.STRING_CERO);
								
				consultaSaldoCreditoResponse.setCodigoRespuesta("01");
				consultaSaldoCreditoResponse.setMensajeRespuesta("El numero de Crédito esta Vacío.");
				throw new Exception("El numero de Crédito esta Vacío.");
			}else if( Utileria.convierteLong(consultaSaldoCreditoRequest.getCreditoID()) == 0){
				consultaSaldoCreditoResponse.setCodigoRespuesta("03");
				consultaSaldoCreditoResponse.setMensajeRespuesta("No existe el Crédito.");
				throw new Exception("No existe el Crédito.");
			}else{
				creditosBean.setCreditoID(consultaSaldoCreditoRequest.getCreditoID());
			}

			if (consultaSaldoCreditoRequest.getFolio().isEmpty()) {
				consultaSaldoCreditoResponse.setCodigoRespuesta("05");
				consultaSaldoCreditoResponse.setMensajeRespuesta("El Campo Folio Esta Vacío.");
				throw new Exception("El Campo Folio Esta Vacío.");
			}
			
			if (consultaSaldoCreditoRequest.getClaveUsuario().isEmpty()) {
				consultaSaldoCreditoResponse.setCodigoRespuesta("06");
				consultaSaldoCreditoResponse.setMensajeRespuesta("La Clave del Usuario Esta Vacía.");
				throw new Exception("La Clave del Usuario Esta Vacía.");
			}
			
			if (consultaSaldoCreditoRequest.getDispositivo().isEmpty()) {
				consultaSaldoCreditoResponse.setCodigoRespuesta("07");
				consultaSaldoCreditoResponse.setMensajeRespuesta("El Campo Dispositivo Esta Vacío.");
				throw new Exception("El Campo Dispositivo Esta Vacío.");
			}
			// Validar que el Usuario Exista
			usuarioBean.setClave(consultaSaldoCreditoRequest.getClaveUsuario());
			usuarioBean = usuarioServicio.consulta(Enum_Con_Usuario.clave, usuarioBean);
				
			if (usuarioBean != null) {
				usuarioBeans.setUsuarioID(usuarioBean.getUsuarioID());
				usuarioBeans = usuarioServicio.consulta(Enum_Con_Usuario.consultaWS, usuarioBeans);
				
				// Validar que el Rol del Usuario, sea el indicado
				usuarioBeanWS.setClave(consultaSaldoCreditoRequest.getClaveUsuario());
				usuarioBeanWS.setContrasenia(usuarioBean.getContrasenia());
				usuarioBeanWS.setSucursalUsuario(usuarioBeans.getSucursalUsuario());
				
				usuarioBeanWS = usuarioServicio.consulta(Enum_Con_Usuario.pdaValidaUserWS, usuarioBeanWS);
				
				if (usuarioBeanWS.getEsValido().equals("true")) {
					// Validar Version WS
					if(parametrosCajaBean.getVersionWS().equals(varSana)){
						creditosBean = creditosServicio.consulta(Enum_Con_Creditos.generalesCredito,creditosBean);
					} else {
						consultaSaldoCreditoResponse.setCodigoRespuesta("99");
						throw new Exception("Error: La Transacción No puede Ser Aplicada. Verifique la Versión de WS.");
					}
					if(creditosBean != null){
						estatusCredito = creditosBean.getEstatus();
						if(Utileria.convierteEntero(creditosBean.getGrupoID())==0){
							esGrupal="N";
						} else if(Utileria.convierteEntero(creditosBean.getGrupoID())!=0){
							esGrupal="S";
						}
						if (esGrupal.equalsIgnoreCase("S")) {
							productosCredBean.setProducCreditoID(creditosBean.getProducCreditoID());
							productosCredBean = productosCreditoServicio.consulta(ProductosCreditoServicio.Enum_Con_ProductosCredito.foranea, productosCredBean);
							if(productosCredBean.getProrrateoPago().equalsIgnoreCase("S")){
								// Ciclo del Credito Grupal
								cicloGpo = creditosBean.getCicloGrupo();
								gruposBean.setGrupoID(creditosBean.getGrupoID());
								gruposBean.setCicloActual(cicloGpo);
								
								// Consulta Saldo Total del Adeudo Grupal
								gruposBean = gruposCreditoServicio.consulta(GruposCreditoServicio.Enum_Con_GruposCre.finiquito, gruposBean);
								consultaSaldoCreditoResponse.setSaldoTotal(gruposBean.getMontoTotDeuda().replace(",", ""));
								
								// Consulta Saldo Exigible y Proyeccion Grupal
								gruposBean.setGrupoID(creditosBean.getGrupoID());
								gruposBean.setCicloActual(cicloGpo);
								gruposBean = gruposCreditoServicio.consulta(GruposCreditoServicio.Enum_Con_GruposCre.totalExigible, gruposBean);
								consultaSaldoCreditoResponse.setSaldoExigibleDia(String.valueOf(gruposBean.getTotalExigibleDia()));
								consultaSaldoCreditoResponse.setProyeccion(String.valueOf(gruposBean.getTotalCuotaAdelantada()));
							} else {
								consultaSaldoCreditoResponse = consultaIndividual(consultaSaldoCreditoRequest);
							}
						} else {
							consultaSaldoCreditoResponse = consultaIndividual(consultaSaldoCreditoRequest);
						}
						// Consulta del Saldo Final a Plazo de las Amortizaciones tanto para grupales como individuales
						amortizaBean.setCreditoID(consultaSaldoCreditoRequest.getCreditoID());
						amortizaBean = amortizacionCreditoServicio.consulta(AmortizacionCreditoServicio.Enum_Con_AmortizacionCredito.saldoFinalPlazo, amortizaBean);
						consultaSaldoCreditoResponse.setSaldoFinalPlazo(amortizaBean.getSaldoFinalPlazo());
						
						// Dependiendo del Estatus del Credito tanto para grupales como individuales
						if (estatusCredito.equals("V")) {
							consultaSaldoCreditoResponse.setCodigoRespuesta("00");
							consultaSaldoCreditoResponse.setMensajeRespuesta("Consulta Exitosa.");
						} else {
							consultaSaldoCreditoResponse.setCodigoRespuesta("04");
							consultaSaldoCreditoResponse.setMensajeRespuesta("El Crédito No está Vigente.");
						}
						
					} else {
						consultaSaldoCreditoResponse.setCodigoRespuesta("02");
						consultaSaldoCreditoResponse.setMensajeRespuesta("No existen Datos para el Crédito.");
						
						consultaSaldoCreditoResponse.setSaldoTotal(Constantes.STRING_CERO);
						consultaSaldoCreditoResponse.setSaldoExigibleDia(Constantes.STRING_CERO);
						consultaSaldoCreditoResponse.setProyeccion(Constantes.STRING_CERO);
						consultaSaldoCreditoResponse.setSaldoFinalPlazo(Constantes.STRING_CERO);
					}
				} else {
					consultaSaldoCreditoResponse.setCodigoRespuesta("09");
					consultaSaldoCreditoResponse.setMensajeRespuesta("El Usuario que realiza la Operación no es Correcto.");
					throw new Exception("El Usuario que realiza la Operación no es Correcto.");
				}
			
			} else {
				consultaSaldoCreditoResponse.setCodigoRespuesta("08");
				consultaSaldoCreditoResponse.setMensajeRespuesta("El Usuario que Realiza la Transacción No existe.");
				throw new Exception("El Usuario que Realiza la Transacción No existe.");
			}
		} catch (Exception e) {
			e.getMessage();
			if(consultaSaldoCreditoResponse.getCodigoRespuesta().isEmpty()){
				consultaSaldoCreditoResponse.setCodigoRespuesta("999");
				consultaSaldoCreditoResponse.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: CONSULTASALDOCREDITOWS");
			}
			consultaSaldoCreditoResponse.setSaldoTotal(Constantes.STRING_CERO);
			consultaSaldoCreditoResponse.setSaldoExigibleDia(Constantes.STRING_CERO);
			consultaSaldoCreditoResponse.setProyeccion(Constantes.STRING_CERO);
			consultaSaldoCreditoResponse.setSaldoFinalPlazo(Constantes.STRING_CERO);
			
		}
		
		return consultaSaldoCreditoResponse;
	}
	private ConsultaSaldoCreditoResponse consultaIndividual(ConsultaSaldoCreditoRequest request){
		CreditosBean creditosBean = new CreditosBean();
		ConsultaSaldoCreditoResponse consultaSaldoCreditoResponse = new ConsultaSaldoCreditoResponse();
		
		// Consulta Saldo Total del Adeudo
		creditosBean.setCreditoID(request.getCreditoID());
		creditosBean = creditosServicio.consulta(Enum_Con_Creditos.finiquitoLiq,creditosBean);
		consultaSaldoCreditoResponse.setSaldoTotal(creditosBean.getAdeudoTotal().replace(",", ""));
		
		// Consulta Saldo Exigible y Proyeccion
		creditosBean.setCreditoID(request.getCreditoID());
		creditosBean = creditosServicio.consulta(Enum_Con_Creditos.pagoExigible,creditosBean);
		consultaSaldoCreditoResponse.setSaldoExigibleDia(String.valueOf(creditosBean.getTotalExigibleDia()));
		consultaSaldoCreditoResponse.setProyeccion(String.valueOf(creditosBean.getTotalCuotaAdelantada()));
		
		return consultaSaldoCreditoResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaSaldoCreditoRequest ConsultaSaldoCreditoRequest = (ConsultaSaldoCreditoRequest)arg0;
		return consultaSaldoCredito(ConsultaSaldoCreditoRequest);
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
	
	public CreditosServicio getCreditosServicio() {
		return creditosServicio;
	}

	public void setCreditosServicio(CreditosServicio creditosServicio) {
		this.creditosServicio = creditosServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

	public AmortizacionCreditoServicio getAmortizacionCreditoServicio() {
		return amortizacionCreditoServicio;
	}

	public void setAmortizacionCreditoServicio(
			AmortizacionCreditoServicio amortizacionCreditoServicio) {
		this.amortizacionCreditoServicio = amortizacionCreditoServicio;
	}

	public ProductosCreditoServicio getProductosCreditoServicio() {
		return productosCreditoServicio;
	}

	public void setProductosCreditoServicio(
			ProductosCreditoServicio productosCreditoServicio) {
		this.productosCreditoServicio = productosCreditoServicio;
	}

	public GruposCreditoServicio getGruposCreditoServicio() {
		return gruposCreditoServicio;
	}

	public void setGruposCreditoServicio(GruposCreditoServicio gruposCreditoServicio) {
		this.gruposCreditoServicio = gruposCreditoServicio;
	}
	
}
