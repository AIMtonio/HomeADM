package operacionesPDA.servicioweb;

import herramientas.Constantes;
import operacionesPDA.beanWS.request.SolAltaClienteRequest;
import operacionesPDA.beanWS.response.SolAltaClienteResponse;
import operacionesPDA.servicio.SolAltaClienteServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import seguridad.servicio.SeguridadRecursosServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.servicio.ParametrosCajaServicio;


public class SolAltaClienteWS extends AbstractMarshallingPayloadEndpoint{
	SolAltaClienteServicio solAltaClienteServicio = null;
	ParametrosCajaServicio parametrosCajaServicio = null;
	String varSana= "SANA";
	
	public SolAltaClienteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SolAltaClienteResponse solAltaCliente(SolAltaClienteRequest solAltaClienteRequest){
		SolAltaClienteResponse solAltaClienteResponse = new SolAltaClienteResponse();
		String var_OrigenDatos = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		solAltaClienteServicio.getSolAltaClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(var_OrigenDatos);
		
		SolAltaClienteRequest requestBean = new SolAltaClienteRequest();
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
			
		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		try {
			requestBean.setPrimerNombre(solAltaClienteRequest.getPrimerNombre());								
			requestBean.setSegundoNombre(solAltaClienteRequest.getSegundoNombre());								
			requestBean.setTercerNombre(solAltaClienteRequest.getTercerNombre());								
			requestBean.setApPaterno(solAltaClienteRequest.getApPaterno());
			requestBean.setApMaterno(solAltaClienteRequest.getApMaterno());

			requestBean.setFecNacimiento(solAltaClienteRequest.getFecNacimiento());
			requestBean.setTitulo(solAltaClienteRequest.getTitulo());
			requestBean.setRFC(solAltaClienteRequest.getRFC());
			requestBean.setCURP(solAltaClienteRequest.getCURP());
			requestBean.setEstadoCivil(solAltaClienteRequest.getEstadoCivil());

			requestBean.setSucursal(solAltaClienteRequest.getSucursal());
			requestBean.setMail(solAltaClienteRequest.getMail());
			requestBean.setPaisNacimiento(solAltaClienteRequest.getPaisNacimiento());
			requestBean.setEstadoNacimiento(solAltaClienteRequest.getEstadoNacimiento());
			requestBean.setNacionalidad(solAltaClienteRequest.getNacionalidad());

			requestBean.setPaisResidencia(solAltaClienteRequest.getPaisResidencia());
			requestBean.setSexo(solAltaClienteRequest.getSexo());
			requestBean.setTelefono(solAltaClienteRequest.getTelefono());
			requestBean.setSectorGeneral(solAltaClienteRequest.getSectorGeneral());
			requestBean.setActividadBMX(solAltaClienteRequest.getActividadBMX());

			requestBean.setActividadFR(solAltaClienteRequest.getActividadFR());							
			requestBean.setPromotorInicial(solAltaClienteRequest.getPromotorInicial());
			requestBean.setPromotorActual(solAltaClienteRequest.getPromotorActual());
			requestBean.setNumero(solAltaClienteRequest.getNumero());
			requestBean.setTipoDireccion(solAltaClienteRequest.getTipoDireccion());

			requestBean.setEstado(solAltaClienteRequest.getEstado());
			requestBean.setMunicipio(solAltaClienteRequest.getMunicipio());
			requestBean.setCodigoPostal(solAltaClienteRequest.getCodigoPostal());
			requestBean.setLocalidad(solAltaClienteRequest.getLocalidad());
			requestBean.setColonia(solAltaClienteRequest.getColonia());

			requestBean.setCalle(solAltaClienteRequest.getCalle());
			requestBean.setNumeroDireccion(solAltaClienteRequest.getNumeroDireccion());
			requestBean.setOficial(solAltaClienteRequest.getOficial());
			requestBean.setNumIdentificacion(solAltaClienteRequest.getNumIdentificacion());
			requestBean.setTipoIdentificacion(solAltaClienteRequest.getTipoIdentificacion());

			requestBean.setEsOficial(solAltaClienteRequest.getEsOficial());
			requestBean.setFechaExpedicion(solAltaClienteRequest.getFechaExpedicion());
			requestBean.setFechaVencimiento(solAltaClienteRequest.getFechaVencimiento());
			requestBean.setPrimerNombreConyuge(solAltaClienteRequest.getPrimerNombreConyuge());
			requestBean.setSegundoNombreConyuge(solAltaClienteRequest.getSegundoNombreConyuge());

			requestBean.setTercerNombreConyuge(solAltaClienteRequest.getTercerNombreConyuge());
			requestBean.setApPaternoConyuge(solAltaClienteRequest.getApPaternoConyuge());
			requestBean.setApMaternoConyuge(solAltaClienteRequest.getApMaternoConyuge());
			requestBean.setNacionalidadConyuge(solAltaClienteRequest.getNacionalidadConyuge());
			requestBean.setPaisNacimientoConyuge(solAltaClienteRequest.getPaisNacimientoConyuge());

			requestBean.setEstadoNacConyuge(solAltaClienteRequest.getEstadoNacConyuge());
			requestBean.setFechaNacConyuge(solAltaClienteRequest.getFechaNacConyuge());
			requestBean.setRFCConyuge(solAltaClienteRequest.getRFCConyuge());
			requestBean.setTipoIdentiConyuge(solAltaClienteRequest.getTipoIdentiConyuge());
			requestBean.setFolioIdentiConyuge(solAltaClienteRequest.getFolioIdentiConyuge());

			requestBean.setFolio(solAltaClienteRequest.getFolio());
			requestBean.setClaveUsuario(solAltaClienteRequest.getClaveUsuario());
			requestBean.setDispositivo(solAltaClienteRequest.getDispositivo());
			
			if(parametrosCajaBean.getVersionWS().equals(varSana)){
				solAltaClienteResponse = (SolAltaClienteResponse) solAltaClienteServicio.solAltaCliente(requestBean);
			}else {
				solAltaClienteResponse.setCodigoRespuesta("997");
				throw new Exception("Error, La Transacción No puede Ser Aplicada, Verique Versión de WS.");
			}
				
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			
			if (!solAltaClienteResponse.getCodigoRespuesta().equals("997")) {
				solAltaClienteResponse.setCodigoRespuesta("998");
				solAltaClienteResponse.setMensajeRespuesta("Error, Transacción Rechazada.");
				solAltaClienteResponse.setClienteID(Constantes.STRING_CERO);
			}else{
				solAltaClienteResponse.setMensajeRespuesta("Error, La Transacción No puede Ser Aplicada, Verique Versión de WS.");
				solAltaClienteResponse.setClienteID(Constantes.STRING_CERO);
			}
		}
		return solAltaClienteResponse;
	}
	
	@Override
	protected Object invokeInternal(Object arg0) throws Exception {
		// TODO Auto-generated method stub
		SolAltaClienteRequest solAltaClienteRequest = (SolAltaClienteRequest)arg0;
		
		return solAltaCliente(solAltaClienteRequest);
	}

	public SolAltaClienteServicio getSolAltaClienteServicio() {
		return solAltaClienteServicio;
	}

	public void setSolAltaClienteServicio(
			SolAltaClienteServicio solAltaClienteServicio) {
		this.solAltaClienteServicio = solAltaClienteServicio;
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}
	
}
