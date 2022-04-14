package tesoreria.servicio;
import general.bean.ParametrosAuditoriaBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.EstadoCuentaBancosReporteBean;
import tesoreria.dao.EstadoCuentaBancosReporteDAO;



public class EstadoCuentaBancosReporteServicio extends BaseServicio{
	

	protected TransaccionDAO transaccionDAO = null;
	protected ParametrosAuditoriaBean parametrosAuditoriaBean = null;
	EstadoCuentaBancosReporteDAO estadoCuentaBancosReporteDAO;
	 
	
   //Lista de movimientos para estado de cuenta bancos
   public List lista(EstadoCuentaBancosReporteBean tesoreriaMovsReporteBean){
		List tesoreriaMovsLista = null;
		tesoreriaMovsLista = estadoCuentaBancosReporteDAO.listaEstadoCuentaBancos(tesoreriaMovsReporteBean);
		return tesoreriaMovsLista;
	}
	

	//Reporte de Cuentas por Cliente PDF
	public ByteArrayOutputStream reporteEstadoCuentaBancosPDF(EstadoCuentaBancosReporteBean estadoCuentaBancosReporteBean,HttpServletRequest request, String nombreReporte) throws Exception{
		// Este reporte requiere que se le mande un numero de transaccion
		transaccionDAO.generaNumeroTransaccion();
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NomInstitucion",request.getParameter("nombreInstitucionSistema"));
		parametrosReporte.agregaParametro("Par_Fecha", estadoCuentaBancosReporteBean.getFecha());
		parametrosReporte.agregaParametro("Par_Banco", Utileria.convierteEntero(estadoCuentaBancosReporteBean.getInstitucionID()));
		parametrosReporte.agregaParametro("Par_Cuenta", estadoCuentaBancosReporteBean.getNumCtaInstit());
		parametrosReporte.agregaParametro("Par_NumTransac", parametrosAuditoriaBean.getNumeroTransaccion());
		parametrosReporte.agregaParametro("Par_NombreBanco",  request.getParameter("nombreInstitucion"));
		parametrosReporte.agregaParametro("Par_Usuario", request.getParameter("usuario"));
		parametrosReporte.agregaParametro("Par_Sucursal", request.getParameter("sucursal"));
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	public EstadoCuentaBancosReporteDAO getEstadoCuentaBancosReporteDAO() {
		return estadoCuentaBancosReporteDAO;
	}
	
	public void setEstadoCuentaBancosReporteDAO(
			EstadoCuentaBancosReporteDAO estadoCuentaBancosReporteDAO) {
		this.estadoCuentaBancosReporteDAO = estadoCuentaBancosReporteDAO;
	}
	
	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}
	
	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public ParametrosAuditoriaBean getParametrosAuditoriaBean() {
		return parametrosAuditoriaBean;
	}

	public void setParametrosAuditoriaBean(
			ParametrosAuditoriaBean parametrosAuditoriaBean) {
		this.parametrosAuditoriaBean = parametrosAuditoriaBean;
	}
	

}
