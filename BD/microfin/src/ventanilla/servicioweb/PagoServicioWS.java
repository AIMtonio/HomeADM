package ventanilla.servicioweb;


import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.servicio.IngresosOperacionesServicio;
import ventanilla.beanWS.response.PagoServicioResponse;
import ventanilla.beanWS.request.PagoServicioRequest;

public class PagoServicioWS extends AbstractMarshallingPayloadEndpoint{
	IngresosOperacionesServicio ingresosOperacionesServicio	=	null;
	UsuarioServicio usuarioServicio							=	null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws

	public PagoServicioWS (Marshaller marshaller) {
		super(marshaller);
	}
	
	private PagoServicioResponse pagoServicio(PagoServicioRequest pagoServicioRequest){
		String Var_OrigenDatos  = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);
		usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(Var_OrigenDatos);

		IngresosOperacionesBean	operacionesBean =	new IngresosOperacionesBean();
		PagoServicioResponse	response			   =	new PagoServicioResponse();
		MensajeTransaccionBean 	mensaje 			   = 	new MensajeTransaccionBean();
		
		operacionesBean.setCatalogoServID(pagoServicioRequest.getCatalogoServID());
		operacionesBean.setSucursalID(pagoServicioRequest.getSucursalID());
		operacionesBean.setReferenciaPago(pagoServicioRequest.getReferencia());
		operacionesBean.setReferenciaMov(pagoServicioRequest.getSegundaRefe());
		operacionesBean.setMonto(pagoServicioRequest.getMontoServicio());
		operacionesBean.setIVAMonto(pagoServicioRequest.getIvaServicio());
		operacionesBean.setComision(pagoServicioRequest.getComision());
		operacionesBean.setiVAComision(pagoServicioRequest.getIvaComision());
		operacionesBean.setTotalPagar(pagoServicioRequest.getTotal());
		operacionesBean.setClienteID(pagoServicioRequest.getClienteID());
		operacionesBean.setCuentaAhoID(pagoServicioRequest.getCuentasAhoID());
				
		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuario = new UsuarioBean();
		usuarioBean.setUsuarioID(usuarioWS);
		try{
			usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);			
			ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setNombrePrograma("principal.ws.pagoServicios");
			ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());			
			ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setEmpresaID(1);
			ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
			ingresosOperacionesServicio.getIngresosOperacionesDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));					
		}catch(Exception e){
			e.printStackTrace();
			response.setConsecutivo(mensaje.getConsecutivoString());
			response.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
			response.setMensajeRespuesta(mensaje.getDescripcion());
		}
		
		mensaje	= ingresosOperacionesServicio.pagoServicioWS(operacionesBean);
		
		response.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
		response.setMensajeRespuesta(mensaje.getDescripcion());
		response.setConsecutivo(mensaje.getConsecutivoInt());
		if(Integer.parseInt(response.getCodigoRespuesta())!=0){
			response.setConsecutivo(Constantes.STRING_CERO);
			response.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
			response.setMensajeRespuesta(mensaje.getDescripcion());
		}
		
		return response;
	}
	protected Object invokeInternal(Object arg0) throws Exception {
		PagoServicioRequest pagoServicioRequest = (PagoServicioRequest)arg0; 							
		return pagoServicio(pagoServicioRequest);
		
	}
	
	
	public IngresosOperacionesServicio getIngresosOperacionesServicio() {
		return ingresosOperacionesServicio;
	}
	public void setIngresosOperacionesServicio(
			IngresosOperacionesServicio ingresosOperacionesServicio) {
		this.ingresosOperacionesServicio = ingresosOperacionesServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}
}
