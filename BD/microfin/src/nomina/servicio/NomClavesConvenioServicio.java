package nomina.servicio;

import java.util.List;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import nomina.bean.NomClavesConvenioBean;
import nomina.dao.NomClavesConvenioDAO;

public class NomClavesConvenioServicio extends BaseServicio{
	NomClavesConvenioDAO nomClavesConvenioDAO = null;
	
	/* =====================================================================  */
	/* =====================================================================  */
	public NomClavesConvenioServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public static interface Enum_Tra_ClavePresupCoven{
		int bajaClavePresupConv = 1;
		int altaClavePresupConv = 2;
		int modClavePresupConv  = 3;
	}
	
	public static interface Enum_Lis_ClavePresupCove{
		int listaClavePresupConv = 1;
		int listaClavePresupCombo = 2;
		int listaClasiClavPresupConv = 3;
	}
	
	// Consulta de personas
	public static interface Enum_Con_ClavePresupCove {
		int conClavPresupConv		= 1;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,NomClavesConvenioBean nomClavesConvenioBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case (Enum_Tra_ClavePresupCoven.bajaClavePresupConv):	
				mensaje = nomClavesConvenioDAO.clavePresupConvBaja(nomClavesConvenioBean,tipoTransaccion);
				break;		
			case (Enum_Tra_ClavePresupCoven.altaClavePresupConv):	
				mensaje = nomClavesConvenioDAO.clavePorConvAlt(nomClavesConvenioBean);
				break;	
			case (Enum_Tra_ClavePresupCoven.modClavePresupConv):	
				mensaje = nomClavesConvenioDAO.clavePorConvMod(nomClavesConvenioBean);
				break;	
		}
		return mensaje;
	}	

	/* =====================================================================  */
	/* =====================================================================  */
	
	public List lista(int tipoLista, NomClavesConvenioBean nomClavesConvenioBean){
		List listaResult = null;
		switch (tipoLista) {
			case  Enum_Lis_ClavePresupCove.listaClavePresupConv:
				listaResult = nomClavesConvenioDAO.listaClavePresupConv(nomClavesConvenioBean, tipoLista);
				break;  
			case  Enum_Lis_ClavePresupCove.listaClavePresupCombo:
				listaResult = nomClavesConvenioDAO.listaClavePresupCombo(nomClavesConvenioBean, tipoLista);
				break;  
			case  Enum_Lis_ClavePresupCove.listaClasiClavPresupConv:
				listaResult = nomClavesConvenioDAO.listaClasiClavPresupConv(nomClavesConvenioBean, tipoLista);
				break;  
		}
		return listaResult;
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public NomClavesConvenioBean consulta(int tipoConsulta, NomClavesConvenioBean nomClavesConvenioBean) {
		NomClavesConvenioBean consultaRetornada = null;
		
		switch (tipoConsulta) {
			case Enum_Con_ClavePresupCove.conClavPresupConv:
				consultaRetornada =nomClavesConvenioDAO.conClavePresupConv(nomClavesConvenioBean, tipoConsulta);
				break;
			}		
		return consultaRetornada;		
	}

	/* =====================================================================  */
	/* =====================================================================  */
	
	public NomClavesConvenioDAO getNomClavesConvenioDAO() {
		return nomClavesConvenioDAO;
	}

	public void setNomClavesConvenioDAO(NomClavesConvenioDAO nomClavesConvenioDAO) {
		this.nomClavesConvenioDAO = nomClavesConvenioDAO;
	}	
	
}
