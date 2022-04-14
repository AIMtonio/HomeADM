package riesgos.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosMayorInsolutoPMDAO;

public class CreditosMayorInsolutoPMServicio extends BaseServicio{
	CreditosMayorInsolutoPMDAO creditosMayorInsolutoPMDAO = null;
	
	public CreditosMayorInsolutoPMServicio (){
		super();
	}
	
	/* ====== Tipo de Lista para Mayor Saldo Insoluto P.M. ======= */
	public static interface Enum_Lis_RepMayorSaldoPM	{
		int excel	 = 1;
	}
	
	// Consulta de Mayor Saldo Insoluto P.M. (Grid)
	public static interface Enum_Lis_MayorSaldoPM{
		int mayorSaldoInsolutoPM = 1;
	}
	
	// Consulta de Mayor Saldo Insoluto P.M. 
		public static interface Enum_Con_MayorSaldoPM{
			int consultaParametro = 2;
	}
		
	// Lista para el reporte en Excel Mayor Saldo Insoluto P.M.
	public List <UACIRiesgosBean>listaReporteMayorSaldoPM(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepMayorSaldoPM.excel:
				listaReportes = creditosMayorInsolutoPMDAO.reporteMayorSaldoInsolutoPM(riesgosBean, Enum_Lis_RepMayorSaldoPM.excel); 
				break;	
		}
		return listaReportes;
	}

	// Consulta de Mayor Saldo Insoluto P.M. (Grid)
	public List lista(int tipoLista, UACIRiesgosBean riesgosBean){	
		List listaMayorSaldoInsPM = null;
		switch (tipoLista) {
		case Enum_Lis_MayorSaldoPM.mayorSaldoInsolutoPM:		
			listaMayorSaldoInsPM = creditosMayorInsolutoPMDAO.listaGridMayorSaldoPM(tipoLista, riesgosBean);	
			break;			
		}
		return listaMayorSaldoInsPM;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean riesgos = null;
		switch (tipoConsulta) {
			case Enum_Con_MayorSaldoPM.consultaParametro:		
				riesgos = creditosMayorInsolutoPMDAO.consultaParametro(riesgosBean, tipoConsulta);				
				break;
		}						
		return riesgos;
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
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosMayorInsolutoPMDAO getCreditosMayorInsolutoPMDAO() {
		return creditosMayorInsolutoPMDAO;
	}

	public void setCreditosMayorInsolutoPMDAO(
			CreditosMayorInsolutoPMDAO creditosMayorInsolutoPMDAO) {
		this.creditosMayorInsolutoPMDAO = creditosMayorInsolutoPMDAO;
	}
	
	
}
