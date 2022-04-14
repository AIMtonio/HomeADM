package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import java.io.ByteArrayOutputStream;
import pld.bean.PersInvListasBean;
import pld.bean.PersonaReqSeidoBean;
import pld.dao.PersonaReqSeidoDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class PersonaReqSeidoServicio extends BaseServicio {
	
	// Variables 
	PersonaReqSeidoDAO	personaReqSeidoDAO	= null;
	
	//Transacciones 
	public static interface Enum_Tra_PersonasSeido {
		int	alta	= 1;
	}
	
	public PersonaReqSeidoServicio() {
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PersonaReqSeidoBean personaReqSeidoBean) {
		
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_PersonasSeido.alta :
				mensaje = personaReqSeidoDAO.altaPersonaReqSeido(personaReqSeidoBean);
				break;
		}
		return mensaje;
	}

	public ByteArrayOutputStream reportePDF(PersInvListasBean persInvListasBean, String nombreReporte) {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try {
			parametrosReporte.agregaParametro("Par_NombreInstitucion", persInvListasBean.getNombreInstitucion() != null ? persInvListasBean.getNombreInstitucion().toUpperCase() : Constantes.STRING_VACIO);
			parametrosReporte.agregaParametro("Par_ClavePersonaInv", persInvListasBean.getClavePersonaInv());
			parametrosReporte.agregaParametro("Par_NombreCompleto", persInvListasBean.getNombreCompleto());
			parametrosReporte.agregaParametro("Par_Usuario", persInvListasBean.getUsuario());
			parametrosReporte.agregaParametro("Par_NombreSucursal", persInvListasBean.getSucursalDes());
			parametrosReporte.agregaParametro("Par_FechaSistema", persInvListasBean.getFechaSistema());
			parametrosReporte.agregaParametro("Par_Fecga", persInvListasBean.getSucursalDes());
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en el Reporte de Clientes en Listas PLD", e);
		}
		return null;
	}
	
	public PersonaReqSeidoDAO getPersonaReqSeidoDAO() {
		return personaReqSeidoDAO;
	}
	
	public void setPersonaReqSeidoDAO(PersonaReqSeidoDAO personaReqSeidoDAO) {
		this.personaReqSeidoDAO = personaReqSeidoDAO;
	}
	
}
