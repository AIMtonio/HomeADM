
package originacion.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import originacion.bean.RepBitacoraSolBean;
import originacion.dao.RepBitacoraSolDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.servicio.BaseServicio;

public class RepBitacoraSolServicio extends BaseServicio {
	
	private RepBitacoraSolServicio(){
		super();
	}
	
	RepBitacoraSolDAO repBitacoraSolDAO = null;
	
	
	public static interface Enum_Tip_Reporte { 
		int excel = 1;		
	}
	
	
	public String reportesAsambleas(RepBitacoraSolBean repBitacoraSolBean, String nombreReporte) throws Exception{
		ParametrosReporte parametrosReporte = new ParametrosReporte();
		List  listaRep = null;
		return Reporte.creaHtmlReporte(nombreReporte, parametrosReporte, parametrosAuditoriaBean.getRutaReportes(), parametrosAuditoriaBean.getRutaImgReportes());
	}

	/* Controla los tipos de lista para reportes de solicitudes de apoyo escolar*/
	public List <RepBitacoraSolBean> listaReporte(int tipoReporte, RepBitacoraSolBean repBitacoraSolBean , HttpServletResponse response){
		 List <RepBitacoraSolBean>listaBitacora=null;
	
		switch(tipoReporte){		
			case  Enum_Tip_Reporte.excel:				
				listaBitacora = repBitacoraSolDAO.listaReporte(repBitacoraSolBean, tipoReporte);
				break;
			}
		
		return listaBitacora;
	}
	

	public RepBitacoraSolDAO getRepBitacoraSolDAO() {
		return repBitacoraSolDAO;
	}

	public void setRepBitacoraSolDAO(RepBitacoraSolDAO repBitacoraSolDAO) {
		this.repBitacoraSolDAO = repBitacoraSolDAO;
	}

	

}
