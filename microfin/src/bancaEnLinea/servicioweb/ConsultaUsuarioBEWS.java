package bancaEnLinea.servicioweb;

import general.bean.MensajeTransaccionBean;
import herramientas.Constantes;

import org.exolab.castor.xml.handlers.ValueOfFieldHandler;
import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import soporte.PropiedadesSAFIBean;
import soporte.servicio.UsuarioServicio;
import bancaEnLinea.bean.BEUsuariosBean;
import bancaEnLinea.beanWS.request.ConsultaUsuarioBERequest;
import bancaEnLinea.beanWS.response.ConsultaUsuarioBEResponse;
import bancaEnLinea.servicio.BEUsuariosServicio;
import bancaEnLinea.servicio.BEUsuariosServicio.Enum_Con_BEUsuarios;

public class ConsultaUsuarioBEWS extends AbstractMarshallingPayloadEndpoint  {
	BEUsuariosServicio bEUsuariosServicio =  null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
	
	public ConsultaUsuarioBEWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}

	private ConsultaUsuarioBEResponse consultaUsuarioBE(ConsultaUsuarioBERequest consultaUsuarioBERequest){
		ConsultaUsuarioBEResponse consultaUsuarioBEResponse = new ConsultaUsuarioBEResponse();
		BEUsuariosBean bEUsuariosBean = new BEUsuariosBean();
		usuarioServicio.getUsuarioDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		bEUsuariosBean.setClienteID(consultaUsuarioBERequest.getClienteID());
		
		bEUsuariosBean = bEUsuariosServicio.consulta(Enum_Con_BEUsuarios.consultaCliente, bEUsuariosBean);
		
		if(bEUsuariosBean!=null){
			consultaUsuarioBEResponse.setCodigoRespuesta(bEUsuariosBean.getNumErr());
			consultaUsuarioBEResponse.setMensajeRespuesta(bEUsuariosBean.getErrMen());
			consultaUsuarioBEResponse.setClienteID(bEUsuariosBean.getClienteID());
			consultaUsuarioBEResponse.setUsuarioBE(bEUsuariosBean.getClave());
			consultaUsuarioBEResponse.setRFC(bEUsuariosBean.getRFCOficial());
			consultaUsuarioBEResponse.setNombreCompleto(bEUsuariosBean.getNombreCompleto());
		}
		else{
			consultaUsuarioBEResponse.setCodigoRespuesta("03");
			consultaUsuarioBEResponse.setMensajeRespuesta("El Numero de Cliente no Existe");
			consultaUsuarioBEResponse.setClienteID(Constantes.STRING_VACIO);
			consultaUsuarioBEResponse.setUsuarioBE(Constantes.STRING_VACIO);
			consultaUsuarioBEResponse.setRFC(Constantes.STRING_VACIO);
			consultaUsuarioBEResponse.setNombreCompleto(Constantes.STRING_VACIO);
		}
		
		
		return consultaUsuarioBEResponse;
	}
	
	
	
	protected Object invokeInternal(Object arg0) throws Exception {
		ConsultaUsuarioBERequest consultaUsuarioBERequest = (ConsultaUsuarioBERequest)arg0; 							
		return consultaUsuarioBE(consultaUsuarioBERequest);
		
	}

	public BEUsuariosServicio getbEUsuariosServicio() {
		return bEUsuariosServicio;
	}

	public UsuarioServicio getUsuarioServicio() {
		return usuarioServicio;
	}

	public void setbEUsuariosServicio(BEUsuariosServicio bEUsuariosServicio) {
		this.bEUsuariosServicio = bEUsuariosServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

}
