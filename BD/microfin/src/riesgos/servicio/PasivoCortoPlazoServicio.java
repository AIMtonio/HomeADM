package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.PasivoCortoPlazoDAO;
import general.servicio.BaseServicio;

public class PasivoCortoPlazoServicio extends BaseServicio{
	PasivoCortoPlazoDAO pasivoCortoPlazoDAO = null;
	
	public PasivoCortoPlazoServicio (){
		super ();
	}

	/* ======== Tipo de Lista para Pasivo a Corto Plazo ======= */
	public static interface Enum_Lis_PasivoCortoPlazo {
		int excel	 = 1;
	}
	
	/* == Tipo de Consulta para Pasivo a Corto Plazo ==== */
	public static interface Enum_Con_PasivoCortoPlazo {
		int pasivoCortoPlazo	 = 1;
	}

	public List <UACIRiesgosBean>listaReportePasivoCortoPlazo(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_PasivoCortoPlazo.excel:
				listaReportes = pasivoCortoPlazoDAO.reportePasivoCortoPlazo(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean pasivoCortoPlazo = null;
		switch (tipoConsulta) {
			case Enum_Con_PasivoCortoPlazo.pasivoCortoPlazo:	
				pasivoCortoPlazo = pasivoCortoPlazoDAO.consultaPasivoCortoPlazo(riesgosBean,tipoConsulta);
				break;									
		}				
		return pasivoCortoPlazo;
	}
	
	/* ****************** GETTER Y SETTERS *************************** */
	public PasivoCortoPlazoDAO getPasivoCortoPlazoDAO() {
		return pasivoCortoPlazoDAO;
	}

	public void setPasivoCortoPlazoDAO(PasivoCortoPlazoDAO pasivoCortoPlazoDAO) {
		this.pasivoCortoPlazoDAO = pasivoCortoPlazoDAO;
	}

}
