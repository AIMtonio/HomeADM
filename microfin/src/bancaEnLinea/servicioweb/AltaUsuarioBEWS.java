package bancaEnLinea.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import bancaEnLinea.bean.BEUsuariosBean;
import bancaEnLinea.beanWS.request.AltaUsuarioBERequest;
import bancaEnLinea.beanWS.response.AltaUsuarioBEResponse;
import bancaEnLinea.servicio.BEUsuariosServicio;

public class AltaUsuarioBEWS extends AbstractMarshallingPayloadEndpoint {
	BEUsuariosServicio bEUsuariosServicio =  null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public AltaUsuarioBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaUsuarioBEResponse altaUsuarioBE( AltaUsuarioBERequest altaUsuarioBERequest){
		int tipoTransaccion;
		BEUsuariosBean bEUsuariosBean = new BEUsuariosBean();
		AltaUsuarioBEResponse altaUsuarioBEResponse = new AltaUsuarioBEResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		try{
			bEUsuariosBean.setClave(altaUsuarioBERequest.getClave());
			bEUsuariosBean.setPerfil(altaUsuarioBERequest.getPerfil());
			bEUsuariosBean.setiDClienteNomina(altaUsuarioBERequest.getClienteNominaID());
			bEUsuariosBean.setNegocioAfiliadoID(altaUsuarioBERequest.getNegocioAfiliadoID());
			bEUsuariosBean.setClienteID(altaUsuarioBERequest.getClienteID());
			bEUsuariosBean.setCostoMensual(altaUsuarioBERequest.getCostoMensual());
			
			tipoTransaccion= Integer.parseInt(altaUsuarioBERequest.getTipoTransaccion());
		
			UsuarioBean usuarioBean = new UsuarioBean();
			UsuarioBean usuario = new UsuarioBean();
			usuarioBean.setUsuarioID(usuarioWS);

			usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
			bEUsuariosServicio.getbEUsuariosDAO().getParametrosAuditoriaBean().setNombrePrograma("principal.ws.altaBEUsuarios");
			bEUsuariosServicio.getbEUsuariosDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
			bEUsuariosServicio.getbEUsuariosDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
			bEUsuariosServicio.getbEUsuariosDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
			bEUsuariosServicio.getbEUsuariosDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
			
			mensaje = bEUsuariosServicio.grabaTransaccion(tipoTransaccion, bEUsuariosBean);
			
			altaUsuarioBEResponse.setClave(mensaje.getConsecutivoInt());
			altaUsuarioBEResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
			altaUsuarioBEResponse.setMensajeRespuesta(mensaje.getDescripcion());

		}catch(Exception e){
			e.printStackTrace();
			altaUsuarioBEResponse.setClave(Constantes.STRING_CERO);
			altaUsuarioBEResponse.setCodigoRespuesta("999");
			altaUsuarioBEResponse.setMensajeRespuesta("Error al Guardar el Usuario: "+ e);
		}
		
		return altaUsuarioBEResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		AltaUsuarioBERequest altaUsuarioBERequest = (AltaUsuarioBERequest)arg0; 
	
		return altaUsuarioBE( altaUsuarioBERequest);
		
	}

	/* declaracion de getter y setter */
	public BEUsuariosServicio getbEUsuariosServicio() {
		return bEUsuariosServicio;
	}

	public void setbEUsuariosServicio(BEUsuariosServicio bEUsuariosServicio) {
		this.bEUsuariosServicio = bEUsuariosServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	
}
