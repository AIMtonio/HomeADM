package contabilidad.servicio;
import java.util.List;

import regulatorios.bean.RepRegCatalogoMinimoBean;
import contabilidad.bean.ReporteISRRetenidoBean;
import contabilidad.bean.ReportePolizaBean;
import contabilidad.dao.ReporteISRRetenidoDAO;

import general.servicio.BaseServicio;
public class ReporteISRRetenidoServicio extends	BaseServicio{
	
	ReporteISRRetenidoDAO reporteISRRetenidoDAO = null;
	
	
	private ReporteISRRetenidoServicio(){
		super();
	}
	public static interface Enum_Lis_reporteISRRetenidoServicio{
		int reporteExcel 	= 1;
		int consultaAnios 	= 2;

	}
	
	public List listaReportes( ReporteISRRetenidoBean isrRetenidoBean,int tipoLista ){
		List<ReporteISRRetenidoBean> listaRepReg=null;
		switch(tipoLista){
			case Enum_Lis_reporteISRRetenidoServicio.reporteExcel:
				listaRepReg = reporteISRRetenidoDAO.repISRRetener(isrRetenidoBean,tipoLista); 
				break;	
		}
		
		return listaRepReg;
	}
	
	public List consulta(int tipoLista){
		List<ReporteISRRetenidoBean> listaRepReg=null;
		listaRepReg = reporteISRRetenidoDAO.listaAniosISR(tipoLista);
		return listaRepReg;
	}
	
	public String descripcionMes(String meses){
		String mes = "";
		int mese = Integer.parseInt(meses);
        switch (mese) {
            case 1:  mes ="ENERO" ; break;
            case 2:  mes ="FEBRERO"; break;
            case 3:  mes ="MARZO"; break;
            case 4:  mes ="ABRIL"; break;
            case 5:  mes ="MAYO"; break;
            case 6:  mes ="JUNIO"; break;
            case 7:  mes ="JULIO"; break;
            case 8:  mes ="AGOSTO"; break;
            case 9:  mes ="SEPTIEMBRE"; break;
            case 10: mes ="OCTUBRE"; break;
            case 11: mes ="NOVIEMBRE"; break;
            case 12: mes ="DICIEMBRE"; break;
        }
        return mes;
	}

	public ReporteISRRetenidoDAO getReporteISRRetenidoDAO() {
		return reporteISRRetenidoDAO;
	}

	public void setReporteISRRetenidoDAO(ReporteISRRetenidoDAO reporteISRRetenidoDAO) {
		this.reporteISRRetenidoDAO = reporteISRRetenidoDAO;
	}
	
	
	 
}
