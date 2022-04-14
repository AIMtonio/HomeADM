package nomina.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import nomina.bean.NomClavePresupBean;
import nomina.dao.NomClavePresupDAO;

public class NomClavePresupServicio  extends BaseServicio{
	NomClavePresupDAO nomClavePresupDAO = null;
	
	/* =====================================================================  */
	/* =====================================================================  */
	public NomClavePresupServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public static interface Enum_Tra_ClavePresup{
		int altaClavePresup = 1;
		int altaClasifClavePresup = 2;
		int modificaClasifClavePresup = 3;

	}
	
	public static interface Enum_Lis_ClavePresup{
		int listaClavePresup = 1;
		int listaClavePresupCombo = 2;
		int listaClavePresupGrid = 3;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,NomClavePresupBean nomClavePresupBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case (Enum_Tra_ClavePresup.altaClavePresup):	
				mensaje = nomClavePresupDAO.altaClavePresup(nomClavePresupBean);
				break;		
			case (Enum_Tra_ClavePresup.altaClasifClavePresup):	
				mensaje = nomClavePresupDAO.altaClasifClavePresup(nomClavePresupBean);
				break;	
			case (Enum_Tra_ClavePresup.modificaClasifClavePresup):	
				mensaje = nomClavePresupDAO.modClasifClavePresup(nomClavePresupBean);
				break;	
		}
		return mensaje;
	}	

	/* =====================================================================  */
	/* =====================================================================  */
	
	public List lista(int tipoLista, NomClavePresupBean nomClavePresupBean){
		List listaResult = null;
		switch (tipoLista) {
        case  Enum_Lis_ClavePresup.listaClavePresup:
        	listaResult = nomClavePresupDAO.listaClavePresup(nomClavePresupBean, tipoLista);
        	break;      
        case  Enum_Lis_ClavePresup.listaClavePresupCombo:
        	listaResult = nomClavePresupDAO.listaClavePresupCombo(nomClavePresupBean, tipoLista);
        	break;  
        case  Enum_Lis_ClavePresup.listaClavePresupGrid:
        	listaResult = nomClavePresupDAO.listaClavePresupGrid(nomClavePresupBean, tipoLista);
        	break; 
		}
		return listaResult;
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public NomClavePresupDAO getNomClavePresupDAO() {
		return nomClavePresupDAO;
	}

	public void setNomClavePresupDAO(NomClavePresupDAO nomClavePresupDAO) {
		this.nomClavePresupDAO = nomClavePresupDAO;
	}
	

}
