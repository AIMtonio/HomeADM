package pld.servicio;

import contabilidad.bean.ReportesContablesBean;
import pld.bean.ParametrosOpRelBean;
import pld.dao.ParametrosOpRelDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
 

public class ParametrosOpRelServicio extends BaseServicio {
	private ParametrosOpRelServicio(){
		super();
	}
	//---------- Variables ------------------------------------------------------------------------
	ParametrosOpRelDAO parametrosOpRelDAO = null;

		//---------- Tipos de transacciones---------------------------------------------------------------
		public static interface Enum_Tra_ParOpRel {
			int alta   = 1; // alta para limite de operaciones relevantes y microcredito
			int alta2  =2; // alta para tipo de Instrumentos
		}
		public static interface Enum_Con_ParOpRel {
			int principal   = 1;
			int tipoInstrume = 2 ;
		}
		//---------- Tipos de Listas---------------------------------------------------------------
		public static interface Enum_Lis_ParOpRel {
			int principal   = 1;
			
		}
		
		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ParametrosOpRelBean parametrosOpRelBean){
			MensajeTransaccionBean mensaje = null;
			switch(tipoTransaccion){
				case Enum_Tra_ParOpRel.alta:
					mensaje = parametrosOpRelDAO.alta(parametrosOpRelBean, tipoTransaccion);
				break;
				case Enum_Tra_ParOpRel.alta2:
					mensaje = parametrosOpRelDAO.altaTipoInstrumentos(parametrosOpRelBean, tipoTransaccion);
			}
			
			return mensaje;
		}
		
		public ParametrosOpRelBean consulta(int tipoConsulta, ParametrosOpRelBean parametrosOpRelBean){
		
			ParametrosOpRelBean parametrosOpRel = null;
			switch(tipoConsulta){
				case Enum_Con_ParOpRel.principal:
					parametrosOpRel = parametrosOpRelDAO.consultaPrincipal(parametrosOpRelBean,tipoConsulta);
				break;
				case Enum_Con_ParOpRel.tipoInstrume:
					parametrosOpRel = parametrosOpRelDAO.consultaPrincipalTipoInst(parametrosOpRelBean,tipoConsulta);
				
			}
			return parametrosOpRel;
		}
		

 public String reportesOpRel(ParametrosOpRelBean parametrosOpRelBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreUsuario",parametrosOpRelBean.getNombreusuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",parametrosOpRelBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaActual",parametrosOpRelBean.getFechaEmision());
		parametrosReporte.agregaParametro("Par_MonedaLimOPR",parametrosOpRelBean.getDesMonedaLimOPR());
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
 public String reportesOpTipoInstrum(ParametrosOpRelBean parametrosOpRelBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par_NombreUsuario",parametrosOpRelBean.getNombreusuario());
		parametrosReporte.agregaParametro("Par_NombreInstitucion",parametrosOpRelBean.getNombreInstitucion());
		parametrosReporte.agregaParametro("Par_FechaActual",parametrosOpRelBean.getFechaEmision());
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

		//------------------ Geters y Seters --------------------------------------------
	
		
		public ParametrosOpRelDAO getParametrosOpRelDAO() {
			return parametrosOpRelDAO;
		}


		public void setParametrosOpRelDAO(ParametrosOpRelDAO parametrosOpRelDAO) {
			this.parametrosOpRelDAO = parametrosOpRelDAO;
		}
		
}

