package originacion.servicio;

import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import originacion.bean.ReporteConsolidacionBean;
import originacion.dao.ReporteConsolidacionDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class ReporteConsolidacionSerivicio extends BaseServicio{

private ReporteConsolidacionDAO reporteConsolidacionDAO;
	
	public ReporteConsolidacionSerivicio () {
		super();
	}
	
	@SuppressWarnings("rawtypes")
	public List listaReporteConsolidaciones(ReporteConsolidacionBean reporteConsolidacionBean){
		List listaConsolidaciones=null;
		listaConsolidaciones = reporteConsolidacionDAO.listaConsolidaciones(reporteConsolidacionBean);
	
		return listaConsolidaciones;
	}

	public ByteArrayOutputStream repConsolidacionesPDF(ReporteConsolidacionBean reporteConsolidacionBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicial",reporteConsolidacionBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFin",reporteConsolidacionBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_SucursalID",(!reporteConsolidacionBean.getSucursalID().equals(""))?reporteConsolidacionBean.getSucursalID():"0");
		parametrosReporte.agregaParametro("Par_ProductoCreditoID",(!reporteConsolidacionBean.getProductoCredito().equals(""))?reporteConsolidacionBean.getProductoCredito():"0");
		parametrosReporte.agregaParametro("Par_NombreSucursal", reporteConsolidacionBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_NombreProducto", reporteConsolidacionBean.getNombreProductoCredito());
		parametrosReporte.agregaParametro("Par_FechaSistema",reporteConsolidacionBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_ClaveUsuario",reporteConsolidacionBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion", reporteConsolidacionBean.getNombreInstitucion());
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ReporteConsolidacionDAO getReporteConsolidacionDAO() {
		return reporteConsolidacionDAO;
	}


	public void setReporteConsolidacionDAO(ReporteConsolidacionDAO reporteConsolidacionDAO) {
		this.reporteConsolidacionDAO = reporteConsolidacionDAO;
	}

	
	
}
