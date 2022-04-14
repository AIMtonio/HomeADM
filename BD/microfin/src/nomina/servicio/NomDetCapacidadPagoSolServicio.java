package nomina.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import nomina.bean.NomDetCapacidadPagoSolBean;
import nomina.dao.NomDetCapacidadPagoSolDAO;

public class NomDetCapacidadPagoSolServicio extends BaseServicio{
	NomDetCapacidadPagoSolDAO nomDetCapacidadPagoSolDAO = null;
	
	/* =====================================================================  */
	/* =====================================================================  */
	public NomDetCapacidadPagoSolServicio() {
		super();
		// TODO Auto-generated constructor stub
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public static interface Enum_Tra_NomDetCapacidad{
	}
	
	public static interface Enum_Lis_NomDetCapacidad{
		int listaClasifClaveCapSol = 1;
		int listaClavePresupCapSol = 2;
	}
	
	// Consulta de personas
	public static interface Enum_Con_NomDetCapacidad{
		int consultaClavePresupCapSol		= 1;
	}
	
	/* =====================================================================  */
	/* =====================================================================  */
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion,NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean) {
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		
		}
		return mensaje;
	}	

	/* =====================================================================  */
	/* =====================================================================  */
	
	public List lista(int tipoLista, NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean){
		List listaResult = null;
		switch (tipoLista) {
			case  Enum_Lis_NomDetCapacidad.listaClasifClaveCapSol:
				listaResult = nomDetCapacidadPagoSolDAO.listaClasifClavSol(nomDetCapacidadPagoSolBean, tipoLista);
				break;  
			case  Enum_Lis_NomDetCapacidad.listaClavePresupCapSol:
				listaResult = nomDetCapacidadPagoSolDAO.listaClavPresupSol(nomDetCapacidadPagoSolBean, tipoLista);
				break;  

		}
		return listaResult;
	}

	/* =====================================================================  */
	/* =====================================================================  */
	public NomDetCapacidadPagoSolBean consulta(int tipoConsulta, NomDetCapacidadPagoSolBean nomDetCapacidadPagoSolBean) {
		NomDetCapacidadPagoSolBean consultaRetornada = null;
		
		switch (tipoConsulta) {
			case  Enum_Con_NomDetCapacidad.consultaClavePresupCapSol:
				consultaRetornada = nomDetCapacidadPagoSolDAO.conClavePresupCapacidadPago(nomDetCapacidadPagoSolBean, tipoConsulta);
				break; 
		}		
		return consultaRetornada;		
	}

	/* =====================================================================  */
	/* =====================================================================  */
	
	public NomDetCapacidadPagoSolDAO getNomDetCapacidadPagoSolDAO() {
		return nomDetCapacidadPagoSolDAO;
	}

	public void setNomDetCapacidadPagoSolDAO(
			NomDetCapacidadPagoSolDAO nomDetCapacidadPagoSolDAO) {
		this.nomDetCapacidadPagoSolDAO = nomDetCapacidadPagoSolDAO;
	}

}
