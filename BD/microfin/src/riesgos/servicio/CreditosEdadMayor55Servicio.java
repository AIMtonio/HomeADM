package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.CreditosEdadMayor55DAO;
import general.servicio.BaseServicio;

public class CreditosEdadMayor55Servicio extends BaseServicio{
	CreditosEdadMayor55DAO creditosEdadMayor55DAO = null;
	
	public CreditosEdadMayor55Servicio (){
		super();
	}

	 /* ==== Tipo de Lista para Créditos Mayor 55 Años  ==== */
	public static interface Enum_Lis_CredEdadMayor55 {
		int excel	 = 1;
	}

	/* == Tipo de Consulta para Créditos Mayor 55 Años ==== */
	public static interface Enum_Con_CredEdadMayor55 {
		int mayor55Años	 = 1;
	}
	
	public List <UACIRiesgosBean>listaReporteCredEdadMayor55(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_CredEdadMayor55.excel:
				listaReportes = creditosEdadMayor55DAO.reporteCredEdadMayor55(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean mayor55Años = null;
		switch (tipoConsulta) {
			case Enum_Con_CredEdadMayor55.mayor55Años:	
				mayor55Años = creditosEdadMayor55DAO.consultaCredMayor55Años(riesgosBean,tipoConsulta);
				break;									
		}				
		return mayor55Años;
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public CreditosEdadMayor55DAO getCreditosEdadMayor55DAO() {
		return creditosEdadMayor55DAO;
	}

	public void setCreditosEdadMayor55DAO(
			CreditosEdadMayor55DAO creditosEdadMayor55DAO) {
		this.creditosEdadMayor55DAO = creditosEdadMayor55DAO;
	}
	
}
