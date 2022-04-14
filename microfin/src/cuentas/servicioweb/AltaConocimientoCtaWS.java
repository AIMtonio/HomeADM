package cuentas.servicioweb;

import general.bean.MensajeTransaccionBean;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import cuentas.bean.ConocimientoCtaBean;
import cuentas.beanWS.request.AltaConocimientoCtaRequest;
import cuentas.beanWS.response.AltaConocimientoCtaResponse;
import cuentas.servicio.ConocimientoCtaServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class AltaConocimientoCtaWS extends AbstractMarshallingPayloadEndpoint {
	
	ConocimientoCtaServicio conocimientoCtaServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public AltaConocimientoCtaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaConocimientoCtaResponse altaConocimientoCta(AltaConocimientoCtaRequest altaConocimientoCtaRequest){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		ConocimientoCtaBean conocimientoCtaBean = new ConocimientoCtaBean();
		AltaConocimientoCtaResponse altaConocimientoCtaResponse = new AltaConocimientoCtaResponse();

		conocimientoCtaServicio.getConocimientoCtaDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		conocimientoCtaBean.setCuentaAhoID(altaConocimientoCtaRequest.getCuentaAhoID());
		conocimientoCtaBean.setDepositoCred(altaConocimientoCtaRequest.getDepositoCred());
		conocimientoCtaBean.setRetirosCargo(altaConocimientoCtaRequest.getRetirosCargo());
		conocimientoCtaBean.setProcRecursos(altaConocimientoCtaRequest.getProcRecursos());
		conocimientoCtaBean.setConcentFondo(altaConocimientoCtaRequest.getConcentFondo());
		
		conocimientoCtaBean.setAdmonGtosIng(altaConocimientoCtaRequest.getAdmonGtosIng());
		conocimientoCtaBean.setPagoNomina(altaConocimientoCtaRequest.getPagoNomina());
		conocimientoCtaBean.setCtaInversion(altaConocimientoCtaRequest.getCtaInversion());
		conocimientoCtaBean.setPagoCreditos(altaConocimientoCtaRequest.getPagoCreditos());
		conocimientoCtaBean.setOtroUso(altaConocimientoCtaRequest.getOtroUso());

		conocimientoCtaBean.setDefineUso(altaConocimientoCtaRequest.getDefineUso());
		conocimientoCtaBean.setRecursoProv(altaConocimientoCtaRequest.getRecursoProv());
		
		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuario = new UsuarioBean();
		usuarioBean.setUsuarioID(usuarioWS);
		usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
		conocimientoCtaServicio.getConocimientoCtaDAO().getParametrosAuditoriaBean().setNombrePrograma("cuentas.ws.altaConocimientoCta");
		conocimientoCtaServicio.getConocimientoCtaDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
		conocimientoCtaServicio.getConocimientoCtaDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
		conocimientoCtaServicio.getConocimientoCtaDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
		conocimientoCtaServicio.getConocimientoCtaDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
		
		mensaje = conocimientoCtaServicio.grabaTransaccion(ConocimientoCtaServicio.Enum_Tra_ConocimientoCta.altaWS, conocimientoCtaBean);

		altaConocimientoCtaResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
		altaConocimientoCtaResponse.setMensajeRespuesta(mensaje.getDescripcion());
		
		return altaConocimientoCtaResponse;
	}

	public void setConocimientoCtaServicio(
			ConocimientoCtaServicio conocimientoCtaServicio) {
		this.conocimientoCtaServicio = conocimientoCtaServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		AltaConocimientoCtaRequest altaConocimientoCtaRequest = (AltaConocimientoCtaRequest)arg0; 			
		return altaConocimientoCta(altaConocimientoCtaRequest);		
	}

}
