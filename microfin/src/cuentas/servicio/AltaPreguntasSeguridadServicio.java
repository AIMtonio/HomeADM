package cuentas.servicio;

import java.util.List;

import cuentas.bean.AltaPreguntasSeguridadBean;
import cuentas.dao.AltaPreguntasSeguridadDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class AltaPreguntasSeguridadServicio extends BaseServicio{

	AltaPreguntasSeguridadDAO altaPreguntasSeguridadDAO = null;
	
	private AltaPreguntasSeguridadServicio (){
		super();
	}
	
	// Consulta de Preguntas de Seguridad
	public static interface Enum_Con_AltaPreguntas {
		int principal = 1;
	}
	
	// Lista de Preguntas de Seguridad
	public static interface Enum_Lis_ListaPreguntas {
		int principal = 1;	
	}
	
	// Transaccion de Preguntas de Seguridad
	public static interface Enum_Tra_AltaPreguntas {
		int alta = 1;		
	}
	
	// Transacciones Preguntas de Seguridad
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,AltaPreguntasSeguridadBean altaPreguntasSeguridadBean) { 
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_AltaPreguntas.alta:
			mensaje = altaPreguntasSeguridadDAO.altaPreguntasSeguridad(altaPreguntasSeguridadBean);
			break;
		}
		return mensaje;
	}
	
	// Consulta de Preguntas de Seguridad
	public AltaPreguntasSeguridadBean consulta(int tipoConsulta, AltaPreguntasSeguridadBean altaPreguntasSeguridadBean){
		AltaPreguntasSeguridadBean consultaPregunta = null;
		switch (tipoConsulta) {
		case Enum_Con_AltaPreguntas.principal:
			consultaPregunta = altaPreguntasSeguridadDAO.consultaPrincipal(altaPreguntasSeguridadBean, tipoConsulta);
			break;
		}		
		return consultaPregunta;
	}
	
	// Lista de Preguntas de Seguridad
	public List lista(int tipoLista, AltaPreguntasSeguridadBean altaPreguntasSeguridadBean) {
		List listaPregunta = null;
		switch (tipoLista) {
		case Enum_Lis_ListaPreguntas.principal:
			listaPregunta = altaPreguntasSeguridadDAO.listaPrincipal(altaPreguntasSeguridadBean, tipoLista);
			break;	

		}
		return listaPregunta;
	}
	
	
	// ---------------  GETTER y SETTER -------------------- 
	public AltaPreguntasSeguridadDAO getAltaPreguntasSeguridadDAO() {
		return altaPreguntasSeguridadDAO;
	}

	public void setAltaPreguntasSeguridadDAO(
			AltaPreguntasSeguridadDAO altaPreguntasSeguridadDAO) {
		this.altaPreguntasSeguridadDAO = altaPreguntasSeguridadDAO;
	}
	
}
