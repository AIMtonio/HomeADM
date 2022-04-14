package cuentas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
 
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import cuentas.dao.CuentasAhoMovDAO;
import cuentas.bean.CuentasAhoMovBean;
import cuentas.bean.ReporteCuentasAhoMovBean;
public class CuentasAhoMovServicio extends BaseServicio {

	private CuentasAhoMovServicio(){
		super();
	}

	CuentasAhoMovDAO cuentasAhoMovDAO = null;

	public static interface Enum_Tra_CuentasAhoMov {
		int alta = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_CuentasAhoMov{
		int consulta = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_CuentasAhoMov{
		int principal = 1;
		int foranea = 2;
		int movcuentasInu = 3;
	}
	
	public static interface Enum_Reportes_CuentasAhoMov{
		int listRepExc = 1;
	}



	public List lista(int tipoLista, CuentasAhoMovBean cuentasAhoMov){

		List cuentasAhoMovLista = null;

		switch (tipoLista) {
		case Enum_Lis_CuentasAhoMov.principal:
			cuentasAhoMovLista = cuentasAhoMovDAO.listaPrincipal(cuentasAhoMov, tipoLista);
			break;
		case Enum_Lis_CuentasAhoMov.movcuentasInu:
			cuentasAhoMovLista = cuentasAhoMovDAO.listaMovimientosInu(cuentasAhoMov, tipoLista);
			break;
		
		}
		return cuentasAhoMovLista;
	}
	public List Reporteslista(int tipoLista, ReporteCuentasAhoMovBean reporteCuentasAhoMovBean){
		List cuentasAhoMovLista = null;
		switch (tipoLista) {
		case Enum_Reportes_CuentasAhoMov.listRepExc:
			cuentasAhoMovLista = cuentasAhoMovDAO.reporteExcel(reporteCuentasAhoMovBean, tipoLista);
			break;
		}
		return cuentasAhoMovLista;
	}
	
	public ByteArrayOutputStream creaRepCuentasAhoMovPDF(ReporteCuentasAhoMovBean reporteCuentasAhoMovBean,String nomReporte)throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicial",	((!reporteCuentasAhoMovBean.getFechaInicial().isEmpty())?	reporteCuentasAhoMovBean.getFechaInicial(): "1900-01-01"));
		parametrosReporte.agregaParametro("Par_FechaFinal",		((!reporteCuentasAhoMovBean.getFechaFinal().isEmpty())?		reporteCuentasAhoMovBean.getFechaFinal(): 	"1900-01-01"));
		parametrosReporte.agregaParametro("Par_TipoCuenta",		((!reporteCuentasAhoMovBean.getTipoCuenta().isEmpty())?		reporteCuentasAhoMovBean.getTipoCuenta(): 	"0"));
		parametrosReporte.agregaParametro("Par_Genero",			((!reporteCuentasAhoMovBean.getGenero().isEmpty())?			reporteCuentasAhoMovBean.getGenero(): 		""));
		parametrosReporte.agregaParametro("Par_Promotor",		((!reporteCuentasAhoMovBean.getPromotor().isEmpty())?		reporteCuentasAhoMovBean.getPromotor(): 	"0"));
		parametrosReporte.agregaParametro("Par_Moneda",			((!reporteCuentasAhoMovBean.getMoneda().isEmpty())?			reporteCuentasAhoMovBean.getMoneda(): 		"0"));
		parametrosReporte.agregaParametro("Par_Sucursal",		((!reporteCuentasAhoMovBean.getSucursal().isEmpty())?		reporteCuentasAhoMovBean.getSucursal(): 	"0"));
		parametrosReporte.agregaParametro("Par_Estado",			((!reporteCuentasAhoMovBean.getEstado().isEmpty())?			reporteCuentasAhoMovBean.getEstado(): 		"0"));
		parametrosReporte.agregaParametro("Par_Municipio",		((!reporteCuentasAhoMovBean.getMunicipio().isEmpty())?		reporteCuentasAhoMovBean.getMunicipio(): 	"0"));
		parametrosReporte.agregaParametro("Par_Mostrar",		((!reporteCuentasAhoMovBean.getMostrar().isEmpty())?		reporteCuentasAhoMovBean.getMostrar(): 		""));
		parametrosReporte.agregaParametro("Par_DetTipoCuenta",	((!reporteCuentasAhoMovBean.getDetTipoCuenta().isEmpty())?	reporteCuentasAhoMovBean.getDetTipoCuenta():"TODOS"));
		parametrosReporte.agregaParametro("Par_DetGenero",		((!reporteCuentasAhoMovBean.getDetGenero().isEmpty())?		reporteCuentasAhoMovBean.getDetGenero(): 	"TODOS"));
		parametrosReporte.agregaParametro("Par_DetPromotor",	((!reporteCuentasAhoMovBean.getDetPromotor().isEmpty())?	reporteCuentasAhoMovBean.getDetPromotor(): 	"TODOS"));
		parametrosReporte.agregaParametro("Par_DetMoneda",		((!reporteCuentasAhoMovBean.getDetMoneda().isEmpty())?		reporteCuentasAhoMovBean.getDetMoneda(): 	"TODOS"));
		parametrosReporte.agregaParametro("Par_DetSucursal",	((!reporteCuentasAhoMovBean.getDetSucursal().isEmpty())?	reporteCuentasAhoMovBean.getDetSucursal(): 	"TODOS"));
		parametrosReporte.agregaParametro("Par_DetEstado",		((!reporteCuentasAhoMovBean.getDetEstado().isEmpty())?		reporteCuentasAhoMovBean.getDetEstado(): 	"TODOS"));
		parametrosReporte.agregaParametro("Par_DetMunicipio",	((!reporteCuentasAhoMovBean.getDetMunicipio().isEmpty())?	reporteCuentasAhoMovBean.getDetMunicipio(): "TODOS"));
		parametrosReporte.agregaParametro("Par_DetMostrar",		((!reporteCuentasAhoMovBean.getDetMostrar().isEmpty())?		reporteCuentasAhoMovBean.getDetMostrar(): 	"TODOS"));
		parametrosReporte.agregaParametro("Par_FechaActual",	((!reporteCuentasAhoMovBean.getFechaActual().isEmpty())?	reporteCuentasAhoMovBean.getFechaActual():	"1900-01-01"));
		parametrosReporte.agregaParametro("Par_ClaveUsuario",	((!reporteCuentasAhoMovBean.getClaveUsuario().isEmpty())?	reporteCuentasAhoMovBean.getClaveUsuario():	"TODOS"));
		parametrosReporte.agregaParametro("Par_NomInstitucion",	((!reporteCuentasAhoMovBean.getNomInstitucion().isEmpty())?	reporteCuentasAhoMovBean.getNomInstitucion():	""));
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public void setCuentasAhoMovDAO(CuentasAhoMovDAO cuentasAhoMovDAO ){
		this.cuentasAhoMovDAO = cuentasAhoMovDAO;
	}

}
