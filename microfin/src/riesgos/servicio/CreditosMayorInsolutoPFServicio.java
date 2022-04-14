package riesgos.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosMayorInsolutoPFDAO;

public class CreditosMayorInsolutoPFServicio extends BaseServicio{
	CreditosMayorInsolutoPFDAO creditosMayorInsolutoPFDAO = null;
	
	public CreditosMayorInsolutoPFServicio (){
		super();
	}	
	
	/* ====== Tipo de Lista para Mayor Saldo Insoluto P.F. ======= */
	public static interface Enum_Lis_RepMayorSaldoPF	{
		int excel	 = 1;
	}

	// Consulta de Mayor Saldo Insoluto P.F. (Grid)
	public static interface Enum_Lis_MayorSaldoPF{
		int mayorSaldoInsolutoPF = 1;
	}
	
	// Consulta de Mayor Saldo Insoluto P.F. 
	public static interface Enum_Con_MayorSaldoPF{
		int consultaParametro = 2;
	}
	
	// Lista para el reporte en Excel Mayor Saldo Insoluto P.F.
	public List <UACIRiesgosBean>listaReporteMayorSaldoPF(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepMayorSaldoPF.excel:
				listaReportes = creditosMayorInsolutoPFDAO.reporteMayorSaldoInsolutoPF(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	// Consulta de Mayor Saldo Insoluto P.F. (Grid)
	public List lista(int tipoLista, UACIRiesgosBean riesgosBean){	
		List listaMayorSaldoInsPF = null;
		switch (tipoLista) {
		case Enum_Lis_MayorSaldoPF.mayorSaldoInsolutoPF:		
			listaMayorSaldoInsPF = creditosMayorInsolutoPFDAO.listaGridMayorSaldoPF(tipoLista, riesgosBean);	
			break;			
		}
		return listaMayorSaldoInsPF;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean riesgos = null;
		switch (tipoConsulta) {
			case Enum_Con_MayorSaldoPF.consultaParametro:		
				riesgos = creditosMayorInsolutoPFDAO.consultaParametro(riesgosBean, tipoConsulta);				
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
	public CreditosMayorInsolutoPFDAO getCreditosMayorInsolutoPFDAO() {
		return creditosMayorInsolutoPFDAO;
	}

	public void setCreditosMayorInsolutoPFDAO(
			CreditosMayorInsolutoPFDAO creditosMayorInsolutoPFDAO) {
		this.creditosMayorInsolutoPFDAO = creditosMayorInsolutoPFDAO;
	}
	
}
