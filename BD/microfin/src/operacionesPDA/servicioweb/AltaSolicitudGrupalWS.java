package operacionesPDA.servicioweb;

import java.util.List;

import herramientas.Constantes;
import herramientas.Utileria;
import operacionesPDA.bean.DatosIntegrantesBean;
import operacionesPDA.beanWS.request.AltaSolicitudGrupalRequest;
import operacionesPDA.beanWS.response.AltaSolicitudGrupalResponse;
import operacionesPDA.servicio.AltaSolicitudCreditoServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import cliente.bean.ClienteBean;
import cliente.servicio.ClienteServicio;
import credito.bean.GruposCreditoBean;
import credito.bean.ProductosCreditoBean;
import credito.bean.ProspectosBean;
import credito.servicio.GruposCreditoServicio;
import credito.servicio.ProductosCreditoServicio;
import credito.servicio.ProspectosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;

public class AltaSolicitudGrupalWS extends AbstractMarshallingPayloadEndpoint {
	// ALTA DE SOLICITUD DE CREDITO GRUPAL PARA SANA TUS FINANZAS
	public ParametrosCajaServicio parametrosCajaServicio = null;
	public AltaSolicitudCreditoServicio altaSolicitudCreditoServicio = null;
	public ProductosCreditoServicio productosCreditoServicio = null;
	public ClienteServicio clienteServicio = null;
	public GruposCreditoServicio gruposCreditoServicio = null;
	public ProspectosServicio prospectosServicio = null;
	public String tresReyes = "3 REYES";
	public String yanga = "YANGA";
	public String sana = "SANA";

	public AltaSolicitudGrupalWS(Marshaller marshaller){
		super(marshaller);
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		AltaSolicitudGrupalRequest altaSolicitudCredRequest = (AltaSolicitudGrupalRequest)arg0;		
		return altaSolicitudCred(altaSolicitudCredRequest);
	}
	
	private AltaSolicitudGrupalResponse altaSolicitudCred(AltaSolicitudGrupalRequest request){
		AltaSolicitudGrupalResponse solicitudCredito = new AltaSolicitudGrupalResponse();
		ProductosCreditoBean productosCreditoBean = new ProductosCreditoBean();
		ClienteBean clienteBean = new ClienteBean();
		GruposCreditoBean grupoBean = new GruposCreditoBean();
		ProspectosBean prospectoBean = new ProspectosBean();
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		altaSolicitudCreditoServicio.getAltaSolicitudCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		String solicitudesExito = "";
		String solicitudesCteFallo = "";
		int TotalMujeres = 0;
		int TotalMujeresSolteras = 0;
		int TotalHombres = 0;
		try {			
			List<DatosIntegrantesBean> integrantes = request.getIntegrantes().get(0);
			
			// Valida que el Producto de Credito y el Grupo ID esten requisitados
			solicitudCredito = validaProdCredyGpo(request);
			if(solicitudCredito.getCodigoRespuesta()!="0"){
				throw new Exception(solicitudCredito.getMensajeRespuesta());
			}
			
			// Valida que el Producto de Credito Exista
			productosCreditoBean.setProducCreditoID(request.getProductoCreditoID());
			productosCreditoBean = productosCreditoServicio.consulta(ProductosCreditoServicio.Enum_Con_ProductosCredito.existencia, productosCreditoBean);
			
			if(productosCreditoBean.getProducCreditoID().equals("0")){
				solicitudCredito.setCodigoRespuesta("5");
				solicitudCredito.setMensajeRespuesta("El Producto de Crédito Solicitado No Existe.");
				throw new Exception("El Producto de Crédito Solicitado No Existe.");
			}
			// Valida que el Producto de Credito sea Grupal
			productosCreditoBean = productosCreditoServicio.consulta(ProductosCreditoServicio.Enum_Con_ProductosCredito.principal, productosCreditoBean);
			if(productosCreditoBean.getEsGrupal().equals("N")){
				solicitudCredito.setCodigoRespuesta("35");
				solicitudCredito.setMensajeRespuesta("El Producto de Crédito debe ser Grupal.");
				throw new Exception("El Producto de Crédito debe ser Grupal.");
			}

			// Valida que el Grupo exista
			grupoBean.setGrupoID(request.getGrupoID());
			grupoBean = gruposCreditoServicio.consulta(GruposCreditoServicio.Enum_Con_GruposCre.existenciaGpo, grupoBean);
			if(grupoBean.getGrupoID()=="0"){
				solicitudCredito.setCodigoRespuesta("23");
				solicitudCredito.setMensajeRespuesta("El Grupo indicado No Existe.");
				throw new Exception("El Grupo indicado No Existe.");
			}
			if(integrantes.size() <= Utileria.convierteEntero(productosCreditoBean.getMaxIntegrantes()) &&
					Utileria.convierteEntero(grupoBean.gettInt())<= Utileria.convierteEntero(productosCreditoBean.getMaxIntegrantes())){
				// Se recorren todos los integrantes en busca de campos vacios
				for(int index = 0; index < integrantes.size(); index++){
					DatosIntegrantesBean datos = (DatosIntegrantesBean) integrantes.get(index);
					request.setProspectoID(datos.getProspectoID().trim());
					request.setClienteID(datos.getClienteID().trim());
					request.setDestinoCredito(datos.getDestinoCredito().trim());
					request.setProyecto(datos.getProyecto().trim());
					request.setMontoSolici(datos.getMontoSolici().trim());
					request.setTipoIntegrante(datos.getTipoIntegrante().trim());

					solicitudCredito = validaVacios(request);
					if(solicitudCredito.getCodigoRespuesta()!="0"){
						throw new Exception(solicitudCredito.getMensajeRespuesta());
					}
					
					// Conteo por genero de integrantes
					// Si es Cliente
					if(Utileria.convierteEntero(request.getClienteID())>0){
						clienteBean = clienteServicio.consulta(ClienteServicio.Enum_Con_Cliente.resumen, request.getClienteID(), null);
						if(clienteBean.getClienteID()!=null&&Utileria.convierteEntero(clienteBean.getClienteID())>0){
							if(clienteBean.getSexo().equals("M")){
								TotalHombres ++;
							} else if(clienteBean.getSexo().equals("F")){
								TotalMujeres ++;
								if(clienteBean.getEstadoCivil().equals("S")){
									TotalMujeresSolteras ++;
								}
							}
						}
					}
					// Si es Prospecto
					if(request.getClienteID().equals("0")&& Utileria.convierteEntero(request.getProspectoID())>0){
						prospectoBean.setProspectoID(request.getProspectoID());
						prospectoBean = prospectosServicio.consulta(ProspectosServicio.Enum_Con_Prospecto.foranea, prospectoBean);
						if(prospectoBean!=null){
							if(prospectoBean.getSexo().equals("M")){
								TotalHombres ++;
							} else if(prospectoBean.getSexo().equals("F")){
								TotalMujeres ++;
								if(prospectoBean.getEstadoCivil().equals("S")){
									TotalMujeresSolteras ++;
								}
							}
						}
					}
				}
				// Valida el Numero de Integrantes Hombres, Mujeres y Mujeres Solteras
				solicitudCredito = validaNumIntegrantes(productosCreditoBean, TotalHombres, TotalMujeres, TotalMujeresSolteras);
				if(solicitudCredito.getCodigoRespuesta()!="0"){
					throw new Exception(solicitudCredito.getMensajeRespuesta());
				}
			} else {
				solicitudCredito.setCodigoRespuesta("33");
				solicitudCredito.setMensajeRespuesta("El Número de Integrantes es Incorrecto.");
				throw new Exception("El Número de Integrantes es Incorrecto.");
			}
			 // Se valida la version de WS
			if(parametrosCajaBean.getVersionWS().equals(yanga)||parametrosCajaBean.getVersionWS().equals(tresReyes)||
					parametrosCajaBean.getVersionWS().equals(sana)){			
				for(int index = 0; index < integrantes.size(); index++){
					DatosIntegrantesBean datos = (DatosIntegrantesBean) integrantes.get(index);
					request.setProspectoID(datos.getProspectoID().trim());
					request.setClienteID(datos.getClienteID().trim());
					request.setDestinoCredito(datos.getDestinoCredito().trim());
					request.setProyecto(datos.getProyecto().trim());
					request.setMontoSolici(datos.getMontoSolici().trim());
					request.setTipoIntegrante(datos.getTipoIntegrante().trim());
					
					// Validar que el monto solicitado se encuentre en lo parametrizado en el productos de credito
					if(Utileria.convierteDoble(request.getMontoSolici())>=Utileria.convierteDoble(productosCreditoBean.getMontoMinimo()) && 
							Utileria.convierteDoble(request.getMontoSolici())<=Utileria.convierteDoble(productosCreditoBean.getMontoMaximo())){
						solicitudCredito = altaSolicitudCreditoServicio.solicitudGrupal(request);						
					} else {
						solicitudCredito.setCodigoRespuesta("42");
						solicitudCredito.setMensajeRespuesta("El monto solicitado no se encuentra en los parametros del Producto de Credito");
						throw new Exception("El monto solicitado no se encuentra en los parametros del Producto de Credito");
					}
					
					if(integrantes.size()!=1){
						if(solicitudCredito.getCodigoRespuesta().equals("0")){
							solicitudesExito = solicitudesExito + solicitudCredito.getSolicitudCreditoID() + ". ";
						} else {
							solicitudesCteFallo = solicitudesCteFallo + "\nCliente: "
									+ solicitudCredito.getClienteID()
									+ ". Código Respuesta: "
									+ solicitudCredito.getCodigoRespuesta()
									+ ". Mensaje Respuesta: "
									+ solicitudCredito.getMensajeRespuesta() + " ";
						}
					}
				}
			} else {
				solicitudCredito.setCodigoRespuesta("34");
				solicitudCredito.setMensajeRespuesta("La Transacción No puede Ser Aplicada. Verifique la Versión de WS.");
				throw new Exception("La Transacción No puede Ser Aplicada. Verifique la Versión de WS.");
			}
			
			// Concatena el mensaje de Respuesta dependiendo si las solicitudes fueron exito o no
			if(solicitudesExito.length()>0 && solicitudesCteFallo.length()>0){
				solicitudCredito.setMensajeRespuesta("Solicitud(es) de Crédito Agregada(s) Exitosamente: " + solicitudesExito +
						"\nSolicitud(des) Fallida(s): " + solicitudesCteFallo);				
			} else if(solicitudesExito.length()>0 && solicitudesCteFallo.length()==0){
				solicitudCredito.setMensajeRespuesta("Solicitud(es) de Crédito Agregada(s) Exitosamente: " + solicitudesExito);				
			} else if(solicitudesExito.length()==0 && solicitudesCteFallo.length()>0){
				solicitudCredito.setMensajeRespuesta("Solicitud(des) Fallida(s): " + solicitudesCteFallo);				
			}
		} catch (Exception e) {
			e.printStackTrace();
			if(solicitudCredito.getCodigoRespuesta().isEmpty()){
				solicitudCredito.setCodigoRespuesta("999");
				solicitudCredito.setMensajeRespuesta("Estimado Usuario(a), Ha ocurrido una falla en el sistema, "
						+ "estamos trabajando para resolverla. Disculpe las molestias que esto le ocasiona. Ref: SP-SOLICITUDCREDWSALT");
			}
			solicitudCredito.setSolicitudCreditoID(String.valueOf(Constantes.ENTERO_CERO));
		}
		return solicitudCredito;
	}

	public AltaSolicitudGrupalResponse validaProdCredyGpo(AltaSolicitudGrupalRequest request){
		AltaSolicitudGrupalResponse solicitudCredito= new AltaSolicitudGrupalResponse();
		if(request.getProductoCreditoID().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("04");
			solicitudCredito.setMensajeRespuesta("El Producto de Crédito Solicitado está vacío.");
		} else if(request.getProductoCreditoID().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("05");
			solicitudCredito.setMensajeRespuesta("El Producto de Crédito Solicitado No Existe.");
		} else if(request.getGrupoID().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("23");
			solicitudCredito.setMensajeRespuesta("El Grupo indicado No Existe.");
		} else if(request.getGrupoID().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("25");
			solicitudCredito.setMensajeRespuesta("El Grupo está vacío.");
		} else 
			solicitudCredito.setCodigoRespuesta("0");
			
		return solicitudCredito;
	}
	
	public AltaSolicitudGrupalResponse validaVacios(AltaSolicitudGrupalRequest request){
		AltaSolicitudGrupalResponse solicitudCredito= new AltaSolicitudGrupalResponse();
		String DispersionSPEI = "S";
		if((request.getClienteID().trim().isEmpty()||request.getProspectoID().isEmpty())||
				(request.getClienteID().trim().equals("0")&&request.getProspectoID().equals("0"))){
			solicitudCredito.setCodigoRespuesta("01");
			solicitudCredito.setMensajeRespuesta("El Prospecto o Cliente está vacío.");
		} else if(request.getMontoSolici().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("03");
			solicitudCredito.setMensajeRespuesta("El Monto Solicitado está vacío.");
		} else if(request.getPlazo().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("06");
			solicitudCredito.setMensajeRespuesta("El Plazo está vacío.");
		} else if(request.getPeriodicidad().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("07");
			solicitudCredito.setMensajeRespuesta("La Periodicidad está vacía o no es válida.");
		} else if(request.getTipoDispersion().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("08");
			solicitudCredito.setMensajeRespuesta("El Tipo de Dispersión está vacío.");
		} else if(request.getTipoDispersion().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("09");
			solicitudCredito.setMensajeRespuesta("Tipo de Dispersión No Válido.");
		} else if(request.getClienteID().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("11");
			solicitudCredito.setMensajeRespuesta("El Cliente Indicado No Existe.");
		} else if(request.getClaveUsuario().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("14");
			solicitudCredito.setMensajeRespuesta("El Usuario está vacío.");
		} else if(request.getDestinoCredito().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("15");
			solicitudCredito.setMensajeRespuesta("El Destino de Crédito está vacío.");
		} else if(request.getDestinoCredito().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("16");
			solicitudCredito.setMensajeRespuesta("El Destino de Crédito No Existe.");
		} else if(request.getTipoDispersion().trim().equals(DispersionSPEI) && (request.getCuentaCLABE().trim().isEmpty() || request.getCuentaCLABE().trim().equals("?"))){
			solicitudCredito.setCodigoRespuesta("18");
			solicitudCredito.setMensajeRespuesta("La Cuenta CLABE está vacía.");
		} else if(request.getPeriodicidad().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("20");
			solicitudCredito.setMensajeRespuesta("La Periodicidad no es válida para el Tipo de Producto de Crédito.");
		} else if(request.getPlazo().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("21");
			solicitudCredito.setMensajeRespuesta("El Plazo ID no es válido para el Tipo de Producto de Crédito.");
		} else if(request.getProyecto().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("24");
			solicitudCredito.setMensajeRespuesta("El Proyecto está vacío");
		} else if(request.getTipoIntegrante().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("27");
			solicitudCredito.setMensajeRespuesta("El Tipo de Integrante está vacío.");
		} else if(request.getTipoIntegrante().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("28");
			solicitudCredito.setMensajeRespuesta("El Tipo de Integrante No Existe.");
		} else if(request.getTipoPagoCapital().trim().isEmpty()){
			solicitudCredito.setCodigoRespuesta("29");
			solicitudCredito.setMensajeRespuesta("El Tipo Pago Capital está vacío.");
		} else if(request.getTipoPagoCapital().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("30");
			solicitudCredito.setMensajeRespuesta("El Tipo Pago Capital No Existe.");
		} else if(request.getFolio().trim().isEmpty()||request.getFolio().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("31");
			solicitudCredito.setMensajeRespuesta("El Folio está vacío.");
		} else if(request.getDispositivo().trim().isEmpty()||request.getDispositivo().trim().equals("?")){
			solicitudCredito.setCodigoRespuesta("32");
			solicitudCredito.setMensajeRespuesta("El Dispositivo está vacío.");
		} else 
			solicitudCredito.setCodigoRespuesta("0");
			
		return solicitudCredito;
	}

	public AltaSolicitudGrupalResponse validaNumIntegrantes(ProductosCreditoBean productosCreditoBean, int numHombres, int numMujeres, int numMSolteras){
		AltaSolicitudGrupalResponse solicitudCredito= new AltaSolicitudGrupalResponse();
		solicitudCredito.setCodigoRespuesta("0");
		int TotalHombres = numHombres;
		int TotalMujeres = numMujeres;
		int TotalMujeresSolteras = numMSolteras;

		if(Utileria.convierteEntero(productosCreditoBean.getMaxHombres())>0){
			if(TotalHombres>Utileria.convierteEntero(productosCreditoBean.getMaxHombres())){
					solicitudCredito.setCodigoRespuesta("36");
					solicitudCredito.setMensajeRespuesta("Se ha Alcanzado el Numero Maximo de Hombres para el Grupo.");
					return solicitudCredito;
			}
		} else {
			solicitudCredito.setCodigoRespuesta("37");
			solicitudCredito.setMensajeRespuesta("El Producto de Credito no Admite Hombres.");
			return solicitudCredito;			
		}
		if(Utileria.convierteEntero(productosCreditoBean.getMaxMujeres())>0){
			if(TotalMujeres>Utileria.convierteEntero(productosCreditoBean.getMaxMujeres())){
					solicitudCredito.setCodigoRespuesta("38");
					solicitudCredito.setMensajeRespuesta("Se ha Alcanzado el Numero Maximo de Mujeres para el Grupo.");
					return solicitudCredito;
			}
		} else {
			solicitudCredito.setCodigoRespuesta("39");
			solicitudCredito.setMensajeRespuesta("El Producto de Credito no Admite Mujeres.");
			return solicitudCredito;			
		}
		if(Utileria.convierteEntero(productosCreditoBean.getMaxMujeresSol())>0){
			if(TotalMujeresSolteras>Utileria.convierteEntero(productosCreditoBean.getMaxMujeresSol())){
					solicitudCredito.setCodigoRespuesta("40");
					solicitudCredito.setMensajeRespuesta("Se ha Alcanzado el Numero Maximo de Mujeres Solteras para el Grupo.");
					return solicitudCredito;
			}
		} else {
			solicitudCredito.setCodigoRespuesta("41");
			solicitudCredito.setMensajeRespuesta("El Producto de Credito no Admite Mujeres Solteras.");
			return solicitudCredito;
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

	public ProductosCreditoServicio getProductosCreditoServicio() {
		return productosCreditoServicio;
	}

	public void setProductosCreditoServicio(
			ProductosCreditoServicio productosCreditoServicio) {
		this.productosCreditoServicio = productosCreditoServicio;
	}

	public ClienteServicio getClienteServicio() {
		return clienteServicio;
	}

	public void setClienteServicio(ClienteServicio clienteServicio) {
		this.clienteServicio = clienteServicio;
	}

	public GruposCreditoServicio getGruposCreditoServicio() {
		return gruposCreditoServicio;
	}

	public void setGruposCreditoServicio(GruposCreditoServicio gruposCreditoServicio) {
		this.gruposCreditoServicio = gruposCreditoServicio;
	}

	public ProspectosServicio getProspectosServicio() {
		return prospectosServicio;
	}

	public void setProspectosServicio(ProspectosServicio prospectosServicio) {
		this.prospectosServicio = prospectosServicio;
	}
	
}
