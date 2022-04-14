package nomina.servicio;

import java.util.List;

import nomina.bean.NomCapacidadPagoSolBean;
import nomina.dao.NomCapacidadPagoSolDAO;
import nomina.servicio.NomClavesConvenioServicio.Enum_Lis_ClavePresupCove;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class NomCapacidadPagoSolServicio extends BaseServicio{
	
	NomCapacidadPagoSolDAO nomCapacidadPagoSolDAO = null;
		
	/* =====================================================================  */
	/* =====================================================================  */
	public NomCapacidadPagoSolServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public static interface Enum_Tra_CapacidadPago{
		int capacidadPagoSolAlt = 1;
		int capacidadPagoSolMod = 2;
		int calculoCapacidadPagoSol = 3;
	}
	
	public static interface Enum_Con_CapacidadPago{
		int capacidadPagoSolCon  = 1;
		int capacidadPagoSolPorSolCon = 2;
	}
	
	public static interface Enum_Lis_CapacidadPago{
		int listaCasaCOmercialPorSol  = 1;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,NomCapacidadPagoSolBean nomCapacidadPagoSolBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case (Enum_Tra_CapacidadPago.capacidadPagoSolAlt):	
				mensaje = nomCapacidadPagoSolDAO.altaCapacidadPagoSol(nomCapacidadPagoSolBean);
				break;		
			case (Enum_Tra_CapacidadPago.capacidadPagoSolMod):	
				mensaje = nomCapacidadPagoSolDAO.modificaCapacidadPagoSol(nomCapacidadPagoSolBean);
				break;		
			case (Enum_Tra_CapacidadPago.calculoCapacidadPagoSol):	
				mensaje = nomCapacidadPagoSolDAO.calculoCapacidadPagoSol(nomCapacidadPagoSolBean);
				break;		
		}
		return mensaje;
	}	

	/* =====================================================================  */
	/* =====================================================================  */
	
	public List lista(int tipoLista, NomCapacidadPagoSolBean nomCapacidadPagoSolBean){
		List listaResult = null;
		switch (tipoLista) {
			case  Enum_Lis_CapacidadPago.listaCasaCOmercialPorSol:
				listaResult = nomCapacidadPagoSolDAO.listaCasaComercial(nomCapacidadPagoSolBean, tipoLista);
				break;  
		}
		return listaResult;
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public NomCapacidadPagoSolBean consulta(int tipoConsulta, NomCapacidadPagoSolBean nomCapacidadPagoSolBean) {
		NomCapacidadPagoSolBean consultaRetornada = null;
		
		switch (tipoConsulta) {
			case Enum_Con_CapacidadPago.capacidadPagoSolCon:
				consultaRetornada = nomCapacidadPagoSolDAO.capacidadPagoSolCon(nomCapacidadPagoSolBean, tipoConsulta);
				break;
			case Enum_Con_CapacidadPago.capacidadPagoSolPorSolCon:
				consultaRetornada = nomCapacidadPagoSolDAO.capacidadPagoSolPorSolCon(nomCapacidadPagoSolBean, tipoConsulta);
				break;
			}		
		return consultaRetornada;		
	}
	
	/* =====================================================================  */
	/* =====================================================================  */

	public NomCapacidadPagoSolDAO getNomCapacidadPagoSolDAO() {
		return nomCapacidadPagoSolDAO;
	}

	public void setNomCapacidadPagoSolDAO(
			NomCapacidadPagoSolDAO nomCapacidadPagoSolDAO) {
		this.nomCapacidadPagoSolDAO = nomCapacidadPagoSolDAO;
	}
	
	

}
