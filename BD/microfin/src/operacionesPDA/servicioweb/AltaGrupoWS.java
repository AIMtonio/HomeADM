package operacionesPDA.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;
import operacionesPDA.beanWS.request.AltaGrupoRequest;
import operacionesPDA.beanWS.response.AltaGrupoResponse;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.ParametrosCajaBean;
import soporte.bean.ParametrosSisBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.ParametrosCajaServicio;
import soporte.servicio.ParametrosSisServicio;
import soporte.servicio.UsuarioServicio;
import soporte.servicio.UsuarioServicio.Enum_Con_Usuario;
import credito.bean.GruposCreditoBean;
import credito.servicio.GruposCreditoServicio;

public class AltaGrupoWS extends AbstractMarshallingPayloadEndpoint{
	ParametrosCajaServicio parametrosCajaServicio = null;
	GruposCreditoServicio gruposCreditoServicio = null;
	UsuarioServicio usuarioServicio = null;
	ParametrosSisServicio parametrosSisServicio = null;
	
	
	public String varSana = "SANA";
	public String cicloActual = "1";
	public String estatusAbierto = "A";
	
	public AltaGrupoWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaGrupoResponse altaGrupoResponse(AltaGrupoRequest altaGrupoRequest){
		AltaGrupoResponse altaGrupoResponse = new AltaGrupoResponse();
		
		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuarioBeans = new UsuarioBean();
		UsuarioBean usuarioBeanWS = new UsuarioBean();
		GruposCreditoBean gruposCredito = new GruposCreditoBean();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		ParametrosCajaBean parametrosCajaBean = new ParametrosCajaBean();
		parametrosCajaBean.setEmpresaID("1");
		parametrosCajaBean = parametrosCajaServicio.consulta(ParametrosCajaServicio.Enum_Con_ParametrosCaja.paramVersionWS, parametrosCajaBean);
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenesDatosPDA");
		gruposCreditoServicio.getGruposCreditoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		try {
			if (altaGrupoRequest.getNombreGrupo().isEmpty()) {
				altaGrupoResponse.setCodigoRespuesta("01");
				altaGrupoResponse.setMensajeRespuesta("El nombre del Grupo esta Vacío.");
				throw new Exception("El nombre del Grupo esta vacío.");
			}
			
			if (altaGrupoRequest.getDispositivo().isEmpty()) {
				altaGrupoResponse.setCodigoRespuesta("03");
				altaGrupoResponse.setMensajeRespuesta("El Campo Dispositivo Esta Vacío.");
				throw new Exception("El Campo Dispositivo Esta Vacío.");
			}
			
			if (altaGrupoRequest.getClaveUsuario().isEmpty()) {
				altaGrupoResponse.setCodigoRespuesta("08");
				altaGrupoResponse.setMensajeRespuesta("La Clave del Usuario Esta Vacía.");
				throw new Exception("La Clave del Usuario Esta Vacía.");
			}
			
			if (altaGrupoRequest.getFolio().isEmpty()) {
				altaGrupoResponse.setCodigoRespuesta("09");
				altaGrupoResponse.setMensajeRespuesta("El Folio Esta Vacío.");
				throw new Exception("La Folio Esta Vacío.");
			}
			
			usuarioBean.setClave(altaGrupoRequest.getClaveUsuario());
			usuarioBean = usuarioServicio.consulta(Enum_Con_Usuario.clave, usuarioBean);
			
			if (usuarioBean != null) {
				
				usuarioBeans.setUsuarioID(usuarioBean.getUsuarioID());
				usuarioBeans = usuarioServicio.consulta(Enum_Con_Usuario.consultaWS, usuarioBeans);
				
				gruposCredito.setNombreGrupo(altaGrupoRequest.getNombreGrupo().toUpperCase());
				gruposCredito.setSucursalID(usuarioBeans.getSucursalUsuario());	//-- DEPENDE DE LA NARRATIVA °° Obtener de usuarioBean
				gruposCredito.setCicloActual(cicloActual);
				gruposCredito.setEstatusCiclo(estatusAbierto);
				gruposCredito.setFechaUltCiclo(usuarioBeans.getFechaSistema());		// -- CORROBORAR CON DATOS DE STORE
				
				gruposCreditoServicio.getGruposCreditoDAO().getParametrosAuditoriaBean().setNombrePrograma(altaGrupoRequest.getFolio().toUpperCase() + "-" + altaGrupoRequest.getDispositivo().toUpperCase());
				gruposCreditoServicio.getGruposCreditoDAO().getParametrosAuditoriaBean().setDireccionIP("127.0.0.1");
				gruposCreditoServicio.getGruposCreditoDAO().getParametrosAuditoriaBean().setEmpresaID(1);
				gruposCreditoServicio.getGruposCreditoDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuarioBeans.getSucursalUsuario()));	//-- DEPENDE DE LA NARRATIVA
				gruposCreditoServicio.getGruposCreditoDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioBean.getUsuarioID()));
				
				usuarioBeanWS.setClave(altaGrupoRequest.getClaveUsuario());
				usuarioBeanWS.setContrasenia(usuarioBean.getContrasenia());
				usuarioBeanWS.setSucursalUsuario(usuarioBeans.getSucursalUsuario());
				
				usuarioBeanWS = usuarioServicio.consulta(Enum_Con_Usuario.pdaValidaUserWS, usuarioBeanWS);
				
				if (usuarioBeanWS.getEsValido().equals("true")) {
				
					if(parametrosCajaBean.getVersionWS().equals(varSana)){
						mensaje = gruposCreditoServicio.alta(gruposCredito);
						
						altaGrupoResponse.setMensajeRespuesta(mensaje.getDescripcion());
						
						if (mensaje.getNumero() == 0) {
							altaGrupoResponse.setGrupoID(mensaje.getConsecutivoString());
							altaGrupoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
						} else {
							altaGrupoResponse.setGrupoID(Constantes.STRING_CERO);
							altaGrupoResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()/* + 10*/));
						}
						
					} else {
						altaGrupoResponse.setCodigoRespuesta("998");
						altaGrupoResponse.setMensajeRespuesta("Error: La Transacción No puede Ser Aplicada. Verifique la Versión de WS.");
						altaGrupoResponse.setGrupoID(Constantes.STRING_CERO);
					}
				} else {
					altaGrupoResponse.setCodigoRespuesta("07");
					altaGrupoResponse.setMensajeRespuesta("El Rol del Usuario no es el indicado para la operación.");
					altaGrupoResponse.setGrupoID(Constantes.STRING_CERO);
					throw new Exception("El Rol del Usuario no es el indicado para la operación.");
				}

			} else {
				// Error con la clave de Usuario
				altaGrupoResponse.setCodigoRespuesta("06");
				altaGrupoResponse.setMensajeRespuesta("La Clave Usuario no existe.");
				altaGrupoResponse.setGrupoID(Constantes.STRING_CERO);
			}
			
		} catch (Exception e) {
			if (Integer.parseInt(altaGrupoResponse.getCodigoRespuesta()) == 1 
					|| Integer.parseInt(altaGrupoResponse.getCodigoRespuesta()) == 3
					|| Integer.parseInt(altaGrupoResponse.getCodigoRespuesta()) == 7
					|| Integer.parseInt(altaGrupoResponse.getCodigoRespuesta()) == 8
					|| Integer.parseInt(altaGrupoResponse.getCodigoRespuesta()) == 9) {
				//Mensajes ya definidos
				altaGrupoResponse.setGrupoID(Constantes.STRING_CERO);
			}else {
				altaGrupoResponse.setCodigoRespuesta("999");
				altaGrupoResponse.setMensajeRespuesta("Error: " + e.getMessage());
				altaGrupoResponse.setGrupoID(Constantes.STRING_CERO);
			}
			
		}
		return altaGrupoResponse;
	}
	
	protected Object invokeInternal(Object arg0) throws Exception {
		// TODO Auto-generated method stub
		AltaGrupoRequest altaGrupoRequest = (AltaGrupoRequest)arg0;
		return altaGrupoResponse(altaGrupoRequest);
	}

	public ParametrosCajaServicio getParametrosCajaServicio() {
		return parametrosCajaServicio;
	}

	public void setParametrosCajaServicio(
			ParametrosCajaServicio parametrosCajaServicio) {
		this.parametrosCajaServicio = parametrosCajaServicio;
	}

	public GruposCreditoServicio getGruposCreditoServicio() {
		return gruposCreditoServicio;
	}

	public void setGruposCreditoServicio(GruposCreditoServicio gruposCreditoServicio) {
		this.gruposCreditoServicio = gruposCreditoServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
	
}