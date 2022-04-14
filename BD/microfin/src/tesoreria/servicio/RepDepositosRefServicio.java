package tesoreria.servicio;

import java.io.ByteArrayOutputStream;
import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.RepDepositosRefBean;
import tesoreria.dao.RepDepositosRefDAO;
 

public class RepDepositosRefServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	RepDepositosRefDAO repDepositosRefDAO = null;
	
	//---------- Constructor ------------------------------------------------------------------------
	public RepDepositosRefServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
			
	public static interface Enum_Con_Poliza {
		int principal		= 1;
		int plantilla		= 2;
	}
	
	public static interface Enum_Lis_Poliza {
		int principal		= 1;
		int plantilla		= 2;
		}

	
	//---------- Reportes ------------------------------------------------------------------------	
	
	public ByteArrayOutputStream reporteDepositosRefPDF(RepDepositosRefBean repDepositosRefBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();										   
		parametrosReporte.agregaParametro("Par_FechaInicio", repDepositosRefBean.getFechaInicial());
		parametrosReporte.agregaParametro("Par_FechaFin", repDepositosRefBean.getFechaFinal());
		parametrosReporte.agregaParametro("Par_Institucion", repDepositosRefBean.getInstitucionID());
		parametrosReporte.agregaParametro("Par_CuentaAhoID",repDepositosRefBean.getCuentaBancaria());
		parametrosReporte.agregaParametro("Par_ClienteID",repDepositosRefBean.getClienteID());
		parametrosReporte.agregaParametro("Par_SucursalID",Utileria.convierteEntero(repDepositosRefBean.getSucursalID()));
		parametrosReporte.agregaParametro("Par_Estado",repDepositosRefBean.getEstado());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",repDepositosRefBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision",repDepositosRefBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NombreUsuario",repDepositosRefBean.getNombreUsuario());		
		parametrosReporte.agregaParametro("Par_NombreSucursal",repDepositosRefBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_DesnombreInstitucion",repDepositosRefBean.getDesnombreInstitucion());
		parametrosReporte.agregaParametro("Par_DescuentaBancaria",repDepositosRefBean.getDescuentaBancaria());
		parametrosReporte.agregaParametro("Par_DesclienteID",repDepositosRefBean.getDesclienteID());
		parametrosReporte.agregaParametro("Par_Descestado",repDepositosRefBean.getDescestado());
		parametrosReporte.agregaParametro("Par_DessucursalID",repDepositosRefBean.getDessucursalID());
			
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public List<RepDepositosRefBean> listaRepoteDepositosRefExcel(int tipolista,
			RepDepositosRefBean repDepositosRefBean, HttpServletResponse response) {
		List<RepDepositosRefBean> listaRepDepositosRef=null;
		
		listaRepDepositosRef = repDepositosRefDAO.consultaDepositosRef(repDepositosRefBean); 
		
		return listaRepDepositosRef;
	}

	public RepDepositosRefDAO getRepDepositosRefDAO() {
		return repDepositosRefDAO;
	}

	public void setRepDepositosRefDAO(RepDepositosRefDAO repDepositosRefDAO) {
		this.repDepositosRefDAO = repDepositosRefDAO;
	}	
	
	
	
}
