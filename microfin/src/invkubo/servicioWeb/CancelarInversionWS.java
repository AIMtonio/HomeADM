package invkubo.servicioWeb;

import general.bean.MensajeTransaccionBean;
import invkubo.bean.FondeoSolicitudBean;
import invkubo.beanws.request.CancelarInversionRequest;
import invkubo.beanws.response.CancelarInversionResponse;
import invkubo.servicio.FondeoSolicitudServicio;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class CancelarInversionWS extends AbstractMarshallingPayloadEndpoint {
	FondeoSolicitudServicio fondeoSolicitudServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public CancelarInversionWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private CancelarInversionResponse cancelarInversion(CancelarInversionRequest cancelarInversionRequest){
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		FondeoSolicitudBean fondeoSolicitudBean = new FondeoSolicitudBean();
		CancelarInversionResponse cancelarInversionResponse = new CancelarInversionResponse();

		fondeoSolicitudBean.setSolicitudCreditoID(cancelarInversionRequest.getSolicitudCreditoID());
		fondeoSolicitudBean.setClienteID(cancelarInversionRequest.getClienteID());
		fondeoSolicitudBean.setCuentaID(cancelarInversionRequest.getCuentaAhoID());
		fondeoSolicitudBean.setMontoFondeo(cancelarInversionRequest.getMontoFondeo());
		
		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuario = new UsuarioBean();
		usuarioBean.setUsuarioID(usuarioWS);
		usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.CancelarInversion");
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
		
		fondeoSolicitudServicio.getFondeoSolicitudDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.cancelarInversion");
		
		mensaje = fondeoSolicitudServicio.grabaTransaccion(FondeoSolicitudServicio.Enum_Tra_FondeoSolicitud.cancelar, fondeoSolicitudBean);

		cancelarInversionResponse.setPorcentajeFondeo(mensaje.getConsecutivoString());
		cancelarInversionResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
		cancelarInversionResponse.setMensajeRespuesta(mensaje.getDescripcion());
		cancelarInversionResponse.setMontoFaltaFondeo(mensaje.getNombreControl());
		
		return cancelarInversionResponse;
	}

	public void setFondeoSolicitudServicio(
			FondeoSolicitudServicio fondeoSolicitudServicio) {
		this.fondeoSolicitudServicio = fondeoSolicitudServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		CancelarInversionRequest cancelarInversionRequest = (CancelarInversionRequest)arg0; 			
		return cancelarInversion(cancelarInversionRequest);		
	}

}