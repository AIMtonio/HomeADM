package seguimiento.servicio;

import java.io.ByteArrayOutputStream;

import reporte.ParametrosReporte;
import reporte.Reporte;
import seguimiento.bean.FormatoSeguimientoBean;
import seguimiento.dao.SeguimientoDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;

public class FormatoSeguimientoServicio extends BaseServicio{
	SeguimientoDAO seguimientoDAO = null;
	public FormatoSeguimientoServicio(){
		super();
	}
	
	public ByteArrayOutputStream formatoSegtoCampoPDF(FormatoSeguimientoBean formatoSeguimientoBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_FechaInicio", formatoSeguimientoBean.getFechaInicio() );
		parametrosReporte.agregaParametro("Par_FechaFin", formatoSeguimientoBean.getFechaFin() );
		parametrosReporte.agregaParametro("Par_CategoriaID", (!formatoSeguimientoBean.getCategoriaID().isEmpty() ? formatoSeguimientoBean.getCategoriaID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_CategoriaDes", (!formatoSeguimientoBean.getCategoriaID().isEmpty() ? formatoSeguimientoBean.getCategoriaDesc() : "TODOS"));
		parametrosReporte.agregaParametro("Par_SucursalID", (!formatoSeguimientoBean.getSucursalID().isEmpty() ? formatoSeguimientoBean.getSucursalID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_SucursalDesc", (!formatoSeguimientoBean.getSucursalID().isEmpty() ? formatoSeguimientoBean.getSucursalDesc() : "TODOS"));		
		parametrosReporte.agregaParametro("Par_GestorID", (!formatoSeguimientoBean.getGestorID().isEmpty() ? formatoSeguimientoBean.getGestorID() : Constantes.STRING_CERO));
		parametrosReporte.agregaParametro("Par_GestorDesc", (!formatoSeguimientoBean.getGestorID().isEmpty() ? formatoSeguimientoBean.getGestorDesc() : "TODOS"));

		parametrosReporte.agregaParametro("Par_NomInstitucion", formatoSeguimientoBean.getNomInstitucion());
		parametrosReporte.agregaParametro("Par_FechaEmision", formatoSeguimientoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",formatoSeguimientoBean.getNomUsuario());

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	// Getter y Setter
	public SeguimientoDAO getSeguimientoDAO() {
		return seguimientoDAO;
	}

	public void setSeguimientoDAO(SeguimientoDAO seguimientoDAO) {
		this.seguimientoDAO = seguimientoDAO;
	}
}
