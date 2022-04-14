package cliente.servicioweb;

import general.bean.MensajeTransaccionBean;

import org.springframework.oxm.Marshaller;
import org.springframework.ws.server.endpoint.AbstractMarshallingPayloadEndpoint;

import cliente.BeanWS.Request.AltaConocimientoCteRequest;
import cliente.BeanWS.Response.AltaConocimientoCteResponse;
import cliente.bean.ConocimientoCteBean;
import cliente.servicio.ConocimientoCteServicio;
import soporte.PropiedadesSAFIBean;
import soporte.bean.UsuarioBean;
import soporte.servicio.UsuarioServicio;

public class AltaConocimientoCteWS  extends AbstractMarshallingPayloadEndpoint {
	
	ConocimientoCteServicio conocimientoCteServicio = null;
	UsuarioServicio usuarioServicio=  null;
	String usuarioWS = "16"; // para obtener datos de auditoria del usuario de ws
	

	public AltaConocimientoCteWS(Marshaller marshaller) {
		super(marshaller);
		// TODO Auto-generated constructor stub
	}
	
	private AltaConocimientoCteResponse altaConocimientoCte(AltaConocimientoCteRequest altaConocimientoCteRequest){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		ConocimientoCteBean conocimientoCteBean = new ConocimientoCteBean();
		AltaConocimientoCteResponse altaConocimientoCteResponse = new AltaConocimientoCteResponse();

		String origenDatosWS = PropiedadesSAFIBean.propiedadesSAFI.getProperty("OrigenDatosWS");
		conocimientoCteServicio.getConocimientoCteDAO().getParametrosAuditoriaBean().setOrigenDatos(origenDatosWS);
		
		conocimientoCteBean.setClienteID(altaConocimientoCteRequest.getClienteID());
		conocimientoCteBean.setNomGrupo(altaConocimientoCteRequest.getNomGrupo());
		conocimientoCteBean.setRFC(altaConocimientoCteRequest.getRFC());
		conocimientoCteBean.setParticipacion(altaConocimientoCteRequest.getParticipacion());
		conocimientoCteBean.setNacionalidad(altaConocimientoCteRequest.getNacionalidad());
		conocimientoCteBean.setRazonSocial(altaConocimientoCteRequest.getRazonSocial());
		conocimientoCteBean.setGiro(altaConocimientoCteRequest.getGiro());
		conocimientoCteBean.setPEPs(altaConocimientoCteRequest.getPEPs());
		conocimientoCteBean.setFuncionID(altaConocimientoCteRequest.getFuncionID());
		conocimientoCteBean.setParentescoPEP(altaConocimientoCteRequest.getParentescoPEP());

		conocimientoCteBean.setNombFamiliar(altaConocimientoCteRequest.getNombFamiliar());
		conocimientoCteBean.setaPaternoFam(altaConocimientoCteRequest.getAPaternoFam());
		conocimientoCteBean.setaMaternoFam(altaConocimientoCteRequest.getAMaternoFam());
		conocimientoCteBean.setNoEmpleados(altaConocimientoCteRequest.getNoEmpleados());
		conocimientoCteBean.setServ_Produc(altaConocimientoCteRequest.getServ_Produc());
		conocimientoCteBean.setCober_Geograf(altaConocimientoCteRequest.getCober_Geograf());
		conocimientoCteBean.setEstados_Presen(altaConocimientoCteRequest.getEstados_Presen());
		conocimientoCteBean.setImporteVta(altaConocimientoCteRequest.getImporteVta());
		conocimientoCteBean.setActivos(altaConocimientoCteRequest.getActivos());
		conocimientoCteBean.setPasivos(altaConocimientoCteRequest.getPasivos());
		
		conocimientoCteBean.setCapital(altaConocimientoCteRequest.getCapital());
		conocimientoCteBean.setImporta(altaConocimientoCteRequest.getImporta());
		conocimientoCteBean.setDolaresImport(altaConocimientoCteRequest.getDolaresImport());
		conocimientoCteBean.setPaisesImport(altaConocimientoCteRequest.getPaisesImport());
		conocimientoCteBean.setPaisesImport2(altaConocimientoCteRequest.getPaisesImport2());
		conocimientoCteBean.setPaisesImport3(altaConocimientoCteRequest.getPaisesImport3());
		conocimientoCteBean.setExporta(altaConocimientoCteRequest.getExporta());
		conocimientoCteBean.setDolaresExport(altaConocimientoCteRequest.getDolaresExport());
		conocimientoCteBean.setPaisesExport(altaConocimientoCteRequest.getPaisesExport());
		conocimientoCteBean.setPaisesExport2(altaConocimientoCteRequest.getPaisesExport2());
		
		conocimientoCteBean.setPaisesExport3(altaConocimientoCteRequest.getPaisesExport3());
		conocimientoCteBean.setNombRefCom(altaConocimientoCteRequest.getNombRefCom());
		conocimientoCteBean.setNombRefCom2(altaConocimientoCteRequest.getNombRefCom2());
		conocimientoCteBean.setTelRefCom(altaConocimientoCteRequest.getTelRefCom());
		conocimientoCteBean.setTelRefCom2(altaConocimientoCteRequest.getTelRefCom2());
		conocimientoCteBean.setBancoRef(altaConocimientoCteRequest.getBancoRef());
		conocimientoCteBean.setBancoRef2(altaConocimientoCteRequest.getBancoRef2());
		conocimientoCteBean.setNoCuentaRef(altaConocimientoCteRequest.getNoCuentaRef());
		conocimientoCteBean.setNoCuentaRef2(altaConocimientoCteRequest.getNoCuentaRef2());
		conocimientoCteBean.setNombreRef(altaConocimientoCteRequest.getNombreRef());
		
		conocimientoCteBean.setNombreRef2(altaConocimientoCteRequest.getNombreRef2());
		conocimientoCteBean.setDomicilioRef(altaConocimientoCteRequest.getDomicilioRef());
		conocimientoCteBean.setDomicilioRef2(altaConocimientoCteRequest.getDomicilioRef2());
		conocimientoCteBean.setTelefonoRef(altaConocimientoCteRequest.getTelefonoRef());
		conocimientoCteBean.setTelefonoRef2(altaConocimientoCteRequest.getTelefonoRef2());
		conocimientoCteBean.setpFuenteIng(altaConocimientoCteRequest.getPFuenteIng());
		conocimientoCteBean.setIngAproxMes(altaConocimientoCteRequest.getIngAproxMes());

		UsuarioBean usuarioBean = new UsuarioBean();
		UsuarioBean usuario = new UsuarioBean();
		usuarioBean.setUsuarioID(usuarioWS);
		usuario=usuarioServicio.consulta(UsuarioServicio.Enum_Con_Usuario.consultaWS,usuarioBean);
		conocimientoCteServicio.getConocimientoCteDAO().getParametrosAuditoriaBean().setNombrePrograma("cuentas.ws.altaConocimientoCte");
		conocimientoCteServicio.getConocimientoCteDAO().getParametrosAuditoriaBean().setDireccionIP(usuario.getIpSesion());
		conocimientoCteServicio.getConocimientoCteDAO().getParametrosAuditoriaBean().setEmpresaID(Integer.parseInt(usuario.getEmpresaID()));
		conocimientoCteServicio.getConocimientoCteDAO().getParametrosAuditoriaBean().setSucursal(Integer.parseInt(usuario.getSucursalUsuario()));
		conocimientoCteServicio.getConocimientoCteDAO().getParametrosAuditoriaBean().setUsuario(Integer.parseInt(usuarioWS));
		
		mensaje = conocimientoCteServicio.grabaTransaccion(ConocimientoCteServicio.Enum_Tra_ConoClient.altaWS, conocimientoCteBean);

		altaConocimientoCteResponse.setCodigoRespuesta(String.valueOf( mensaje.getNumero()));
		altaConocimientoCteResponse.setMensajeRespuesta(mensaje.getDescripcion());
		
		return altaConocimientoCteResponse;
	}

	

	public void setConocimientoCteServicio(
			ConocimientoCteServicio conocimientoCteServicio) {
		this.conocimientoCteServicio = conocimientoCteServicio;
	}

	public void setUsuarioServicio(UsuarioServicio usuarioServicio) {
		this.usuarioServicio = usuarioServicio;
	}

	protected Object invokeInternal(Object arg0) throws Exception {
		AltaConocimientoCteRequest altaConocimientoCteRequest = (AltaConocimientoCteRequest)arg0; 			
		return altaConocimientoCte(altaConocimientoCteRequest);		
	}

}
