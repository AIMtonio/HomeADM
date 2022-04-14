package cuentas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import cuentas.bean.FoliosPlanAhorroBean;
import cuentas.controlador.FoliosPlanAhorroControlador;
import cuentas.dao.FoliosPlanAhorroDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;

public class FoliosPlanAhorroServicio extends BaseServicio{
	
	private FoliosPlanAhorroServicio() {
		super();
	}
	
	FoliosPlanAhorroDAO foliosPlanAhorro = null;
	
	public static interface Enum_Tra_FoliosPlanAhorro{
		int alta = 1;
	}
	
	public static interface Enum_Con_FoliosPlanAhorro{
		int principal = 1; 
	}
	
	public static interface Enum_Con_TipRepor{
		int reportePDF = 1;
		int reporteExcel = 2;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, FoliosPlanAhorroBean folioPlanAhorro) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion) {
		case Enum_Tra_FoliosPlanAhorro.alta:
			mensaje = altaFoliosPlanAhorro(folioPlanAhorro);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaFoliosPlanAhorro(FoliosPlanAhorroBean folioPlanAhorro) {
		MensajeTransaccionBean mensaje = null;
		mensaje = foliosPlanAhorro.alta(folioPlanAhorro);
		return mensaje;
	}
	
	public FoliosPlanAhorroBean consulta(int tipoConsulta, FoliosPlanAhorroBean folioPlanAhorro) {
		FoliosPlanAhorroBean folioPlanAhorroConsulta = null;
		switch(tipoConsulta) {
		case Enum_Con_FoliosPlanAhorro.principal:
			folioPlanAhorroConsulta = foliosPlanAhorro.consultaPrincipal(folioPlanAhorro, tipoConsulta);
			break;
		}
		
		return folioPlanAhorroConsulta;
	}
	
	public List reportesLista(int tipoReporte,FoliosPlanAhorroBean repPlanAhorro){
		List movsPlanAhorro = null;
		switch(tipoReporte){
		case Enum_Con_TipRepor.reporteExcel:
			movsPlanAhorro = foliosPlanAhorro.reporteExcel(repPlanAhorro,tipoReporte);
			break;
		}
		return movsPlanAhorro;
	}

	public FoliosPlanAhorroDAO getFoliosPlanAhorro() {
		return foliosPlanAhorro;
	}

	public void setFoliosPlanAhorro(FoliosPlanAhorroDAO foliosPlanAhorro) {
		this.foliosPlanAhorro = foliosPlanAhorro;
	}

	public ByteArrayOutputStream repPlanAhorroPDF(FoliosPlanAhorroBean reportePlanAhorroBean, String nombreReporte, ParametrosSesionBean paramSesionBean) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_PlanID",((!reportePlanAhorroBean.getPlanID().isEmpty()) ? reportePlanAhorroBean.getPlanID() : "0"));
		parametrosReporte.agregaParametro("Par_Sucursal",((!reportePlanAhorroBean.getSucursal().isEmpty()) ? reportePlanAhorroBean.getSucursal() : "0"));
		parametrosReporte.agregaParametro("Par_ClienteID",((!reportePlanAhorroBean.getClienteID().isEmpty()) ? reportePlanAhorroBean.getClienteID() : "0"));
		parametrosReporte.agregaParametro("Par_Estatus",((!reportePlanAhorroBean.getEstatus().isEmpty()) ? reportePlanAhorroBean.getEstatus() : ""));
		
		parametrosReporte.agregaParametro("Par_NombreInstitucion", paramSesionBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Usuario",paramSesionBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_Fecha",paramSesionBean.getFechaSucursal());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte,parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ByteArrayOutputStream repTicketPlanAhorro(FoliosPlanAhorroBean ticketPlanAhorro, String nombreReporte,ParametrosSesionBean parametrosSesionBean) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_PlanID",((!ticketPlanAhorro.getPlanID().isEmpty()) ? ticketPlanAhorro.getPlanID() : "0"));
		parametrosReporte.agregaParametro("Par_ClienteID",((!ticketPlanAhorro.getClienteID().isEmpty()) ? ticketPlanAhorro.getClienteID() : "0"));
		parametrosReporte.agregaParametro("Par_CuentaID", ((!ticketPlanAhorro.getCuentaID().isEmpty()) ? ticketPlanAhorro.getCuentaID() : "0"));
		parametrosReporte.agregaParametro("Par_NumTrans",((!ticketPlanAhorro.getNumTrans().isEmpty()) ? ticketPlanAhorro.getNumTrans() : "0"));		
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(),parametrosAuditoriaBean.getRutaImgReportes());
	}
}
