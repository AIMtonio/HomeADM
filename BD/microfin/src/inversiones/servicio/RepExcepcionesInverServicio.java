	package inversiones.servicio;

	
	import general.servicio.BaseServicio;
	import java.io.ByteArrayOutputStream;
	import reporte.ParametrosReporte;
	import reporte.Reporte;
	import inversiones.bean.RepExcepcionesInverBean;
	import inversiones.dao.RepExcepcionesInverDAO;

 
	public class RepExcepcionesInverServicio  extends BaseServicio {
		
		
		RepExcepcionesInverDAO repExcepcionesInverDAO = null;

	

		public RepExcepcionesInverServicio () {
			super();
			
		}
		
		//------------------ reporte Excepciones Inversion ------------------------------------------------------	
		public ByteArrayOutputStream reporteExcepcionesInver(RepExcepcionesInverBean repExcepcionesInverBean, String nombreReporte) throws Exception{
			ParametrosReporte parametrosReporte = new ParametrosReporte();

			parametrosReporte.agregaParametro("Par_FechaInicial",repExcepcionesInverBean.getFechaInicial());
			parametrosReporte.agregaParametro("Par_FechaFinal",repExcepcionesInverBean.getFechaFinal());
			parametrosReporte.agregaParametro("Par_TipoReporte",repExcepcionesInverBean.getTipoReporte());
			parametrosReporte.agregaParametro("Par_FechaEmision",repExcepcionesInverBean.getFechaEmision());
			parametrosReporte.agregaParametro("Par_TipoLista",repExcepcionesInverBean.getTipoLista());
			parametrosReporte.agregaParametro("Par_NomUsuario",(!repExcepcionesInverBean.getNombreUsuario().isEmpty())?repExcepcionesInverBean.getNombreUsuario(): "Todos");
			parametrosReporte.agregaParametro("Par_NomInstitucion",(!repExcepcionesInverBean.getNombreInstitucion().isEmpty())?repExcepcionesInverBean.getNombreInstitucion(): "Todos");
			return Reporte.creaPDFReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
		}
		

		//------------------ Geters y Seters ------------------------------------------------------	

		public RepExcepcionesInverDAO getRepExcepcionesInverDAO() {
			return repExcepcionesInverDAO;
		}


		public void setRepExcepcionesInverDAO(RepExcepcionesInverDAO repExcepcionesInverDAO) {
			this.repExcepcionesInverDAO = repExcepcionesInverDAO;
		}

		
	
	
		
	}

