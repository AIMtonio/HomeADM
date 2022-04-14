package originacion.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import originacion.bean.InconsistenciasBean;
import originacion.dao.InconsistenciasDAO;


public class InconsistenciasServicio extends BaseServicio{
	
	InconsistenciasDAO inconsistenciasDAO;

	private InconsistenciasServicio(){
		super();
	}
	
	public static interface Enum_Transaccion {
		int alta = 1;		// Alta de Inconsistencias
		int modifica = 2;	// Modificación de Inconsistencias
		int elimina = 3;	// Elimina 
	}
	
	public static interface Enum_Consulta {
		int principal = 1;	// Consulta las Inconsistencias de un Cliente, Aval o Prospecto
	}
	
	public static interface Enum_Lista{
	}
	
	
	/**
	 * @param tipoTransaccion: Alta o Modificación de Inconsistencias
	 * @param inconsistenciasBeam
	 * @return
	 */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, InconsistenciasBean inconsistenciasBean) {
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Transaccion.alta:
			mensaje = inconsistenciasDAO.alta(inconsistenciasBean);
			break;
		case Enum_Transaccion.modifica:
			mensaje = inconsistenciasDAO.modifica(inconsistenciasBean);
			break;
		case Enum_Transaccion.elimina:
			mensaje = inconsistenciasDAO.elimina(inconsistenciasBean);
			break;
	
		}
		return mensaje;
	}
	
	/**
	 * 
	 * @param tipoConsulta: Método para consultar las inconsistencias de CLIENTES, PROSPECTOS, AVALES Y GARANTES
	 * @param esquemaOtrosAccesorios
	 * @return
	 */
	public InconsistenciasBean consulta(int tipoConsulta, InconsistenciasBean inconsistencias){
		InconsistenciasBean inconsistenciasCon = null;
		try{
			switch(tipoConsulta){
			case Enum_Consulta.principal:
				inconsistenciasCon = inconsistenciasDAO.consulta(inconsistencias,tipoConsulta);
			break;		
			}
		}catch(Exception e){
			e.printStackTrace();
			return null;
		}
		
		return inconsistenciasCon;
	}
	

	public InconsistenciasDAO getInconsistenciasDAO() {
		return inconsistenciasDAO;
	}

	public void setInconsistenciasDAO(InconsistenciasDAO inconsistenciasDAO) {
		this.inconsistenciasDAO = inconsistenciasDAO;
	}




}
