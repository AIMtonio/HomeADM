package pld.servicio;

import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.io.ByteArrayOutputStream;
import java.util.List;

import pld.bean.NivelRiesgoClienteBean;
import pld.dao.NivelRiesgoClienteDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class NivelRiesgoClienteServicio extends BaseServicio {

	NivelRiesgoClienteDAO nivelRiesgoClienteDAO=null;

	public NivelRiesgoClienteServicio(){
		super();
	}

	public static interface Enum_Con_NivelRiesgo{
		int principal = 1;
	};
	
	public static interface Enum_Tipo_Reporte{
		int riesgoActualCliente = 1;
		int historicoOperacionesRiesgoCliente = 3;
	};
	
	public List listaInstrumentos(NivelRiesgoClienteBean nivelRiesgoClienteBean){		
		List listaInstrumentos = null;		
		listaInstrumentos =  nivelRiesgoClienteDAO.listaInstrumentos(nivelRiesgoClienteBean,Enum_Con_NivelRiesgo.principal);				
		return listaInstrumentos;
	}

	public List listaReporte(NivelRiesgoClienteBean nivelRiesgoClienteBean, int tipoReporte){
		List lista= null;
		switch (tipoReporte) {
		case Enum_Tipo_Reporte.historicoOperacionesRiesgoCliente:
			lista = nivelRiesgoClienteDAO.listaReporte(nivelRiesgoClienteBean,Enum_Tipo_Reporte.historicoOperacionesRiesgoCliente);	
		}			
		return lista;
	}

	public List consultaNivelRiesgoPLD(NivelRiesgoClienteBean nivelRiesgoClienteBean, int tipoConsulta){		
		List listaResultado = null;

		listaResultado =  nivelRiesgoClienteDAO.consultaNivelRiesgoPLD(nivelRiesgoClienteBean, tipoConsulta);				

		return listaResultado;
	}
	
	/* =========  Reporte PDF  de Riesgos Cliente =========== */
	public ByteArrayOutputStream reporteRiesgoPLDCliente(NivelRiesgoClienteBean nivelRiesgoBean, String nomReporte) throws Exception {
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		long numeroTransaccion = nivelRiesgoClienteDAO.getNumeroTransaccion();
			
		parametrosReporte.agregaParametro("Par_ClienteID", Utileria.convierteEntero(nivelRiesgoBean.getClienteID()));
		parametrosReporte.agregaParametro("Par_NomInstitucion", nivelRiesgoBean.getNomInstitucion());
		parametrosReporte.agregaParametro("Par_NomSucursal", nivelRiesgoBean.getNomSucursal());
		parametrosReporte.agregaParametro("Par_NomUsuario", nivelRiesgoBean.getNomUsuario());
		parametrosReporte.agregaParametro("Par_FechaEmision", nivelRiesgoBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_NumTransaccion", String.valueOf(numeroTransaccion));

		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	/* =========  Reporte PDF  de Historico de Operaciones de Riesgo Cte =========== */
	public ByteArrayOutputStream repHisOperacionesRiesgoCLientePDF(NivelRiesgoClienteBean nivelRiesgoBean , String nomReporte) throws Exception{
		long numeroTransaccion = nivelRiesgoClienteDAO.getNumeroTransaccion();
		ParametrosReporte parametrosReporte = new ParametrosReporte();		
		parametrosReporte.agregaParametro("Par_ClienteID",Utileria.convierteEntero(nivelRiesgoBean.getClienteID()));		
		parametrosReporte.agregaParametro("Par_NombreCliente",nivelRiesgoBean.getNombreCliente());
		parametrosReporte.agregaParametro("Par_NomInstitucion",nivelRiesgoBean.getNomInstitucion());
		parametrosReporte.agregaParametro("Par_NomUsuario", nivelRiesgoBean.getNomUsuario());
		parametrosReporte.agregaParametro("Par_FechaInicio",nivelRiesgoBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",nivelRiesgoBean.getFechaFin());
		parametrosReporte.agregaParametro("Par_ProcesoEscID", nivelRiesgoBean.getOperProcesoID());
		parametrosReporte.agregaParametro("Par_ProcesoEscDesc", nivelRiesgoBean.getDescripcion());
		parametrosReporte.agregaParametro("Par_NumTransaccion",String.valueOf(numeroTransaccion));
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public ByteArrayOutputStream reporteEvaluacionMasivaPDF(NivelRiesgoClienteBean nivelRiesgoBean , String nomReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();		
		parametrosReporte.agregaParametro("Par_NomInstitucion",nivelRiesgoBean.getNomInstitucion());
		parametrosReporte.agregaParametro("Par_NomUsuario", nivelRiesgoBean.getNomUsuario());
		parametrosReporte.agregaParametro("Par_FechaInicio",nivelRiesgoBean.getFechaInicio());
		parametrosReporte.agregaParametro("Par_FechaFin",nivelRiesgoBean.getFechaFin());
		return Reporte.creaPDFReporte(nomReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	public NivelRiesgoClienteDAO getNivelRiesgoClienteDAO() {
		return nivelRiesgoClienteDAO;
	}

	public void setNivelRiesgoClienteDAO(NivelRiesgoClienteDAO nivelRiesgoClienteDAO) {
		this.nivelRiesgoClienteDAO = nivelRiesgoClienteDAO;
	}

}