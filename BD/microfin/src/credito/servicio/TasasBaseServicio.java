package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.TasasBaseBean;
import credito.dao.TasasBaseDAO;

public class TasasBaseServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	TasasBaseDAO tasasBaseDAO = null;

	//---------- Tipos de transacciones---------------------------------------------------------------
	public static interface Enum_Tra_TasasBase {
		int alta   = 1;
		int modificacion =2;
		int actualiza = 3;
	}
	public static interface Enum_Con_TasasBase {
		int principal   = 1;
		int mesAnterior = 2;
		int ultimoReg = 3;
	}
	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_TasasBase {
		int tasasBase   = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TasasBaseBean tasasBase){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_TasasBase.alta:
			mensaje = tasasBaseDAO.altaTasaBase(tasasBase);
			break;
		case Enum_Tra_TasasBase.modificacion:
			
			mensaje = tasasBaseDAO.modificaTasaBase(tasasBase);
			break;			
		case Enum_Tra_TasasBase.actualiza:
			
			mensaje = tasasBaseDAO.actualizaValTB(tasasBase);//tipoActualizacion
			break;
		
		}

		return mensaje;
	}
	public TasasBaseBean consulta(int tipoConsulta, TasasBaseBean tasasBase){
		TasasBaseBean tasasBaseBean = null;
		switch(tipoConsulta){
			case Enum_Con_TasasBase.principal:
				tasasBaseBean = tasasBaseDAO.consultaPrincipal(tasasBase, Enum_Con_TasasBase.principal);
			break;
			case Enum_Con_TasasBase.mesAnterior:
				tasasBaseBean = tasasBaseDAO.consultaTasaHist(tasasBase, Enum_Con_TasasBase.mesAnterior);
			break;
			case Enum_Con_TasasBase.ultimoReg:
				tasasBaseBean = tasasBaseDAO.consultaTasaHist(tasasBase, Enum_Con_TasasBase.ultimoReg);
			break;
		}
		return tasasBaseBean;
	}

	public List lista(int tipoLista, TasasBaseBean tasasBase){
		List tasasBaseLista = null;

		switch (tipoLista) {
	        case  Enum_Lis_TasasBase.tasasBase:
				tasasBaseLista = tasasBaseDAO.listaTasasBase(tasasBase, tipoLista);
	        break;
	        
		}
		return tasasBaseLista;
	}
	
	
	//------------------ Geters y Seters --------------------------------------------
	public void setTasasBaseDAO(TasasBaseDAO tasasBaseDAO) {
		this.tasasBaseDAO = tasasBaseDAO;
	}
	

}
