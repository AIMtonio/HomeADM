package bancaMovil.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import bancaMovil.bean.BAMPregutaSecretaBean;
import bancaMovil.dao.BAMPreguntaSecretaDAO;



public class BAMPreguntaSecretaServicio extends BaseServicio{

	BAMPreguntaSecretaDAO preguntaDAO = null;

	public static interface Enum_Tra_Pregunta {
		int alta		 = 1;
		int modificacion = 2;
	}

	public static interface Enum_Con_Pregunta{
		int principal 		= 1;
	}

	public static interface Enum_Lis_Pregunta {
		int principal 		= 1;	
	}
	
	public BAMPreguntaSecretaServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, BAMPregutaSecretaBean pregunta){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
		case Enum_Tra_Pregunta.alta:		
			mensaje = altaPregunta(pregunta);				
			break;

		case Enum_Tra_Pregunta.modificacion:		
			mensaje = modificaPregunta(pregunta);				
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean altaPregunta(BAMPregutaSecretaBean pregunta){
		MensajeTransaccionBean mensaje = null;
		mensaje = preguntaDAO.altaPregunta(pregunta);		
		return mensaje;
	}


	public MensajeTransaccionBean modificaPregunta(BAMPregutaSecretaBean pregunta){
		MensajeTransaccionBean mensaje = null;
		mensaje = preguntaDAO.modificaPregunta(pregunta);		
		return mensaje;
	}


	public BAMPregutaSecretaBean consulta(int tipoConsulta, String preguntaID){
		BAMPregutaSecretaBean pregunta = null;
		switch (tipoConsulta) {
		case Enum_Con_Pregunta.principal:		
			pregunta = preguntaDAO.consultaPrincipal(Utileria.convierteEntero(preguntaID));				
			break;		
		}
		if(pregunta!=null){
			pregunta.setPreguntaSecretaID(Utileria.completaCerosIzquierda(pregunta.getPreguntaSecretaID(), 3));
		}

		return pregunta;
	}



	public List lista(int tipoLista, BAMPregutaSecretaBean pregunta){		
		List listaPreguntas = null;
		switch (tipoLista) {
		case Enum_Lis_Pregunta.principal:		
			listaPreguntas= preguntaDAO.listaPrincipal(pregunta);				
			break;
		}
		return listaPreguntas;
	}


	public BAMPreguntaSecretaDAO getPreguntaDAO() {
		return preguntaDAO;
	}


	public void setPreguntaDAO(BAMPreguntaSecretaDAO preguntaDAO) {
		this.preguntaDAO = preguntaDAO;
	}



	
}
