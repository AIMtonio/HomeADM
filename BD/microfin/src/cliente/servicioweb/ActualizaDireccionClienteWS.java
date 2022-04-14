package cliente.servicioweb;

import general.bean.MensajeTransaccionBean;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import cliente.BeanWS.Request.ActualizaDireccionClienteRequest;
import cliente.BeanWS.Response.ActualizaDireccionClienteResponse;
import cliente.bean.DireccionesClienteBean;
import cliente.servicio.DireccionesClienteServicio;
import soporte.PropiedadesSAFIBean;
import soporte.servicio.UsuarioServicio;


public class ActualizaDireccionClienteWS extends AbstractMarshallingPayloadEndpoint{
	DireccionesClienteServicio direccionesclienteServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	
	public ActualizaDireccionClienteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private ActualizaDireccionClienteResponse actualizaDireccionCliente(ActualizaDireccionClienteRequest actualizaDireccionClienteRequest){
		DireccionesClienteBean direccionesclienteBean = new DireccionesClienteBean();
		ActualizaDireccionClienteResponse actualizaDireccionClienteResponse = new ActualizaDireccionClienteResponse();
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		direccionesclienteServicio.getDireccionesClienteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		direccionesclienteBean.setClienteID(actualizaDireccionClienteRequest.getClienteID());
		direccionesclienteBean.setDireccionID(actualizaDireccionClienteRequest.getDireccionID());
		direccionesclienteBean.setTipoDireccionID(actualizaDireccionClienteRequest.getTipoDireccionID());
		direccionesclienteBean.setEstadoID(actualizaDireccionClienteRequest.getEstadoID());
		direccionesclienteBean.setMunicipioID(actualizaDireccionClienteRequest.getMunicipioID());
		
		direccionesclienteBean.setLocalidadID(actualizaDireccionClienteRequest.getLocalidadID());
		direccionesclienteBean.setColoniaID(actualizaDireccionClienteRequest.getColoniaID());
		direccionesclienteBean.setNombreColonia(actualizaDireccionClienteRequest.getNombreColonia());
		direccionesclienteBean.setCalle(actualizaDireccionClienteRequest.getCalle());
		direccionesclienteBean.setNumeroCasa(actualizaDireccionClienteRequest.getNumeroCasa());
		direccionesclienteBean.setNumInterior(actualizaDireccionClienteRequest.getNumInterior());
		
		direccionesclienteBean.setPiso(actualizaDireccionClienteRequest.getPiso());
		direccionesclienteBean.setPrimEntreCalle(actualizaDireccionClienteRequest.getPrimEntreCalle());
		direccionesclienteBean.setSegEntreCalle(actualizaDireccionClienteRequest.getSegEntreCalle());
		direccionesclienteBean.setCP(actualizaDireccionClienteRequest.getCP());
		direccionesclienteBean.setLatitud(actualizaDireccionClienteRequest.getLatitud());
		
		direccionesclienteBean.setLongitud(actualizaDireccionClienteRequest.getLongitud());
		direccionesclienteBean.setLote(actualizaDireccionClienteRequest.getLote());
		direccionesclienteBean.setManzana(actualizaDireccionClienteRequest.getManzana());
		direccionesclienteBean.setOficial(actualizaDireccionClienteRequest.getOficial());
		direccionesclienteBean.setFiscal(actualizaDireccionClienteRequest.getFiscal());
		direccionesclienteBean.setDescripcion(actualizaDireccionClienteRequest.getDescripcion());
		
		
		mensaje = direccionesclienteServicio.grabaTransaccion(DireccionesClienteServicio.Enum_Tra_DireccionesCliente.modificacionWS, direccionesclienteBean);
		
		actualizaDireccionClienteResponse.setDireccionID(mensaje.getConsecutivoString());
		actualizaDireccionClienteResponse.setCodigoRespuesta(String.valueOf(mensaje.getNumero()));
		actualizaDireccionClienteResponse.setMensajeRespuesta(mensaje.getDescripcion());
		

	return actualizaDireccionClienteResponse;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		ActualizaDireccionClienteRequest actualizaDireccionClienteRequest = (ActualizaDireccionClienteRequest)arg0; 							
		return actualizaDireccionCliente(actualizaDireccionClienteRequest);
	}

	/* Declaracion de getter y setter */
	
	public DireccionesClienteServicio getDireccionesclienteServicio() {
		return direccionesclienteServicio;
	}

	public void setDireccionesclienteServicio(
			DireccionesClienteServicio direccionesclienteServicio) {
		this.direccionesclienteServicio = direccionesclienteServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}
	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	public String getUsuarioWS() {
		return usuarioWS;
	}

	public void setUsuarioWS(String usuarioWS) {
		this.usuarioWS = usuarioWS;
	}
	
}
