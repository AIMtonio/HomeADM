package inversiones.servicio;


import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import inversiones.bean.HistoricoTasasInvBean;
import inversiones.bean.TasasInversionBean;
import inversiones.dao.TasasInversionDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;

public class TasasInversionServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------	
	
	TasasInversionDAO tasasInversionDAO = null;
	 
	public static interface Enum_Tra_TasaInversion {
		int alta = 1;
		int modificacion = 2;
	}
	
	public static interface Enum_Con_TasaInversion {
		int principal = 1;
		int dias = 2;
		int montos = 3;
		int tasa = 4;
		
	}
	
	//---------- Constructor ------------------------------------------------------------------------	
	public TasasInversionServicio(){
		super();
	}
	
	//---------- Transacciones ------------------------------------------------------------------------
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TasasInversionBean tasasInversionBean){
		
		MensajeTransaccionBean mensaje = null;
		
		switch(tipoTransaccion){
			case(Enum_Tra_TasaInversion.alta):
					mensaje = tasasInversionDAO.alta(tasasInversionBean);
				break;
			case(Enum_Tra_TasaInversion.modificacion):
					mensaje = tasasInversionDAO.modificaTasa(tasasInversionBean);
				break;
		}
		
		
		return mensaje;
		
	}
	
	public TasasInversionBean consultaPrincipal(int tipoConsulta, TasasInversionBean tasasInversionBean){
		
		TasasInversionBean 	tasasInversion = null;
				
		switch(tipoConsulta){
			case(Enum_Con_TasaInversion.principal):
				tasasInversion = tasasInversionDAO.consultaPrincipal(tasasInversionBean, tipoConsulta);
				break;
			case Enum_Con_TasaInversion.tasa:
				tasasInversion = tasasInversionDAO.consultaTasa(tasasInversionBean);
				break;
		
		}
		return tasasInversion;
	}
	
	/*public TasasInversionBean totalTasa(TasasInversionBean tasasInversionBean){
		
		TasasInversionBean 	tasasInversion = new TasasInversionBean();
				
		tasasInversion = tasasInversionDAO.consultaTasa(tasasInversionBean);
		
		return tasasInversion;
				
	}*/

	
	//---------- Reportes ------------------------------------------------------------------------
	
	public String reporteHistoricoTasas(HistoricoTasasInvBean historicoTasasInvBean,
										String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();		
		parametrosReporte.agregaParametro("Par_Fecha", historicoTasasInvBean.getFecha());										   
		parametrosReporte.agregaParametro("Par_TipoInversion", historicoTasasInvBean.getTipoInversionID());
		parametrosReporte.agregaParametro("Par_DescriTipoInversion", historicoTasasInvBean.getDescripcionTipoInversion());		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	
	
	
	public String reporteTasaInversion(TasasInversionBean tasasInversionBean, String nombreReporte)throws Exception{
		
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		
		parametrosReporte.agregaParametro("Par_TipoInversion", tasasInversionBean.getTipoInvercionID());
		parametrosReporte.agregaParametro("Par_DescripcionInversion", tasasInversionBean.getTipoInversionDescripcion());
				
		
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());		
	}


	public void setTasasInversionDAO(TasasInversionDAO tasasInversionDAO) {
		this.tasasInversionDAO = tasasInversionDAO;
	}

}

