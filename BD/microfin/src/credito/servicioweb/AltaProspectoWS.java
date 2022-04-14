package credito.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import herramientas.Utileria;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import credito.bean.ProspectosBean;
import credito.beanWS.request.AltaProspectoRequest;
import credito.beanWS.response.AltaProspectoResponse;
import credito.servicio.ProspectosServicio;


public class AltaProspectoWS extends AbstractMarshallingPayloadEndpoint {
	ProspectosServicio prospectosServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String personaMoral = "M";
	
	public AltaProspectoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaProspectoResponse altaProspecto(AltaProspectoRequest prospectoRequest){
		ProspectosBean prospectosBean = new ProspectosBean();
		AltaProspectoResponse prospectoResponse = new AltaProspectoResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");		
		prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		prospectosBean.setProspectoIDExt(prospectoRequest.getProspectoIDExt());
		prospectosBean.setPrimerNombre(prospectoRequest.getPrimerNombre());
		prospectosBean.setSegundoNombre(prospectoRequest.getSegundoNombre());
		prospectosBean.setTercerNombre(prospectoRequest.getTercerNombre());
		prospectosBean.setApellidoPaterno(prospectoRequest.getApellidoPaterno());
		
		prospectosBean.setApellidoMaterno(prospectoRequest.getApellidoMaterno());
		prospectosBean.setTelefono(prospectoRequest.getTelefono());
		prospectosBean.setCalle(prospectoRequest.getCalle());
		prospectosBean.setNumExterior(prospectoRequest.getNumExterior());
		prospectosBean.setNumInterior(prospectoRequest.getNumInterior());

		prospectosBean.setManzana(prospectoRequest.getManzana());
		prospectosBean.setLote(prospectoRequest.getLote());
		prospectosBean.setColonia(prospectoRequest.getColonia());
		prospectosBean.setMunicipioID(prospectoRequest.getMunicipioID());
		prospectosBean.setEstadoID(prospectoRequest.getEstadoID());
		
		prospectosBean.setCP(prospectoRequest.getCP());
		prospectosBean.setTipoPersona(prospectoRequest.getTipoPersona());
		prospectosBean.setRazonSocial(prospectoRequest.getRazonSocial());
		prospectosBean.setRFC(prospectoRequest.getRFC());
		prospectosBean.setLatitud(prospectoRequest.getLatitud());
		prospectosBean.setLongitud(prospectoRequest.getLongitud());

		if(prospectosBean.getCP().length()== 5){
			if(prospectosBean.getTipoPersona().equals(personaMoral)){
				if(prospectosBean.getRFC().length()== 12){
					UsuarioBean usuarioBean = new UsuarioBean();
					UsuarioBean usuario = new UsuarioBean();
					usuarioBean.setUsuarioID(usuarioWS);
					try{
						usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.altaProspecto");
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
					}catch (Exception e){
						e.printStackTrace();
						prospectoResponse.setProspectoID( mensaje.getConsecutivoString());
						prospectoResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
						prospectoResponse.setMensajeRespuesta(e.toString());
					}
					
					mensaje = prospectosServicio.grabaTransaccion(ProspectosServicio.Enum_Tra_Prospecto.altaWS,
							prospectosBean);
					
					prospectoResponse.setProspectoID( mensaje.getConsecutivoString());
					prospectoResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
					prospectoResponse.setMensajeRespuesta(mensaje.getDescripcion());
					
					if(Integer.parseInt(prospectoResponse.getCodigoRespuesta()) != 0){
						prospectoResponse.setProspectoID(Constantes.STRING_CERO);
						prospectoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
						prospectoResponse.setMensajeRespuesta(mensaje.getDescripcion());
					}					
				}else{
					prospectoResponse.setProspectoID(Constantes.STRING_CERO);
					prospectoResponse.setCodigoRespuesta("17");
					prospectoResponse.setMensajeRespuesta("El RFC debe ser de 12 caracteres");
				}
			}
			else{
				if(prospectosBean.getRFC().length() > 0){
					if(prospectosBean.getRFC().length()== 13){
						UsuarioBean usuarioBean = new UsuarioBean();
						UsuarioBean usuario = new UsuarioBean();
						usuarioBean.setUsuarioID(usuarioWS);
						try{
							usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
							prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.altaProspecto");
							prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
							prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
							prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
							prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
						}catch (Exception e){
							e.printStackTrace();
							prospectoResponse.setProspectoID( mensaje.getConsecutivoString());
							prospectoResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
							prospectoResponse.setMensajeRespuesta(e.toString());
						}
						
						mensaje = prospectosServicio.grabaTransaccion(ProspectosServicio.Enum_Tra_Prospecto.altaWS,
								prospectosBean);
						
						prospectoResponse.setProspectoID( mensaje.getConsecutivoString());
						prospectoResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
						prospectoResponse.setMensajeRespuesta(mensaje.getDescripcion());
						
						if(Integer.parseInt(prospectoResponse.getCodigoRespuesta()) != 0){
							prospectoResponse.setProspectoID(Constantes.STRING_CERO);
							prospectoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
							prospectoResponse.setMensajeRespuesta(mensaje.getDescripcion());
						}					
					}
					else{
						prospectoResponse.setProspectoID(Constantes.STRING_CERO);
						prospectoResponse.setCodigoRespuesta("18");
						prospectoResponse.setMensajeRespuesta("El RFC debe ser de 13 caracteres");
					}
				}else{
					UsuarioBean usuarioBean = new UsuarioBean();
					UsuarioBean usuario = new UsuarioBean();
					usuarioBean.setUsuarioID(usuarioWS);
					try{
						usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.altaProspecto");
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
						prospectosServicio.getProspectosDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
					}catch (Exception e){
						e.printStackTrace();
						prospectoResponse.setProspectoID( mensaje.getConsecutivoString());
						prospectoResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
						prospectoResponse.setMensajeRespuesta(e.toString());
					}
					
					mensaje = prospectosServicio.grabaTransaccion(ProspectosServicio.Enum_Tra_Prospecto.altaWS,
							prospectosBean);
					
					prospectoResponse.setProspectoID( mensaje.getConsecutivoString());
					prospectoResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
					prospectoResponse.setMensajeRespuesta(mensaje.getDescripcion());
					
					if(Integer.parseInt(prospectoResponse.getCodigoRespuesta()) != 0){
						prospectoResponse.setProspectoID(Constantes.STRING_CERO);
						prospectoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
						prospectoResponse.setMensajeRespuesta(mensaje.getDescripcion());
					}					
				}
			}
			
		}else{
			prospectoResponse.setProspectoID(Constantes.STRING_CERO);
			prospectoResponse.setCodigoRespuesta("16");
			prospectoResponse.setMensajeRespuesta("El Codigo Postal debe ser de 5 caracteres");
			
		}
		
		
		
		return prospectoResponse;
	}
	
	public void setProspectosServicio(ProspectosServicio prospectosServicio) {
		this.prospectosServicio = prospectosServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		AltaProspectoRequest altaProspectoRequest = (AltaProspectoRequest)arg0; 							
		return altaProspecto(altaProspectoRequest);
		
	}
	

}