package credito.servicio;

import general.servicio.BaseServicio;

import java.io.ByteArrayOutputStream;
 
import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.ActasComiteCreditoBean;

public class ActasComiteCreditoServicio extends BaseServicio {
	
	String nombreReporteSucursales = null;
	String nombreReporteMayores = null;
	String nombreReporteRelacionados=null;
	String nombreReporteReestructuras=null;
	
	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Tipo_ActaComite {
		int sucursales		= 1;
		int mayores			= 2;
		int relacionados	= 3;
		int reestructuras	= 4;
	}
		
	//-------------------------------------------------------------------------------------------------
	// -------------------- REPORTES -----------------------------------------------------------------
	//-------------------------------------------------------------------------------------------------	
	// Reporte Pagare Tasa Fija PDF
	public ByteArrayOutputStream reporteActaComite(ActasComiteCreditoBean comiteCreditoBean,
												   int tipoReporte) throws Exception{

		ParametrosReporte parametrosReporte = new ParametrosReporte();
		ByteArrayOutputStream htmlStringPDF = null;
		
		switch (tipoReporte) {
			case Enum_Tipo_ActaComite.sucursales:
				parametrosReporte.agregaParametro("Par_Sucursal",comiteCreditoBean.getSucursalID());
				parametrosReporte.agregaParametro("Par_Fecha",comiteCreditoBean.getFechaReporte());				
				htmlStringPDF = Reporte.creaPDFReporte(nombreReporteSucursales, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				break;
			case Enum_Tipo_ActaComite.mayores:						
				parametrosReporte.agregaParametro("Par_Fecha",comiteCreditoBean.getFechaReporte());
				htmlStringPDF = Reporte.creaPDFReporte(nombreReporteMayores, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				break;
			case Enum_Tipo_ActaComite.relacionados:						
				parametrosReporte.agregaParametro("Par_Fecha",comiteCreditoBean.getFechaReporte());
				htmlStringPDF = Reporte.creaPDFReporte(nombreReporteRelacionados, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				break;
			case Enum_Tipo_ActaComite.reestructuras:	
				parametrosReporte.agregaParametro("Par_Fecha",comiteCreditoBean.getFechaReporte());
				htmlStringPDF = Reporte.creaPDFReporte(nombreReporteReestructuras, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
				break;
		}
		return htmlStringPDF;
	}

	// ----------------------------- GETTERS Y SETTERS--------------------------------
	public String getNombreReporteSucursales() {
		return nombreReporteSucursales;
	}
	public void setNombreReporteSucursales(String nombreReporteSucursales) {
		this.nombreReporteSucursales = nombreReporteSucursales;
	}
	public String getNombreReporteMayores() {
		return nombreReporteMayores;
	}
	public void setNombreReporteMayores(String nombreReporteMayores) {
		this.nombreReporteMayores = nombreReporteMayores;
	}
	public String getNombreReporteRelacionados() {
		return nombreReporteRelacionados;
	}
	public void setNombreReporteRelacionados(String nombreReporteRelacionados) {
		this.nombreReporteRelacionados = nombreReporteRelacionados;
	}
	public String getNombreReporteReestructuras() {
		return nombreReporteReestructuras;
	}
	public void setNombreReporteReestructuras(String nombreReporteReestructuras) {
		this.nombreReporteReestructuras = nombreReporteReestructuras;
	}

	
	

}
