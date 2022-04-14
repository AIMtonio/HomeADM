package cuentas.servicio;

import java.io.ByteArrayOutputStream;

import cuentas.bean.RepDeclaracionOperacionesBean;
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.bean.ParametrosAuditoriaBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 
public class RepDeclaracionOperacionesServicio extends BaseServicio {

	ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	
	public RepDeclaracionOperacionesServicio() {
		super();
	}
	
	/* =========  Formato de Declaracion personal de operaciones (por cuenta de ahorro)  =========== */
	public ByteArrayOutputStream reporteDecPersonal(int tipoReporte, RepDeclaracionOperacionesBean reportedBean , String nomReporte) 
			throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_CuentaAhoID", reportedBean.getCuentaAhoID());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", reportedBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_Fecha",Utileria.convierteFecha(reportedBean.getFecha()));
		parametrosReporte.agregaParametro("Par_Usuario",reportedBean.getUsuario().toUpperCase());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, 
				parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
}
