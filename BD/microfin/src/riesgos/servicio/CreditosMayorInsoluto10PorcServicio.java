package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosMayorInsoluto10PorcDAO;
import general.servicio.BaseServicio;

public class CreditosMayorInsoluto10PorcServicio extends BaseServicio{
	CreditosMayorInsoluto10PorcDAO creditosMayorInsoluto10PorcDAO = null;
	
	public CreditosMayorInsoluto10PorcServicio (){
		super ();
	}
	/* ====== Tipo de Lista para Mayor Saldo Insoluto 10 % ======= */
	public static interface Enum_Lis_RepMayorSaldo10Porc	{
		int excel	 = 1;
	}
	
	// Consulta de Mayor Saldo Insoluto 10 % (Grid)
	public static interface Enum_Lis_MayorSaldo10Porc{
		int mayorSaldoInsoluto10Porc = 1;
	}
	
	// Consulta de Mayor Saldo Insoluto 10 %. 
	public static interface Enum_Con_MayorSaldo10Porc{
		int consultaParametro = 2;
	} 
			
	// Lista para el reporte en Excel Mayor Saldo Insoluto 10 %
	public List <UACIRiesgosBean>listaReporteMayorSaldo10Porc(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_RepMayorSaldo10Porc.excel:
				listaReportes = creditosMayorInsoluto10PorcDAO.reporteMayorSaldoInsoluto10Porc(riesgosBean, Enum_Lis_RepMayorSaldo10Porc.excel); 
				break;	
		}
		return listaReportes;
	}
	
	// Consulta de Mayor Saldo Insoluto 10 % (Grid)
	public List lista(int tipoLista, UACIRiesgosBean riesgosBean){	
		List listaMayorSaldoIns = null;
		switch (tipoLista) {
		case Enum_Lis_MayorSaldo10Porc.mayorSaldoInsoluto10Porc:		
			listaMayorSaldoIns = creditosMayorInsoluto10PorcDAO.listaGridMayorSaldo10Porc(tipoLista, riesgosBean);	
			break;			
		}
		return listaMayorSaldoIns;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean riesgos = null;
		switch (tipoConsulta) {
			case Enum_Con_MayorSaldo10Porc.consultaParametro:		
				riesgos = creditosMayorInsoluto10PorcDAO.consultaParametro(riesgosBean, tipoConsulta);				
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
	public CreditosMayorInsoluto10PorcDAO getCreditosMayorInsoluto10PorcDAO() {
		return creditosMayorInsoluto10PorcDAO;
	}

	public void setCreditosMayorInsoluto10PorcDAO(
			CreditosMayorInsoluto10PorcDAO creditosMayorInsoluto10PorcDAO) {
		this.creditosMayorInsoluto10PorcDAO = creditosMayorInsoluto10PorcDAO;
	}

	}


