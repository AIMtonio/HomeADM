package pld.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import pld.bean.MatrizRiesgoBean;
import pld.dao.MatrizRiesgoDAO;

public class MatrizRiesgoServicio extends BaseServicio {

	MatrizRiesgoDAO matrizRiesgoDAO=null;
	
	public MatrizRiesgoServicio(){
		super();
	}
	public static interface Enum_Con_MatrizRiesgo{
		int consultaPrincipal = 1;
	};
	
	public static interface Enum_Tran_MatrizRiesgo{
		int actualiza = 1;
		int evaluacion = 2;
	};
	
	public static interface Enum_Lis_MatrizRiesgo{
		int  principal = 1;
	};
	
	public MensajeTransaccionBean grabaTransaccion(MatrizRiesgoBean matrizRiesgoBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch(tipoTransaccion){
		case Enum_Tran_MatrizRiesgo.actualiza:
			mensaje = matrizRiesgoDAO.actualizaValoresRiesgo(matrizRiesgoBean);
			break;
		case Enum_Tran_MatrizRiesgo.evaluacion:
			mensaje = matrizRiesgoDAO.evaluacion(matrizRiesgoBean);
			break;
		}
		return mensaje;
	}
	
	public List lista(int tipoConsulta){		
		List listaConceptosRiesgo = null;
		switch (tipoConsulta) {
			case Enum_Lis_MatrizRiesgo.principal:		
				listaConceptosRiesgo =  matrizRiesgoDAO.listaPrincipal(Enum_Lis_MatrizRiesgo.principal);				
				break;				
		}
		return listaConceptosRiesgo;
	}

	public MatrizRiesgoDAO getMatrizRiesgoDAO() {
		return matrizRiesgoDAO;
	}

	public void setMatrizRiesgoDAO(MatrizRiesgoDAO matrizRiesgoDAO) {
		this.matrizRiesgoDAO = matrizRiesgoDAO;
	}
	
}