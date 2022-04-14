package pld.servicio;
import java.util.List;
import java.io.ByteArrayOutputStream;


import reporte.ParametrosReporte;
import reporte.Reporte;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class OperAltoRiesgoServicio extends BaseServicio {
 
	private OperAltoRiesgoServicio(){
		super();
	}
	public String reporteOperAltoRiesgo( String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		parametrosReporte.agregaParametro("Par","par");
	return Reporte.creaHtmlReporte(nombreReporte,parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}
	

}
