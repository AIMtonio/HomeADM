package riesgos.servicio;

import general.servicio.BaseServicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosMayorInsoluto3PorcDAO;

public class CreditosMayorInsoluto3PorcServicio extends BaseServicio{
	CreditosMayorInsoluto3PorcDAO creditosMayorInsoluto3PorcDAO = null;
	
	public CreditosMayorInsoluto3PorcServicio (){
		super ();
	}
	
	/* ====== Tipo de Lista para Mayor Saldo Insoluto 3.5 % ======= */
	public static interface Enum_Lis_RepMayorSaldo3Porc	{
		int excel	 = 1;
	}
	
	// Consulta de Mayor Saldo Insoluto 3.5 % (Grid)
	public static interface Enum_Lis_MayorSaldo3Porc{
		int mayorSaldoInsoluto3Porc = 1;
	}
	
	// Consulta de Mayor Saldo Insoluto 3.5 %. 
	public static interface Enum_Con_MayorSaldo3Porc{
		int consultaParametro = 2;
	} 
		
	// Lista para el reporte en Excel Mayor Saldo Insoluto 3.5 %
	public List <UACIRiesgosBean>listaReporteMayorSaldo3Porc(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepMayorSaldo3Porc.excel:
				listaReportes = creditosMayorInsoluto3PorcDAO.reporteMayorSaldoInsoluto3Porc(riesgosBean, Enum_Lis_RepMayorSaldo3Porc.excel); 
				break;	
		}
		return listaReportes;
	}
	
	// Consulta de Mayor Saldo Insoluto 3.5 % (Grid)
	public List lista(int tipoLista, UACIRiesgosBean riesgosBean){	
		List listaMayorSaldoIns = null;
		switch (tipoLista) {
		case Enum_Lis_MayorSaldo3Porc.mayorSaldoInsoluto3Porc:		
			listaMayorSaldoIns = creditosMayorInsoluto3PorcDAO.listaGridMayorSaldo3Porc(tipoLista, riesgosBean);	
			break;			
		}
		return listaMayorSaldoIns;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean riesgos = null;
		switch (tipoConsulta) {
			case Enum_Con_MayorSaldo3Porc.consultaParametro:		
				riesgos = creditosMayorInsoluto3PorcDAO.consultaParametro(riesgosBean, tipoConsulta);				
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
	public CreditosMayorInsoluto3PorcDAO getCreditosMayorInsoluto3PorcDAO() {
		return creditosMayorInsoluto3PorcDAO;
	}

	public void setCreditosMayorInsoluto3PorcDAO(
			CreditosMayorInsoluto3PorcDAO creditosMayorInsoluto3PorcDAO) {
		this.creditosMayorInsoluto3PorcDAO = creditosMayorInsoluto3PorcDAO;
	}
	
}
