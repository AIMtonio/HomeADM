package inversiones.servicio;

import inversiones.bean.RepRetensionISRBean;
import inversiones.dao.RepRetensionISRDAO;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import reporte.ParametrosReporte;
import reporte.Reporte;
 
public class RepRetensionISRServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	RepRetensionISRDAO repRetensionISRDAO = null;
	
	//---------- Constructor ------------------------------------------------------------------------
	public RepRetensionISRServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	//---------- Reportes ------------------------------------------------------------------------	
	
	public ByteArrayOutputStream reporteRetensionISRPDF(RepRetensionISRBean repRetensionISRBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();										   
		parametrosReporte.agregaParametro("Par_FechaInicio", repRetensionISRBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFin", repRetensionISRBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_Institucion", repRetensionISRBean.getInstitucionID());	
		parametrosReporte.agregaParametro("Par_ClienteID",repRetensionISRBean.getClienteID());
		parametrosReporte.agregaParametro("Par_SucursalID",repRetensionISRBean.getSucursalID());		
		parametrosReporte.agregaParametro("Par_FechaEmision",repRetensionISRBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreUsuario",repRetensionISRBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",repRetensionISRBean.getNombreInstitucion());
				
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List<RepRetensionISRBean> listaReporteRetensionISRExcel(int tipolista,
			RepRetensionISRBean repRetensionISRBean, HttpServletResponse response) {
		List<RepRetensionISRBean> listaRepRetensionISR=null;
		
		listaRepRetensionISR = repRetensionISRDAO.consultaRetensionISR(repRetensionISRBean); 
		
		return listaRepRetensionISR;
	}

	public RepRetensionISRDAO getRepRetensionISRDAO() {
		return repRetensionISRDAO;
	}

	public void setRepRetensionISRDAO(RepRetensionISRDAO repRetensionISRDAO) {
		this.repRetensionISRDAO = repRetensionISRDAO;
	}

	
	
}
