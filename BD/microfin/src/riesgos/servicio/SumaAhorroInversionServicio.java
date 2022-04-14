package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.SumaAhorroInversionDAO;
import general.servicio.BaseServicio;

public class SumaAhorroInversionServicio extends BaseServicio{
	SumaAhorroInversionDAO sumaAhorroInversionDAO = null;
	
	public SumaAhorroInversionServicio (){
		super ();
	}
	/* ====== Tipo de Lista para Suma de Ahorro Inversion ======= */
	public static interface Enum_Lis_SumAhorroInversion	{
		int excel	 = 1;
	}

	/* == Tipo de Consulta para Suma de Ahorro Inversion ==== */
	public static interface Enum_Con_SumAhorroInversion {
		int sumaAhorroInversion	 = 1;
	}
	
	public List <UACIRiesgosBean>listaReporteSumaAhorroInversion(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_SumAhorroInversion.excel:
				listaReportes = sumaAhorroInversionDAO.reporteSumaAhorroInversion(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean sumAhoInve = null;
		switch (tipoConsulta) {
			case Enum_Con_SumAhorroInversion.sumaAhorroInversion:	
				sumAhoInve = sumaAhorroInversionDAO.consultaSumaAhorroInversion(riesgosBean,tipoConsulta);
				break;									
		}				
		return sumAhoInve;
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public SumaAhorroInversionDAO getSumaAhorroInversionDAO() {
		return sumaAhorroInversionDAO;
	}

	public void setSumaAhorroInversionDAO(
			SumaAhorroInversionDAO sumaAhorroInversionDAO) {
		this.sumaAhorroInversionDAO = sumaAhorroInversionDAO;
	}

}
