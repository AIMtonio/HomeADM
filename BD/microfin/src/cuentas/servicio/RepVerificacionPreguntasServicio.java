package cuentas.servicio;

import general.servicio.BaseServicio;
import java.util.List;

import cuentas.bean.RepVerificacionPreguntasBean;
import cuentas.dao.RepVerificacionPreguntasDAO;

public class RepVerificacionPreguntasServicio extends BaseServicio{
	
	RepVerificacionPreguntasDAO repVerificacionPreguntasDAO = null;
	
	private RepVerificacionPreguntasServicio () {
		super();
	}

	public static interface Enum_Rep_VerificaPregunta{
		int excel = 1;		// Reporte Verificacion de Preguntas en Excel
	}
	
	// Reporte Verificacion de Preguntas en Excel
	public List listaVerificacionPreguntas(int tipoLista,RepVerificacionPreguntasBean repVerificacionPreguntasBean){		
		List listaVerificacion = null;
		switch(tipoLista){
		case Enum_Rep_VerificaPregunta.excel:
			listaVerificacion = repVerificacionPreguntasDAO.reporteVerificacionPreguntas(tipoLista,repVerificacionPreguntasBean);
			break;
		}
		return listaVerificacion;
	}
	
	// ================ GETTER Y SETTER ============== //
	
	public RepVerificacionPreguntasDAO getRepVerificacionPreguntasDAO() {
		return repVerificacionPreguntasDAO;
	}

	public void setRepVerificacionPreguntasDAO(
			RepVerificacionPreguntasDAO repVerificacionPreguntasDAO) {
		this.repVerificacionPreguntasDAO = repVerificacionPreguntasDAO;
	}
	
}
