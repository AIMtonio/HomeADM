package cliente.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;
 

import cliente.bean.RepoteClientesMenoresBean;
import cliente.dao.ReporteClientesMenoresDAO;

import reporte.ParametrosReporte;
import reporte.Reporte;
import general.servicio.BaseServicio;

public class ReporteClienteMenoresServicio extends BaseServicio{
	ReporteClientesMenoresDAO reporteClientesMenoresDAO = null;
	
	private ReporteClienteMenoresServicio(){
		super();
	}
	
	public ByteArrayOutputStream reporteClientesMenoresPDF(
			RepoteClientesMenoresBean repoteClientesMenoresBean,
			String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();

		try{
			
			parametrosReporte.agregaParametro("Par_Sucursal",repoteClientesMenoresBean.getSucursalID());
			parametrosReporte.agregaParametro("Par_EstatusCta",repoteClientesMenoresBean.getEstatusCta());
			parametrosReporte.agregaParametro("Par_Promotor",repoteClientesMenoresBean.getPromotorActual());
			parametrosReporte.agregaParametro("Par_NombreSucursal",repoteClientesMenoresBean.getNombreSucurs());
			parametrosReporte.agregaParametro("Par_NombrePromotor",repoteClientesMenoresBean.getNombrePromotor());
			parametrosReporte.agregaParametro("Par_NombreInstitucion",repoteClientesMenoresBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_Usuario",repoteClientesMenoresBean.getUsuario());
			parametrosReporte.agregaParametro("Par_FechaSistema",repoteClientesMenoresBean.getFechaSistema());
			

		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte de Reporte de Clientes Menores", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List ListaSocioMenor(
			RepoteClientesMenoresBean repoteClientesMenoresBean,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		List lista =null;
		
		
		
		lista = reporteClientesMenoresDAO.consultaSociosMenores(repoteClientesMenoresBean); 
		return lista;
	}

	public ReporteClientesMenoresDAO getReporteClientesMenoresDAO() {
		return reporteClientesMenoresDAO;
	}

	public void setReporteClientesMenoresDAO(
			ReporteClientesMenoresDAO reporteClientesMenoresDAO) {
		this.reporteClientesMenoresDAO = reporteClientesMenoresDAO;
	}

}
