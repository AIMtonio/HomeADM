package seguimiento.servicio;

import seguimiento.bean.ResultadoSegtoCobranzaBean;
import seguimiento.dao.ResultadoSegtoCobranzaDAO;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ResultadoSegtoCobranzaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	ResultadoSegtoCobranzaDAO resultadoSegtoCobranzaDAO = null;



	//consulta principal
	public static interface Enum_Con_Seguimiento {
		int principal   = 1;
	}
	
	public static interface Enum_Tra_Seguimiento {
		int alta = 1;
		int modificacion = 2;
	}

	public ResultadoSegtoCobranzaServicio(){
	
		super();
	} 
	// TODO Auto-generated constructor stub
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ResultadoSegtoCobranzaBean  resultadoBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_Seguimiento.alta:
			mensaje = alta(resultadoBean);
			break; 
		case Enum_Tra_Seguimiento.modificacion:
			mensaje = modifica(resultadoBean);
			break;
		}

		return mensaje;
	}

		// TODO Auto-generated method stub

	
	public MensajeTransaccionBean alta(ResultadoSegtoCobranzaBean resultadoBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = resultadoSegtoCobranzaDAO.alta(resultadoBean);	
		return mensaje;
	}

	public MensajeTransaccionBean modifica(ResultadoSegtoCobranzaBean seguimiento){
		MensajeTransaccionBean mensaje = null;
		mensaje = resultadoSegtoCobranzaDAO.modifica(seguimiento);		
		return mensaje;
	}



	public ResultadoSegtoCobranzaBean consultaPrincipal(int tipoConsulta, ResultadoSegtoCobranzaBean seguimiento){
		ResultadoSegtoCobranzaBean resultadoSegtoCobranzaBean = null;
		switch(tipoConsulta){
			case Enum_Con_Seguimiento.principal:
				resultadoSegtoCobranzaBean = resultadoSegtoCobranzaDAO.consultaPrincipal(seguimiento, Enum_Con_Seguimiento.principal);
			break;
			
		}
		return resultadoSegtoCobranzaBean;
	}
	
	
		//------------------ Geters y Seters ------------------------------------------------------	
	
	public ResultadoSegtoCobranzaDAO getResultadoSegtoCobranzaDAO() {
		return resultadoSegtoCobranzaDAO;
	}


	public void setResultadoSegtoCobranzaDAO(
			ResultadoSegtoCobranzaDAO resultadoSegtoCobranzaDAO) {
		this.resultadoSegtoCobranzaDAO = resultadoSegtoCobranzaDAO;
	}
}