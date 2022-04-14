package credito.servicio;

import java.io.ByteArrayOutputStream;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.ActaConstitutivaGrupBean;
import credito.dao.ActaConstitutivaGrupDAO;
import credito.dao.GruposCreditoDAO;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class ActaConstitutivaGrupServicio extends BaseServicio {
	
	ActaConstitutivaGrupDAO actaConstitutivaGrupDAO = null;
	
	private ActaConstitutivaGrupServicio(){
		super();
	}
	
	public static interface Enum_Con_GruposCre{
		int principal = 1;

	}
	public ByteArrayOutputStream reporteActaConstiPDF(
			ActaConstitutivaGrupBean gruposCreditosBean, String nombreReporte)  throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		ActaConstitutivaGrupBean actaConstitutivaGrupBean = null;
		actaConstitutivaGrupBean = actaConstitutivaGrupDAO.ConsultaRegistroActaConsti(gruposCreditosBean, Enum_Con_GruposCre.principal);
		
		parametrosReporte.agregaParametro("Par_GrupoID",Utileria.convierteEntero(gruposCreditosBean.getGrupoID()));
		parametrosReporte.agregaParametro("Par_NombreInstitucion",gruposCreditosBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NombrePres",actaConstitutivaGrupBean.getNombrePres());
		parametrosReporte.agregaParametro("Par_NombreTeso",actaConstitutivaGrupBean.getNombreTeso());
		parametrosReporte.agregaParametro("Par_NombreSecre",actaConstitutivaGrupBean.getNombreSecre());
		parametrosReporte.agregaParametro("Par_NombreGrupo",actaConstitutivaGrupBean.getNombreGrupo());
		parametrosReporte.agregaParametro("Par_RegistroReca",actaConstitutivaGrupBean.getNumReca());
		parametrosReporte.agregaParametro("Par_DirecCompleta",actaConstitutivaGrupBean.getDirecCompleta());
		parametrosReporte.agregaParametro("Par_GaranLiquida",actaConstitutivaGrupBean.getGaranLiq());
		parametrosReporte.agregaParametro("Par_Mes",actaConstitutivaGrupBean.getMes());
		parametrosReporte.agregaParametro("Par_Anio",actaConstitutivaGrupBean.getAnio());
		parametrosReporte.agregaParametro("Par_Dia",actaConstitutivaGrupBean.getDia());
		parametrosReporte.agregaParametro("Par_Hora",actaConstitutivaGrupBean.getHora());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ActaConstitutivaGrupDAO getActaConstitutivaGrupDAO() {
		return actaConstitutivaGrupDAO;
	}
	public void setActaConstitutivaGrupDAO(
			ActaConstitutivaGrupDAO actaConstitutivaGrupDAO) {
		this.actaConstitutivaGrupDAO = actaConstitutivaGrupDAO;
	}

	
}
