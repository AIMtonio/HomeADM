package nomina.servicio;

import java.util.List;
import nomina.bean.NomTipoClavePresupBean;
import nomina.dao.NomTipoClavePresupDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class NomTipoClavePresupServicio extends BaseServicio{
	NomTipoClavePresupDAO nomTipoClavePresupDAO = null;
	
	/* =====================================================================  */
	/* =====================================================================  */
	public NomTipoClavePresupServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public static interface Enum_Tra_TiposClavePresup{
		int bajaTipoClavePresup = 1;
		int altaTipoClavePresup = 2;
		int modTipoClavePresup = 3;
	}
		
	public static interface Enum_Lis_TiposClavePresup{
		int listaTipoClavePresup = 1;
		int listaCombTipoClavePresup = 2;
	}
	
	// Consulta de personas
	public static interface Enum_Con_TiposClaves {
		int conTipoClavPresup 		= 1;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,NomTipoClavePresupBean nomTipoClavePresupBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case (Enum_Tra_TiposClavePresup.bajaTipoClavePresup):	
				mensaje = nomTipoClavePresupDAO.tipoClavePresupBaja(nomTipoClavePresupBean,tipoTransaccion);
				break;		
			case (Enum_Tra_TiposClavePresup.altaTipoClavePresup):	
				mensaje = nomTipoClavePresupDAO.tipoClavePresupAlt(nomTipoClavePresupBean);
				break;		
			case (Enum_Tra_TiposClavePresup.modTipoClavePresup):	
				mensaje = nomTipoClavePresupDAO.tipoClavePresupMod(nomTipoClavePresupBean);
				break;	
		}
		return mensaje;
	}	

	/* =====================================================================  */
	/* =====================================================================  */
	
	public List lista(int tipoLista, NomTipoClavePresupBean nomTipoClavePresupBean){
		List listaResult = null;
		switch (tipoLista) {
        case  Enum_Lis_TiposClavePresup.listaTipoClavePresup:
        	listaResult = nomTipoClavePresupDAO.listaTiposClavePresup(nomTipoClavePresupBean,tipoLista);
        	break;    
        case  Enum_Lis_TiposClavePresup.listaCombTipoClavePresup:
        	listaResult = nomTipoClavePresupDAO.listaTiposClaveComb(nomTipoClavePresupBean,tipoLista);
        	break;  
		}
		return listaResult;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */
	public NomTipoClavePresupBean consulta(int tipoConsulta, NomTipoClavePresupBean nomTipoClavePresupBean) {
		NomTipoClavePresupBean consultaRetornada = null;
		
		switch (tipoConsulta) {
			case Enum_Con_TiposClaves.conTipoClavPresup:
				consultaRetornada =nomTipoClavePresupDAO.conTipoClavePresup(nomTipoClavePresupBean, tipoConsulta);
				break;
			}		
		return consultaRetornada;		
	}
	
	
	/* =====================================================================  */
	/* =====================================================================  */

	public NomTipoClavePresupDAO getNomTipoClavePresupDAO() {
		return nomTipoClavePresupDAO;
	}

	public void setNomTipoClavePresupDAO(NomTipoClavePresupDAO nomTipoClavePresupDAO) {
		this.nomTipoClavePresupDAO = nomTipoClavePresupDAO;
	}


}
