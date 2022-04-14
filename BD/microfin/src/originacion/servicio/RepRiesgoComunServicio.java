
package originacion.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import originacion.bean.RepRiesgoComunBean;
import originacion.dao.RepRiesgoComunDAO;
import reporte.ParametrosReporte;
import reporte.Reporte;
import general.servicio.BaseServicio;

public class RepRiesgoComunServicio extends BaseServicio {
	
	private RepRiesgoComunServicio(){
		super();
	}
	
	RepRiesgoComunDAO repRiesgoComunDAO = null;
	
	
	public static interface Enum_Tip_Reporte { 
		int excel = 1;		
	}
	
	public List <RepRiesgoComunBean> listaReporte(int tipoReporte, RepRiesgoComunBean repRiesgoComunBean , HttpServletResponse response){
		 List <RepRiesgoComunBean>listaRiesgos=null;
	
		switch(tipoReporte){		
			case  Enum_Tip_Reporte.excel:				
				listaRiesgos = repRiesgoComunDAO.listaReporte(repRiesgoComunBean, tipoReporte);
				break;
			}
		
		return listaRiesgos;
	}

	public RepRiesgoComunDAO getRepRiesgoComunDAO() {
		return repRiesgoComunDAO;
	}

	public void setRepRiesgoComunDAO(RepRiesgoComunDAO repRiesgoComunDAO) {
		this.repRiesgoComunDAO = repRiesgoComunDAO;
	}
	


	

}
