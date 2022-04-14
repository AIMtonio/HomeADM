package contabilidad.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import contabilidad.bean.EjercicioContableBean;
import contabilidad.bean.PeriodoContableBean;
import contabilidad.dao.EjercicioContableDAO;


public class EjercicioContableServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	EjercicioContableDAO ejercicioContableDAO = null;

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_EjercicioConta {
		int ejercicio = 2;
		int vigente = 1;
	}

	public static interface Enum_Lis_EjercicioConta {
		int principal = 1;
	}

	
	public EjercicioContableServicio() {
		super();
	}
	
	//---------- Transacciones ------------------------------------------------------------------------------
	
	public EjercicioContableBean consulta(int tipoConsulta, EjercicioContableBean ejercicioContableBean){
		EjercicioContableBean ejercicioContable = null;
		switch (tipoConsulta) {
			case Enum_Con_EjercicioConta.vigente:
				ejercicioContable = ejercicioContableDAO.consultaEjercicioVigente(ejercicioContableBean,tipoConsulta);
				break;
			case Enum_Con_EjercicioConta.ejercicio:
				ejercicioContable = ejercicioContableDAO.consultaEjercicio(ejercicioContableBean,tipoConsulta);
				break;
		}		
		return ejercicioContable;
	}

	public MensajeTransaccionBean grabaEjercicioYPeriodos(EjercicioContableBean ejercicioContableBean,
														  String iniciosPeriodo,
														  String finesPeriodo){

		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		ArrayList listaPeriodos = (ArrayList) creaListaPeriodos(ejercicioContableBean, iniciosPeriodo, finesPeriodo);
		mensaje = ejercicioContableDAO.grabaEjercicioPeriodos(ejercicioContableBean, listaPeriodos);
		return mensaje;		
	}
	
	private List creaListaPeriodos(EjercicioContableBean ejercicioContableBean,
									String iniciosPeriodo,
									String finesPeriodo){

		StringTokenizer tokensInicio = new StringTokenizer(iniciosPeriodo, ",");
		StringTokenizer tokensFin = new StringTokenizer(finesPeriodo, ",");
		ArrayList listaPeriodos = new ArrayList();
		PeriodoContableBean periodoBean;
	
		String periodosInicio[] = new String[tokensInicio.countTokens()];
		String periodosFin[] = new String[tokensFin.countTokens()];
		
		int i=0;		
	
		while(tokensInicio.hasMoreTokens()){
			periodosInicio[i] = String.valueOf(tokensInicio.nextToken());
			i++;
		}
		i=0;
		while(tokensFin.hasMoreTokens()){
			periodosFin[i] = String.valueOf(tokensFin.nextToken());
			i++;
		}
	
		for(int contador=0; contador < periodosInicio.length; contador++){			
			periodoBean = new PeriodoContableBean();
			periodoBean.setTipoPeriodo(ejercicioContableBean.getTipoPeriodo());
			periodoBean.setInicioPeriodo(periodosInicio[contador]);
			periodoBean.setFinPeriodo(periodosFin[contador]);
			listaPeriodos.add(periodoBean);
		}
		return listaPeriodos;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaEjercicioContable = null;
		switch(tipoLista){
			case (Enum_Lis_EjercicioConta.principal): 
				listaEjercicioContable =  ejercicioContableDAO.listaPorEjercicio(tipoLista);
				break;
			
		}
		return listaEjercicioContable.toArray();		
	}
	//---------- Setters y Getters ------------------------------------------------------------------------------	
	public void setEjercicioContableDAO(EjercicioContableDAO ejercicioContableDAO) {
		this.ejercicioContableDAO = ejercicioContableDAO;
	}
	
	
}
