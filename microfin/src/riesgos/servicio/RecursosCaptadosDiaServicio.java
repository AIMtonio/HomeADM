package riesgos.servicio;

import java.util.List;

import javax.servlet.http.HttpServletResponse;

import riesgos.bean.UACIRiesgosBean;
import riesgos.dao.RecursosCaptadosDiaDAO;
import general.servicio.BaseServicio;

public class RecursosCaptadosDiaServicio extends BaseServicio {
	RecursosCaptadosDiaDAO recursosCaptadosDiaDAO = null;
	
	public RecursosCaptadosDiaServicio() {
		super();
	}
	
	 /* ======== Tipo de Lista para Recursos Captados al Dia ======= */
	public static interface Enum_Lis_CaptadoDia	{
		int recCaptadosDiaExcel	 = 1;
	}

	 /* ======== Tipo de Consulta para Recursos Captados al Dia ======= */
	public static interface Enum_Con_CaptadosDia	{
		int recCaptadosDia	 = 1;
	}
		
	public List <UACIRiesgosBean>listaReporteCaptadosDia(int tipoLista, UACIRiesgosBean riesgosBean, HttpServletResponse response){
		List<UACIRiesgosBean> listaReportes = null;
		switch(tipoLista){
			case Enum_Lis_CaptadoDia.recCaptadosDiaExcel:
				listaReportes = recursosCaptadosDiaDAO.reporteCaptadosDia(riesgosBean, tipoLista); 
				break;	
		}
		return listaReportes;
	}
	
	public UACIRiesgosBean consulta(int tipoConsulta, UACIRiesgosBean riesgosBean){
		UACIRiesgosBean riesgosCaptados = null;
		switch (tipoConsulta) {
			case Enum_Con_CaptadosDia.recCaptadosDia:	
				riesgosCaptados = recursosCaptadosDiaDAO.consultaRecursoCaptadoDia(riesgosBean,tipoConsulta);
				break;									
		}				
		return riesgosCaptados;
	}
	
	 /* ********************** GETTERS y SETTERS **************************** */
	public RecursosCaptadosDiaDAO getRecursosCaptadosDiaDAO() {
		return recursosCaptadosDiaDAO;
	}

	public void setRecursosCaptadosDiaDAO(
			RecursosCaptadosDiaDAO recursosCaptadosDiaDAO) {
		this.recursosCaptadosDiaDAO = recursosCaptadosDiaDAO;
	}

}
