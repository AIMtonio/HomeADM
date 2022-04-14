package nomina.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import java.util.List;
import nomina.bean.NomClasifClavePresupBean;
import nomina.bean.NomTipoClavePresupBean;
import nomina.dao.NomClasifClavePresupDAO;
import nomina.servicio.NomTipoClavePresupServicio.Enum_Con_TiposClaves;

public class NomClasifClavePresupServicio  extends BaseServicio{
	NomClasifClavePresupDAO nomClasifClavePresupDAO = null;
	
	/* =====================================================================  */
	/* =====================================================================  */
	public NomClasifClavePresupServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public static interface Enum_Tra_ClasifClavePresup{

	}
	
	public static interface Enum_Lis_ClasifClavePresup{
		int listaClasifClavePresup = 1;
		int listaClasifClavePresupComb = 2;
		int listaClavePresup = 3;
		int listaClavPresupConv = 4;
	}
	
	// Consulta de personas
	public static interface Enum_Con_ClasifClav {
		int conTipoClavPresup 		= 1;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,NomClasifClavePresupBean nomClasifClavePresupBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
	
		}
		return mensaje;
	}	

	/* =====================================================================  */
	/* =====================================================================  */
	
	public List lista(int tipoLista, NomClasifClavePresupBean nomClasifClavePresupBean){
		List listaResult = null;
		switch (tipoLista) {
        case  Enum_Lis_ClasifClavePresup.listaClasifClavePresup:
        	listaResult = nomClasifClavePresupDAO.listaClasifClavePresup(nomClasifClavePresupBean, tipoLista);
        	break;      
        	
        case  Enum_Lis_ClasifClavePresup.listaClasifClavePresupComb:
        	listaResult = nomClasifClavePresupDAO.listaClasifClaveCombo(nomClasifClavePresupBean, tipoLista);
        	break;   
        case  Enum_Lis_ClasifClavePresup.listaClavePresup:
        	listaResult = nomClasifClavePresupDAO.listaClasifClave(nomClasifClavePresupBean, tipoLista);
        	break;   
        case  Enum_Lis_ClasifClavePresup.listaClavPresupConv:
        	listaResult = nomClasifClavePresupDAO.listaClavPresupConv(nomClasifClavePresupBean, tipoLista);
        	break;   
        	
		}
		return listaResult;
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public NomClasifClavePresupBean consulta(int tipoConsulta, NomClasifClavePresupBean nomClasifClavePresupBean) {
		NomClasifClavePresupBean consultaRetornada = null;
		
		switch (tipoConsulta) {
			case Enum_Con_ClasifClav.conTipoClavPresup:
				consultaRetornada = nomClasifClavePresupDAO.conClasifClavePresup(nomClasifClavePresupBean, tipoConsulta);
				break;
			}		
		return consultaRetornada;		
	}
	

	/* =====================================================================  */
	/* =====================================================================  */

	public NomClasifClavePresupDAO getNomClasifClavePresupDAO() {
		return nomClasifClavePresupDAO;
	}

	public void setNomClasifClavePresupDAO(
			NomClasifClavePresupDAO nomClasifClavePresupDAO) {
		this.nomClasifClavePresupDAO = nomClasifClavePresupDAO;
	}


}
