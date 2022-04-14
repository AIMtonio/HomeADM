package cuentas.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import cuentas.bean.CuentasAhoBean;
import cuentas.beanWS.request.AltaCuentaRequest;
import cuentas.beanWS.response.AltaCuentaResponse;
import cuentas.servicio.CuentasAhoServicio;

public class AltaCuentaWS extends AbstractMarshallingPayloadEndpoint {
	
	CuentasAhoServicio cuentasAhoServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");

	public AltaCuentaWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaCuentaResponse altaCuenta(AltaCuentaRequest altaCuentaRequest){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		CuentasAhoBean cuentasAhoBean = new CuentasAhoBean();
		AltaCuentaResponse altaCuentaResponse = new AltaCuentaResponse();
		
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		cuentasAhoBean.setSucursalID(altaCuentaRequest.getSucursalID());
		cuentasAhoBean.setClienteID(altaCuentaRequest.getClienteID());
		cuentasAhoBean.setClabe(altaCuentaRequest.getClabe());
		cuentasAhoBean.setMonedaID(altaCuentaRequest.getMonedaID());
		cuentasAhoBean.setTipoCuentaID(altaCuentaRequest.getTipoCuentaID());
		
		cuentasAhoBean.setFechaReg(altaCuentaRequest.getFechaReg());
		cuentasAhoBean.setEtiqueta(altaCuentaRequest.getEtiqueta());
		cuentasAhoBean.setEstadoCta(altaCuentaRequest.getEdoCta());
		cuentasAhoBean.setInstitucionID(altaCuentaRequest.getInstitucionID());
		cuentasAhoBean.setEsPrincipal(altaCuentaRequest.getEsPrincipal());

		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuario = new UsuarioBean();
		usuarioBean.setUsuarioID(usuarioWS);
		usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setNombrePrograma("invkubo.ws.altaCuenta");
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
		cuentasAhoServicio.getCuentasAhoDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
		
		mensaje = cuentasAhoServicio.grabaTransaccion(CuentasAhoServicio.Enum_Tra_CuentasAho.altaWS, Constantes.ENTERO_CERO, cuentasAhoBean);

		altaCuentaResponse.setCuentaAhoID(mensaje.getConsecutivoString());
		altaCuentaResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
		altaCuentaResponse.setMensajeRespuesta(mensaje.getDescripcion());
		
		return altaCuentaResponse;
	}

	public void setCuentasAhoServicio(CuentasAhoServicio cuentasAhoServicio) {
		this.cuentasAhoServicio = cuentasAhoServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		AltaCuentaRequest altaCuentaRequest = (AltaCuentaRequest)arg0; 			
		return altaCuenta(altaCuentaRequest);		
	}

}
