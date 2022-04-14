package contabilidad.servicio;
import java.util.List;

import contabilidad.bean.EjercicioContableBean;
import contabilidad.bean.PeriodoContableBean;
import contabilidad.dao.PeriodoContableDAO;
import contabilidad.servicio.ConceptoContableServicio.Enum_Lis_ConceptoConta;
import contabilidad.servicio.EjercicioContableServicio.Enum_Con_EjercicioConta;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class PeriodoContableServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	PeriodoContableDAO periodoContableDAO  = null;

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Tra_PeriodoConta {
		int cierre 	= 3;
	}
	public static interface Enum_Con_PeriodoConta {
		int principal   = 1;
		int vigente 	= 2;
		int foranea 	= 3;
		int estatus 	= 4;
		int fecha		= 5;
		int ejercicio	= 6;
	}

	public static interface Enum_Lis_PeriodoConta {
		int principal = 1;
		int porPeriodo = 2;
		int foranea = 3;
		int porCerrar = 4;
		int cerrado = 5;
	}
	
	public PeriodoContableServicio() {
		super();
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PeriodoContableBean periodoContableBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_PeriodoConta.cierre:
			mensaje = periodoContableDAO.cierrePeriodo(periodoContableBean);
			break;
		}
		return mensaje;
	}

	public List lista(int tipoLista, PeriodoContableBean periodoContableBean){
		List listaConceptos = null;
		switch (tipoLista) {
			case Enum_Lis_ConceptoConta.principal:
				listaConceptos = periodoContableDAO.listaPrincipal(periodoContableBean, tipoLista);				
				break;	
			case Enum_Lis_PeriodoConta.porPeriodo:
				listaConceptos = periodoContableDAO.listaPorPeriodo(periodoContableBean, tipoLista);				
				break;		
			case Enum_Lis_PeriodoConta.foranea:
				listaConceptos = periodoContableDAO.listaForanea(periodoContableBean, tipoLista);				
				break;		
		}		
		return listaConceptos;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(PeriodoContableBean periodoContableBean,int tipoLista) {
		List listaPeriodoContable = null;
		switch(tipoLista){
			case (Enum_Lis_PeriodoConta.porCerrar): 
				listaPeriodoContable =  periodoContableDAO.listaPorPeriodoNoCerrado(periodoContableBean, tipoLista);
				break;
			case (Enum_Lis_PeriodoConta.cerrado): 
				listaPeriodoContable =  periodoContableDAO.listaPorPeriodoNoCerrado(periodoContableBean, tipoLista);
				break;
		}
		return listaPeriodoContable.toArray();		
	}
	
	public PeriodoContableBean consulta(int tipoConsulta, PeriodoContableBean periodoContableBean){
		PeriodoContableBean periodoContable = null;
		switch (tipoConsulta) {
			case Enum_Con_PeriodoConta.foranea:
				periodoContable = periodoContableDAO.consultaForanea(periodoContableBean,tipoConsulta);
				break;
			case Enum_Con_PeriodoConta.estatus:
				periodoContable = periodoContableDAO.consultaEstatus(periodoContableBean,tipoConsulta);
				break;
			case Enum_Con_PeriodoConta.fecha:
				periodoContable = periodoContableDAO.consultaFechaVig(periodoContableBean, tipoConsulta);
				break;
			case Enum_Con_PeriodoConta.ejercicio:
				periodoContable = periodoContableDAO.consultaEjercicio(periodoContableBean, tipoConsulta);
				break;
		}		
		return periodoContable;
	}

	
	//---------- Transacciones ------------------------------------------------------------------------------
	
	//---------- Setters y Getters --------------------------------------------------------------------------
	public void setPeriodoContableDAO(PeriodoContableDAO periodoContableDAO) {
		this.periodoContableDAO = periodoContableDAO;
	}
	
	
}
