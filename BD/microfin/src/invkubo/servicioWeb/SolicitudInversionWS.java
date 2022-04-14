package invkubo.servicioWeb;

import general.bean.MensajeTransaccionBean;
import invkubo.bean.FondeoSolicitudBean;
import invkubo.beanws.request.SolicitudInversionRequest;
import invkubo.beanws.response.SolicitudInversionResponse;
import invkubo.servicio.FondeoSolicitudServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;


public class SolicitudInversionWS extends AbstractMarshallingPayloadEndpoint {
	
	FondeoSolicitudServicio fondeoSolicitudServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public SolicitudInversionWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private SolicitudInversionResponse altaSolicitudInversion(SolicitudInversionRequest solicitudInversionRequest){
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		FondeoSolicitudBean fondeoSolicitudBean = new FondeoSolicitudBean();
		SolicitudInversionResponse solicitudInversionResponse = new SolicitudInversionResponse();
		fondeoSolicitudBean.setSolicitudCreditoID(solicitudInversionRequest.getSolicitudCreditoID());
		fondeoSolicitudBean.setClienteID(solicitudInversionRequest.getClienteID());
		fondeoSolicitudBean.setCuentaID(solicitudInversionRequest.getCuentaAhoID());
		fondeoSolicitudBean.setMontoFondeo(solicitudInversionRequest.getMontoFondeo());
		fondeoSolicitudBean.setTasaPasiva(solicitudInversionRequest.getTasaPasiva());
		
		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuario = new UsuarioBean();
		usuarioBean.setUsuarioID(usuarioWS);
		usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.altaSolicitudInversion");
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
		
		mensaje = fondeoSolicitudServicio.grabaTransaccion(FondeoSolicitudServicio.Enum_Tra_FondeoSolicitud.proceso, fondeoSolicitudBean);

		solicitudInversionResponse.setPorcentajeFondeo(mensaje.getConsecutivoString());
		solicitudInversionResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
		solicitudInversionResponse.setMensajeRespuesta(mensaje.getDescripcion());
		
		return solicitudInversionResponse;
	}

	public void setFondeoSolicitudServicio(
			FondeoSolicitudServicio fondeoSolicitudServicio) {
		this.fondeoSolicitudServicio = fondeoSolicitudServicio;
	}
	
	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		SolicitudInversionRequest solicitudInversionRequest = (SolicitudInversionRequest)arg0; 			
		return altaSolicitudInversion(solicitudInversionRequest);		
	}

}