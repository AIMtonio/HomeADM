package fira.servicio;

import fira.bean.PagosAnticipadosAgroBean;
import fira.dao.CreditosAgroDAO;
import general.bean.ParametrosSesionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.Date;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import credito.bean.CreditosBean;
import credito.bean.PagosAnticipadosBean;
import cuentas.bean.MonedasBean;
import cuentas.servicio.MonedasServicio;

public class CreditosAgroServicio extends BaseServicio {
	
	ParametrosSesionBean	parametrosSesionBean	= null;
	CreditosAgroDAO			creditosAgroDAO			= null;
	TransaccionDAO			transaccionDAO			= null;
	MonedasServicio			monedasServicio			= null;

	
	public static interface Enum_Lis_CredRep {
		int	salTotalRepEx	= 3;	// numero que le coresponde en el sp de saldos totales al reporte de excel
		int anliticoCont	= 4;
		int movCreditosCont	= 5;
		int movimientosCredContSum = 6;
	}
	
	public CreditosAgroServicio() {
		super();
	}
	
	public List listaReportesCreditos(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List listaCreditos = null;
		switch (tipoLista) {
			case Enum_Lis_CredRep.salTotalRepEx :
				listaCreditos = creditosAgroDAO.consultaSaldosTotalesExcel(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.anliticoCont :
				listaCreditos = creditosAgroDAO.consultaSaldosTotalesExcelCont(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.movCreditosCont :
				listaCreditos = creditosAgroDAO.consultaReporteMovimientosCreditoCont(creditosBean, tipoLista);
				break;
			case Enum_Lis_CredRep.movimientosCredContSum :
				listaCreditos = creditosAgroDAO.consultaReporteMovimientosCreditoSum(creditosBean, tipoLista);
				break;
		}
		
		return listaCreditos;
	}
	
	/**
	 * Reporte de Pagos por Anticipados de la Cartera Agro
	 * @param tipoLista : Número de Lista
	 * @param creditosBean : bean con la información para filtrar.
	 * @param response
	 * @return
	 */
	
	public List<PagosAnticipadosAgroBean> pagosAnticipadosAgroRep(int tipoLista, CreditosBean creditosBean, HttpServletResponse response) {
		List listaCreditos = null;
		listaCreditos = creditosAgroDAO.pagosAnticipadosAgroRep(creditosBean, tipoLista);
		return listaCreditos;
	}
	
	/**
	 * Reporte Analitico de Cartera (Saldos totales) PDF
	 * @param creditosBean : {@link CreditosBean} Bean con la información del reporte
	 * @param nombreReporte : Strin Nombre del reporte
	 * @return {@link ByteArrayOutputStream}
	 * @throws Exception
	 * @author pmontero
	 */
	public ByteArrayOutputStream reporteSaldosTotalesCreditoPDF(CreditosBean creditosBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha", creditosBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_Sucursal", creditosBean.getSucursal());
		parametrosReporte.agregaParametro("Par_Moneda", creditosBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_ProductoCre", creditosBean.getProducCreditoID());
		parametrosReporte.agregaParametro("Par_Promotor", creditosBean.getPromotorID());
		parametrosReporte.agregaParametro("Par_Genero", creditosBean.getSexo());
		parametrosReporte.agregaParametro("Par_Estado", creditosBean.getEstadoID());
		parametrosReporte.agregaParametro("Par_Municipio", creditosBean.getMunicipioID());
		
		parametrosReporte.agregaParametro("Par_NomSucursal", (!creditosBean.getNombreSucursal().isEmpty()) ? creditosBean.getNombreSucursal() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomMoneda", (!creditosBean.getNombreMoneda().isEmpty()) ? creditosBean.getNombreMoneda() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomProductoCre", (!creditosBean.getNombreProducto().isEmpty()) ? creditosBean.getNombreProducto() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomPromotor", (!creditosBean.getNombrePromotor().isEmpty()) ? creditosBean.getNombrePromotor() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomGenero", (!creditosBean.getNombreGenero().isEmpty()) ? creditosBean.getNombreGenero() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomEstado", (!creditosBean.getNombreEstado().isEmpty()) ? creditosBean.getNombreEstado() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomMunicipio", (!creditosBean.getNombreMunicipi().isEmpty()) ? creditosBean.getNombreMunicipi() : "TODOS");
		
		parametrosReporte.agregaParametro("Par_NomUsuario", (!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion", (!creditosBean.getNombreInstitucion().isEmpty()) ? creditosBean.getNombreInstitucion() : "TODOS");
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public String reporteSaldosTotalesCredito(CreditosBean creditosBean, String nomReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_Fecha", creditosBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_Sucursal", creditosBean.getSucursal());
		parametrosReporte.agregaParametro("Par_MonedaID", creditosBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_ProductoCre", creditosBean.getProducCreditoID());
		parametrosReporte.agregaParametro("Par_Usuario", creditosBean.getUsuario());
		return Reporte.creaHtmlReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream reporMovsCreditoPDF(CreditosBean creditosBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		
		Date FechaD = new Date();
		java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("H:mm");
		String hora = sdf.format(FechaD);
		creditosBean.setFechTerminacion(hora);
		
		parametrosReporte.agregaParametro("Par_CreditoID", creditosBean.getCreditoID());
		parametrosReporte.agregaParametro("Par_FechaInicio", creditosBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin", creditosBean.getFechaVencimien());
		parametrosReporte.agregaParametro("Par_NomInstitucion", creditosBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_NomUsuario", creditosBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_HoraReporte", creditosBean.getFechTerminacion()); // hora de reporte
		parametrosReporte.agregaParametro("Par_ClienteID", creditosBean.getClienteID());
		parametrosReporte.agregaParametro("Par_NombreCliente", creditosBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_MontoOtorgado", Utileria.convierteDoble(creditosBean.getMontoCredito()));
		parametrosReporte.agregaParametro("Par_ProductoID", creditosBean.getProducCreditoID());
		parametrosReporte.agregaParametro("Par_ProductoNombre", creditosBean.getNombreProducto());
		parametrosReporte.agregaParametro("Par_FechaDesembolso", creditosBean.getFechaMinistrado());
		parametrosReporte.agregaParametro("Par_SaldoTotal", Utileria.convierteDoble(creditosBean.getAdeudoTotal()));
		parametrosReporte.agregaParametro("Par_EstatusCred", creditosBean.getEstatus());
		parametrosReporte.agregaParametro("Par_Moneda", creditosBean.getMonedaID());
		parametrosReporte.agregaParametro("Par_FechaEmision", creditosBean.getParFechaEmision());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/**
	 * Reporte Creditos Consolidados PDF
	 * @param creditosBean : {@link CreditosBean} Bean con la información del reporte
	 * @param nombreReporte : Strin Nombre del reporte
	 * @return {@link ByteArrayOutputStream}
	 * @throws Exception
	 */
	public ByteArrayOutputStream reporteCreditoConsolidaPDF(CreditosBean creditosBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", creditosBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",creditosBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_Sucursal", creditosBean.getSucursal());
		parametrosReporte.agregaParametro("Par_ProductoCreditoID", creditosBean.getProducCreditoID());
		parametrosReporte.agregaParametro("Par_Estatus", creditosBean.getEstatus());

		parametrosReporte.agregaParametro("Par_NomSucursal", (!creditosBean.getNombreSucursal().isEmpty()) ? creditosBean.getNombreSucursal() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomProductoCre", (!creditosBean.getNombreProducto().isEmpty()) ? creditosBean.getNombreProducto() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomEstatus", (!creditosBean.getEstatusCred().isEmpty()) ? creditosBean.getEstatusCred() : "TODOS");

		parametrosReporte.agregaParametro("Par_NomUsuario", (!creditosBean.getNombreUsuario().isEmpty()) ? creditosBean.getNombreUsuario() : "TODOS");
		parametrosReporte.agregaParametro("Par_NomInstitucion", (!creditosBean.getNombreInstitucion().isEmpty()) ? creditosBean.getNombreInstitucion() : "TODOS");
		parametrosReporte.agregaParametro("Par_RutaImagen", parametrosAuditoriaBean.getRutaImgReportes());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}
	
	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
	
	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}
	
	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public CreditosAgroDAO getCreditosAgroDAO() {
		return creditosAgroDAO;
	}

	public void setCreditosAgroDAO(CreditosAgroDAO creditosAgroDAO) {
		this.creditosAgroDAO = creditosAgroDAO;
	}

	public MonedasServicio getMonedasServicio() {
		return monedasServicio;
	}

	public void setMonedasServicio(MonedasServicio monedasServicio) {
		this.monedasServicio = monedasServicio;
	}

	
	
}