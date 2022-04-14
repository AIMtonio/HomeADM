package cliente.servicio;

import java.io.ByteArrayOutputStream;

import general.bean.ParametrosSesionBean;
import general.servicio.BaseServicio;
import reporte.ParametrosReporte;
import reporte.Reporte;
import cliente.bean.RepExtravioDocsBean;

public class RepExtravioDocsServicio extends BaseServicio{
	
	public ByteArrayOutputStream reporteExtravioDocsPDF(RepExtravioDocsBean repExtravioDocs,String nombreReporte, ParametrosSesionBean paramSesionBean) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TipoReporte",repExtravioDocs.getTipoRep());
		parametrosReporte.agregaParametro("Par_CuentaID", repExtravioDocs.getCuentaID());
		parametrosReporte.agregaParametro("Par_InversionID", repExtravioDocs.getInversionID());
		parametrosReporte.agregaParametro("Par_ClienteID", repExtravioDocs.getClienteID());
		parametrosReporte.agregaParametro("Par_NombreCliente", repExtravioDocs.getNombreCliente());
		parametrosReporte.agregaParametro("Par_Fecha", parametrosAuditoriaBean.getFecha());
		parametrosReporte.agregaParametro("Par_Sucursal",paramSesionBean.getNombreSucursal());
		parametrosReporte.agregaParametro("Par_RutaImgReportes", parametrosAuditoriaBean.getRutaImgReportes());
		parametrosReporte.agregaParametro("Par_NombreUsuario", paramSesionBean.getNombreUsuario());
		
		return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(),parametrosAuditoriaBean.getRutaImgReportes()); 
	}

}
