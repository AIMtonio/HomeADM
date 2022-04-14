package tesoreria.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import credito.bean.AvaladosCreditoRepBean;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.ReporteChequesSBCBean;
import tesoreria.dao.ReporteChequesSBCDAO;
import general.servicio.BaseServicio;
 
public class ReporteChequesSBCServicio extends BaseServicio {
	
	
	ReporteChequesSBCDAO reporteChequesSBCDAO=null;
	
	private ReporteChequesSBCServicio(){
		super();
	}
	public ByteArrayOutputStream reporteChequesSBCPDF(
			ReporteChequesSBCBean reporteChequesSBCBean, String nombreReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		try{

			parametrosReporte.agregaParametro("Par_InstiBancaria",reporteChequesSBCBean.getInstitucionIDIni());
			
			parametrosReporte.agregaParametro("Par_NombreInstitucionIni",reporteChequesSBCBean.getNombInstitucionIni());
			
			parametrosReporte.agregaParametro("Par_Sucursal",reporteChequesSBCBean.getSucursalID());
			parametrosReporte.agregaParametro("Par_NombreSucursal",reporteChequesSBCBean.getNombreSucursal());
			
			parametrosReporte.agregaParametro("Par_ClienteID",reporteChequesSBCBean.getClienteIDIni());
			
			parametrosReporte.agregaParametro("Par_NombreCliente",reporteChequesSBCBean.getNombreClienteIni());
			
			parametrosReporte.agregaParametro("Par_EstatusCheque",reporteChequesSBCBean.getEstatusCheque());
			
			parametrosReporte.agregaParametro("Par_NoCuentaInstitu",reporteChequesSBCBean.getNoCuentaInstituIni());
			
			parametrosReporte.agregaParametro("Par_FechaInicio",reporteChequesSBCBean.getFechaInicial());
			parametrosReporte.agregaParametro("Par_FechaFin",reporteChequesSBCBean.getFechaFinal());
			
			parametrosReporte.agregaParametro("Par_NombreInstitucion",reporteChequesSBCBean.getNombreInstitucion());
			parametrosReporte.agregaParametro("Par_Usuario",reporteChequesSBCBean.getNombreUsuario());
			parametrosReporte.agregaParametro("Par_FechaSistema",reporteChequesSBCBean.getFechaSistema());


		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en el reporte de Avalados", e);
		}
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List ListaChequesSBC(int tipoLista,
			ReporteChequesSBCBean reporteChequesSBCBean,
			HttpServletResponse response) {
		// TODO Auto-generated method stub
		List listaChequesSBC =null;
		
				
		listaChequesSBC = reporteChequesSBCDAO.consultaChequesSBCExcel(reporteChequesSBCBean, tipoLista); 
		
		return listaChequesSBC;
	}


	public ReporteChequesSBCDAO getReporteChequesSBCDAO() {
		return reporteChequesSBCDAO;
	}

	public void setReporteChequesSBCDAO(ReporteChequesSBCDAO reporteChequesSBCDAO) {
		this.reporteChequesSBCDAO = reporteChequesSBCDAO;
	}

	
	
	
	

}
