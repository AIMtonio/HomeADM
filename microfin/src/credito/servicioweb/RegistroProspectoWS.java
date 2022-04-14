package credito.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import credito.bean.ProspectosBean;
import credito.beanWS.request.RegistroProspectoRequest;
import credito.beanWS.response.RegistroProspectoResponse;
import credito.servicio.ProspectosServicio;

public class RegistroProspectoWS extends AbstractMarshallingPayloadEndpoint {
	ProspectosServicio prospectosServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	//String personaMoral = "M";
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public RegistroProspectoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private RegistroProspectoResponse registroProspecto(RegistroProspectoRequest registroProspectoRequest){
		ProspectosBean prospectosBean = new ProspectosBean();
		RegistroProspectoResponse registroProspectoResponse = new RegistroProspectoResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		prospectosBean.setProspectoID(registroProspectoRequest.getProspectoID());
		prospectosBean.setPrimerNombre(registroProspectoRequest.getPrimerNombre());
		prospectosBean.setSegundoNombre(registroProspectoRequest.getSegundoNombre());
		prospectosBean.setTercerNombre(registroProspectoRequest.getTercerNombre());
		prospectosBean.setApellidoPaterno(registroProspectoRequest.getApellidoPaterno());
		
		prospectosBean.setApellidoMaterno(registroProspectoRequest.getApellidoMaterno());
		prospectosBean.setTipoPersona(registroProspectoRequest.getTipoPersona());
		prospectosBean.setFechaNacimiento(registroProspectoRequest.getFechaNacimiento());
		prospectosBean.setRFC(registroProspectoRequest.getRFC());
		prospectosBean.setSexo(registroProspectoRequest.getSexo());
		
		prospectosBean.setEstadoCivil(registroProspectoRequest.getEstadoCivil());
		prospectosBean.setTelefono(registroProspectoRequest.getTelefono());
		prospectosBean.setRazonSocial(registroProspectoRequest.getRazonSocial());
		prospectosBean.setEstadoID(registroProspectoRequest.getEstadoID());
		prospectosBean.setMunicipioID(registroProspectoRequest.getMunicipioID());
		
		prospectosBean.setLocalidadID(registroProspectoRequest.getLocalidadID());
		prospectosBean.setColoniaID(registroProspectoRequest.getColoniaID());
		prospectosBean.setCalle(registroProspectoRequest.getCalle());
		prospectosBean.setNumExterior(registroProspectoRequest.getNumExterior());
		prospectosBean.setNumInterior(registroProspectoRequest.getNumInterior());
		
		prospectosBean.setCP(registroProspectoRequest.getCP());
		prospectosBean.setManzana(registroProspectoRequest.getManzana());
		prospectosBean.setLote(registroProspectoRequest.getLote());
		prospectosBean.setLatitud(registroProspectoRequest.getLatitud());
		prospectosBean.setLongitud(registroProspectoRequest.getLongitud());
		
		prospectosBean.setTipoDireccionID(registroProspectoRequest.getTipoDireccionID());
		prospectosBean.setInstitucionNominaID(registroProspectoRequest.getInstitucionNominaID());
		prospectosBean.setNegocioAfiliadoID(registroProspectoRequest.getNegocioAfiliadoID());

		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuario = new UsuarioBean();
		usuarioBean.setUsuarioID(usuarioWS);
		usuario= usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setNombrePrograma("principal.ws.registroProspecto");
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
	
			if(Integer.valueOf(prospectosBean.getProspectoID()) <= 0 || prospectosBean.getProspectoID().equals(Constantes.STRING_VACIO)){
				mensaje = prospectosServicio.grabaTransaccionWS(ProspectosServicio.Enum_Tra_ProspectoWS.altaWS,prospectosBean);
				}else{
				mensaje = prospectosServicio.grabaTransaccionWS(ProspectosServicio.Enum_Tra_ProspectoWS.modificacionWS,prospectosBean);
			}
			
			registroProspectoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
			registroProspectoResponse.setMensajeRespuesta(mensaje.getDescripcion());
			
			
		return registroProspectoResponse;
	}
	
	public void setProspectosServicio(ProspectosServicio prospectosServicio) {
		this.prospectosServicio = prospectosServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		RegistroProspectoRequest registroProspectoRequest = (RegistroProspectoRequest)arg0; 							
		return registroProspecto(registroProspectoRequest);
		
	}
	

}
