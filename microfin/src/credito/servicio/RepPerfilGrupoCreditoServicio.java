package credito.servicio;
 
import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;

import credito.bean.RepPerfilGrupoCreditoBean;
import credito.dao.RepPerfilGrupoCreditoDAO;

import reporte.ParametrosReporte;
import reporte.Reporte;


public class RepPerfilGrupoCreditoServicio extends BaseServicio {
	RepPerfilGrupoCreditoDAO repPerfilGrupoCreditoDAO= null;
	
	private RepPerfilGrupoCreditoServicio(){
		super();
	}
	
	public static interface Enum_Con_GruposCre{
		int con_PerfilGpo = 7;

	}
	
	public ByteArrayOutputStream reportePerfilGrupoPDF(
			RepPerfilGrupoCreditoBean repPerfilGrupoCreditoBean,
			String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try{
		RepPerfilGrupoCreditoBean repPerfilGrupo = null;
		
		
		repPerfilGrupo = repPerfilGrupoCreditoDAO.ConsultaPerfilGrupo(repPerfilGrupoCreditoBean, Enum_Con_GruposCre.con_PerfilGpo);

		parametrosReporte.agregaParametro("Par_GrupoID",repPerfilGrupoCreditoBean.getGrupoID());
		parametrosReporte.agregaParametro("Par_NombreInstitutcion",repPerfilGrupoCreditoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Usuario",repPerfilGrupoCreditoBean.getUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision",repPerfilGrupoCreditoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreGrupo",repPerfilGrupoCreditoBean.getNombreGrupo());
		parametrosReporte.agregaParametro("Par_FechaRegistro",repPerfilGrupoCreditoBean.getFechaRegistro());
		parametrosReporte.agregaParametro("Par_Nivel",repPerfilGrupoCreditoBean.getCicloActual());
		parametrosReporte.agregaParametro("Par_EstatusCiclo",repPerfilGrupoCreditoBean.getEstatusCiclo());
		
		parametrosReporte.agregaParametro("Par_DireccionCompleta",repPerfilGrupo.getDireccionCompleta());
		parametrosReporte.agregaParametro("Par_NombrePromotor",repPerfilGrupo.getNombrePromotor());		
		parametrosReporte.agregaParametro("Par_NombreSucursal",repPerfilGrupo.getNombreSucur());
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en  perfil de credito de grupo", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public RepPerfilGrupoCreditoDAO getRepPerfilGrupoCreditoDAO() {
		return repPerfilGrupoCreditoDAO;
	}

	public void setRepPerfilGrupoCreditoDAO(
			RepPerfilGrupoCreditoDAO repPerfilGrupoCreditoDAO) {
		this.repPerfilGrupoCreditoDAO = repPerfilGrupoCreditoDAO;
	}
	
	
}
