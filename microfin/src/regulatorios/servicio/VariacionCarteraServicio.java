package regulatorios.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;
import regulatorios.bean.VariacionCarteraBean;
import regulatorios.dao.VariacionCarteraDAO;
import general.servicio.BaseServicio;

public class VariacionCarteraServicio extends BaseServicio{
	
	VariacionCarteraDAO variacionCarteraDAO = null;
    String[] meses = {"","ENERO","FEBRERO","MARZO","ABRIL","MAYO","JUNIO","JULIO","AGOSTO","SEPTIEMBRE","OCTUBRE","NOVIEMBRE","DICIEMBRE"};
    
    public VariacionCarteraServicio() {
		super();
	}

    /* ================== Tipo de Lista para Variacion de Cartera ============== */
	public static interface Enum_Lis_VariacionCartera{
		int excel	 = 1;
	}

	
	public List <VariacionCarteraBean>listaReporteVariacionCartera(int tipoLista, VariacionCarteraBean variacionCartera, HttpServletResponse response){
		List<VariacionCarteraBean> listaReportes=null;
		switch(tipoLista){
			case Enum_Lis_VariacionCartera.excel:
				listaReportes = variacionCarteraDAO.reporteCarteraVariacion(variacionCartera, Enum_Lis_VariacionCartera.excel); 
				break;	
		}
		return listaReportes;
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
	public VariacionCarteraDAO getVariacionCarteraDAO() {
		return variacionCarteraDAO;
	}

	public void setVariacionCarteraDAO(VariacionCarteraDAO variacionCarteraDAO) {
		this.variacionCarteraDAO = variacionCarteraDAO;
	}
    
    
}
