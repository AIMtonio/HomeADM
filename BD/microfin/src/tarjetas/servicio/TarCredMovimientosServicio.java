package tarjetas.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tarjetas.bean.TarCredMovimientosBean;
import tarjetas.dao.TarCredMovimientosDAO;

import general.servicio.BaseServicio;
 
public class TarCredMovimientosServicio  extends BaseServicio{
	
	TarCredMovimientosDAO tarCredMovimientosDAO = null;
	
	public TarCredMovimientosServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	// Consulta de movimientos pro tarjeta (Grid)
	public static interface Enum_Lis_MovimientosTarjetas{
		int principal = 1;
	}
	
	public List lista(int tipoLista, TarCredMovimientosBean tarCredMovimientosBean){	
		List listaMovimientos = null;
		switch (tipoLista) {
		case Enum_Lis_MovimientosTarjetas.principal:		
			listaMovimientos = tarCredMovimientosDAO.listaGridMovimientos(tipoLista, tarCredMovimientosBean);	
			break;	
		}
		return listaMovimientos;
	}
	
	// Reporte Movimientos Tarjetas
	public ByteArrayOutputStream creaReporteMovimientosTarCredPDF(TarCredMovimientosBean tarCredMovimientosBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_TarjetaCredID",tarCredMovimientosBean.getTarjetaID());
		parametrosReporte.agregaParametro("Par_AnioPeriodo",tarCredMovimientosBean.getAnioPeriodo());
		parametrosReporte.agregaParametro("Par_MesPeriodo",tarCredMovimientosBean.getMesPeriodo()) ;
		parametrosReporte.agregaParametro("Par_TipoReporte",tarCredMovimientosBean.getNumeroReporte());
		parametrosReporte.agregaParametro("Par_FechaEmision",tarCredMovimientosBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarCredMovimientosBean.getNombreUsuario().isEmpty())?tarCredMovimientosBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarCredMovimientosBean.getNombreInstitucion().isEmpty())?tarCredMovimientosBean.getNombreInstitucion(): "Todos");
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	public ByteArrayOutputStream reporteMovsTarCred(TarCredMovimientosBean tarDebMovimientosBean, String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TipoOperacion",tarDebMovimientosBean.getTipoOperacion());
		parametrosReporte.agregaParametro("Par_FechaInicio",tarDebMovimientosBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",tarDebMovimientosBean.getFechaVencimiento());
		parametrosReporte.agregaParametro("Par_TipoReporte",tarDebMovimientosBean.getNumeroReporte());
		parametrosReporte.agregaParametro("Par_FechaEmision",tarDebMovimientosBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NomUsuario",(!tarDebMovimientosBean.getNombreUsuario().isEmpty())?tarDebMovimientosBean.getNombreUsuario(): "Todos");
		parametrosReporte.agregaParametro("Par_NomInstitucion",(!tarDebMovimientosBean.getNombreInstitucion().isEmpty())?tarDebMovimientosBean.getNombreInstitucion(): "Todos");
		
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}


	
	//------------------setter y getter-----------

	public TarCredMovimientosDAO getTarCredMovimientosDAO() {
		return tarCredMovimientosDAO;
	}

	public void setTarCredMovimientosDAO(TarCredMovimientosDAO tarCredMovimientosDAO) {
		this.tarCredMovimientosDAO = tarCredMovimientosDAO;
	}
	
}
