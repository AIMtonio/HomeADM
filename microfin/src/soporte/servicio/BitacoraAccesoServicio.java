package soporte.servicio;

import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.io.ByteArrayOutputStream;

import reporte.ParametrosReporte;
import reporte.Reporte;
import soporte.bean.RepBitacoraAccesoBean;

public class BitacoraAccesoServicio extends BaseServicio{

	// Creacion del reporte en PDf de la bitacora de accesos
	public ByteArrayOutputStream reporteBitacoraAccesoPDF(RepBitacoraAccesoBean repBitacoraAccesoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_FechaInicio",(!repBitacoraAccesoBean.getFechaInicio().isEmpty() ? repBitacoraAccesoBean.getFechaInicio() : Constantes.FECHA_VACIA));
		parametrosReporte.agregaParametro("Par_FechaFin", (!repBitacoraAccesoBean.getFechaFin().isEmpty() ? repBitacoraAccesoBean.getFechaFin() : Constantes.FECHA_VACIA));
		parametrosReporte.agregaParametro("Par_UsuarioID", (!repBitacoraAccesoBean.getUsuarioID().isEmpty() ? repBitacoraAccesoBean.getUsuarioID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_SucursalID", (!repBitacoraAccesoBean.getSucursalID().isEmpty() ? repBitacoraAccesoBean.getSucursalID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_TipoAcceso", (!repBitacoraAccesoBean.getTipoAcceso().isEmpty() ? repBitacoraAccesoBean.getTipoAcceso() : Constantes.STRING_CERO));		

		parametrosReporte.agregaParametro("Par_NombreInstitucion", repBitacoraAccesoBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaSistema", repBitacoraAccesoBean.getFechaSistema());
		parametrosReporte.agregaParametro("Par_ClaveUsuario",repBitacoraAccesoBean.getClaveUsuario());
		parametrosReporte.agregaParametro("Par_NombreUsuario",repBitacoraAccesoBean.getNombreUsuario());
		parametrosReporte.agregaParametro("Par_NombreSucursal",repBitacoraAccesoBean.getNombreSucursal());

		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

}
