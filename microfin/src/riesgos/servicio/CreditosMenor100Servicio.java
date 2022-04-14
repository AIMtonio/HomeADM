package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosMenor100DAO;
import general.servicio.BaseServicio;

public class CreditosMenor100Servicio extends BaseServicio{
	CreditosMenor100DAO creditosMenor100DAO = null;
	
	public CreditosMenor100Servicio (){
		super();
	}
	
	/* ==== Tipo de Lista para creditos menor a $100,000.00 ==== */
	public static interface Enum_Lis_CredMenor100Mil {
		int excel	 = 1;
	}
	
	/* == Tipo de Consulta para creditos menor a $100,000.00 ==== */
	public static interface Enum_Con_CredMenor100Mil{
		int MenorCienMil	 = 1;
	}

	public List <UACIRiesgosBean>listaReporteMenor100mil(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_CredMenor100Mil.excel:
				listaReportes = creditosMenor100DAO.reporteCredMenor100mil(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean MenorCienMil = null;
		switch (tipoConsulta) {
			case Enum_Con_CredMenor100Mil.MenorCienMil:	
				MenorCienMil = creditosMenor100DAO.consultaCredMenorCienMil(riesgosBean,tipoConsulta);
				break;									
		}				
		return MenorCienMil;
	}
	
	 /* ********************** GETTERS y SETTERS **************************** */
	public CreditosMenor100DAO getCreditosMenor100DAO() {
		return creditosMenor100DAO;
	}

	public void setCreditosMenor100DAO(CreditosMenor100DAO creditosMenor100DAO) {
		this.creditosMenor100DAO = creditosMenor100DAO;
	}

}
