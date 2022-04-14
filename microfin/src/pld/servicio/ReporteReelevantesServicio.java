package pld.servicio;

import java.util.List;

import pld.bean.ReporteReelevantesBean;
import pld.bean.ReportesSITIBean;
import pld.dao.ReporteReelevantesDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class ReporteReelevantesServicio extends BaseServicio{

	private ReporteReelevantesServicio(){
		super();
	}
	
	ReporteReelevantesDAO reporteReelevantesDAO = null;
	
	
	public static interface Enum_Con_ReporteRee{
		int principal = 1;
		int foranea = 2;
		int nombArch =3;
		int arch= 4;
		int Genera=5;
	}
	
	public static interface Enum_Tra_ReporteRee {
		int generaNom = 1;
		int generaArch = 2;		
		
	}
	public static interface Enum_Con_ReelevantesArchivo{
		int principal   = 1;
	}
	public static interface Enum_Lis_ReelevantesArchivo{
		int excel   = 1;
	}
	
	public ReporteReelevantesBean consulta(int tipoConsulta, ReporteReelevantesBean reporteReelevantes){
		ReporteReelevantesBean reporteReelevantesBean = null;
		switch(tipoConsulta){
			case Enum_Con_ReporteRee.nombArch:
				reporteReelevantesBean = reporteReelevantesDAO.consultaNombArch(reporteReelevantes, Enum_Con_ReporteRee.nombArch);
			break;
			case Enum_Con_ReporteRee.arch:
				reporteReelevantesBean = reporteReelevantesDAO.consultaArch(reporteReelevantes, Enum_Con_ReporteRee.arch);
			break;
			case Enum_Con_ReporteRee.Genera:
				reporteReelevantesBean = reporteReelevantesDAO.consultaGeneraArch(reporteReelevantes, Enum_Con_ReporteRee.Genera);
			break;
		}
		return reporteReelevantesBean;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ReporteReelevantesBean reporteReelevantes){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_ReporteRee.generaArch:
				mensaje = generaArch(reporteReelevantes);				
				break;			
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean generaArch(ReporteReelevantesBean reporteReelevantes){
		MensajeTransaccionBean mensaje = null;
		mensaje = reporteReelevantesDAO.altaHistoricoGeneraReporte(  reporteReelevantes,   Enum_Con_ReelevantesArchivo.principal);		
		return mensaje;
	}
	
	/**
	 * Lista las operaciones para el reporte en excel.
	 * @param tipoLista : Número de Lista.
	 * @param reporteReelevantes : Clase bean con los parámetros de entrada a los SPs.
	 * @return List Lista con las operaciones a reportar como relevantes.
	 * @author avelasco
	 */
	public List lista(int tipoLista, ReportesSITIBean reporteReelevantes){		
		List listaRelevantes = null;
		switch (tipoLista) {
			case Enum_Lis_ReelevantesArchivo.excel:		
				listaRelevantes = reporteReelevantesDAO.listaReporteExcel(reporteReelevantes, tipoLista);				
				break;
		}		
		return listaRelevantes;
	}

	public ReporteReelevantesDAO getReporteReelevantesDAO() {
		return reporteReelevantesDAO;
	}

	public void setReporteReelevantesDAO(ReporteReelevantesDAO reporteReelevantesDAO) {
		this.reporteReelevantesDAO = reporteReelevantesDAO;
	}

	
}
