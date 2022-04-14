package cliente.servicio;

import java.util.List;
 
import javax.servlet.http.HttpServletResponse;

import reporte.ParametrosReporte;
import reporte.Reporte;
import tesoreria.bean.RepSaldoBancosCCBean;
import cliente.bean.RepConvenSecBean;
import cliente.dao.RepConvenSecDAO;
import general.servicio.BaseServicio;

public class RepConvenSecServicio extends BaseServicio {
	
	private RepConvenSecServicio(){
		super();
	}
	
	RepConvenSecDAO repConvenSecDAO = null;
	
	
	public static interface Enum_Tip_Reporte { 
		int excel = 1;
		int excelins= 2;
		int excelpros= 3;
	}
	
	
	public String reportesAsambleas(RepConvenSecBean repConvenSec, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		List  listaRep = null;
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/* Controla los tipos de lista para reportes de solicitudes de apoyo escolar*/
	public List <RepConvenSecBean> listaReporte(int tipoReporte, RepConvenSecBean repConvenSec , HttpServletResponse response){

		 List <RepConvenSecBean>listaConven=null;
	
		switch(tipoReporte){		
			case  Enum_Tip_Reporte.excel:
				listaConven = repConvenSecDAO.listaReporte(repConvenSec, tipoReporte);
				break;
			case  Enum_Tip_Reporte.excelins:
				listaConven = repConvenSecDAO.listaReporte(repConvenSec, tipoReporte);
				break;
			case  Enum_Tip_Reporte.excelpros:
				listaConven = repConvenSecDAO.listaReportePros(repConvenSec, tipoReporte);
				break;
		}
		
		return listaConven;
	}
	

	public RepConvenSecDAO getRepConvenSecDAO() {
		return repConvenSecDAO;
	}

	public void setRepConvenSecDAO(RepConvenSecDAO repConvenSecDAO) {
		this.repConvenSecDAO = repConvenSecDAO;
	}
	
	

}
