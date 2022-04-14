package invkubo.servicio;

import java.util.List;

import cuentas.servicio.MonedasServicio;

import inversiones.bean.InversionBean;
import invkubo.bean.FondeoSolicitudBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;
import invkubo.dao.InversionistasKuboDAO;


public class InversionistasKuboServicio {

	//---------- Variables ------------------------------------------------------------------------
	InversionistasKuboDAO inversionistasKuboDAO = null;			   
	MonedasServicio monedasServicio = null;	
	
	//---------- Transacciones ------------------------------------------------------------------------
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, FondeoSolicitudBean fondeoSolicitudBean){
		MensajeTransaccionBean mensaje = null;
		return mensaje;
		
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_Creditos {
		int principal = 1;
	}
	
	public List listaGrid(int tipoLista,FondeoSolicitudBean fondeoSolicitud){		
		List listaFondeos = null;
		switch (tipoLista) {
			case Enum_Lis_Creditos.principal:		
				listaFondeos = inversionistasKuboDAO.listaPrincipal(fondeoSolicitud, tipoLista);				
				break;				
		}		
		return listaFondeos;
	}
	
	//---------- Asignaciones -----------------------------------------------------------------------

	public void setInversionistasKuboDAO(InversionistasKuboDAO inversionistasKuboDAO) {
		this.inversionistasKuboDAO = inversionistasKuboDAO;
	}
	
	
}

