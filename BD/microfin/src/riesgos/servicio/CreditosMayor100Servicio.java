package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosMayor100DAO;
import general.servicio.BaseServicio;

public class CreditosMayor100Servicio extends BaseServicio{
	CreditosMayor100DAO creditosMayor100DAO = null;
	
	public CreditosMayor100Servicio (){
		super();
	}
	
	/* ==== Tipo de Lista para creditos mayor a $100,000.00 ==== */
	public static interface Enum_Lis_CredMayor100Mil {
		int excel	 = 1;
	}
	
	/* == Tipo de Consulta para creditos mayor a $100,000.00 ==== */
	public static interface Enum_Con_CredMayor100Mil{
		int mayorCienMil	 = 1;
	}

	public List <UACIRiesgosBean>listaReporteMayor100mil(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_CredMayor100Mil.excel:
				listaReportes = creditosMayor100DAO.reporteCredMayor100mil(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean mayorCienMil = null;
		switch (tipoConsulta) {
			case Enum_Con_CredMayor100Mil.mayorCienMil:	
				mayorCienMil = creditosMayor100DAO.consultaCredMayorCienMil(riesgosBean,tipoConsulta);
				break;									
		}				
		return mayorCienMil;
	}
	
	 /* ********************** GETTERS y SETTERS **************************** */
	public CreditosMayor100DAO getCreditosMayor100DAO() {
		return creditosMayor100DAO;
	}

	public void setCreditosMayor100DAO(CreditosMayor100DAO creditosMayor100DAO) {
		this.creditosMayor100DAO = creditosMayor100DAO;
	}

}
