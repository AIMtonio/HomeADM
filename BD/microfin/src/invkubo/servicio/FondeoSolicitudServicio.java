package invkubo.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import invkubo.bean.FondeoSolicitudBean;
import invkubo.dao.FondeoSolicitudDAO;

import java.util.List;

import credito.servicio.CreditosServicio.Enum_Tra_Creditos;
import cuentas.servicio.MonedasServicio;


public class FondeoSolicitudServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	FondeoSolicitudDAO fondeoSolicitudDAO = null;			   
	MonedasServicio monedasServicio = null;	
	
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_FondeoSolicitud {
		int principal = 1;
		int gridFondeador = 2;
		int gridInversiones = 3;
		int altoRiesgo = 4;
	}

	
//---------- tipos Transacciones ------------------------------------------------------------------------
	
	public static interface Enum_Tra_FondeoSolicitud {
		int alta = 1;
		int proceso = 2;
		int cancelar = 3;
	}
	

	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, FondeoSolicitudBean fondeoSolicitudBean){
        MensajeTransaccionBean mensaje = null;
        switch (tipoTransaccion) {
        case Enum_Tra_Creditos.alta:                
                mensaje = fondeoSolicitudDAO.alta(fondeoSolicitudBean);                                
                break;     
        case Enum_Tra_FondeoSolicitud.proceso:                
            mensaje = fondeoSolicitudDAO.proceso(fondeoSolicitudBean);                                
            break;        
        case Enum_Tra_FondeoSolicitud.cancelar:
    		mensaje = fondeoSolicitudDAO.cancelar(fondeoSolicitudBean);                              
        	break;
        }
        return mensaje;        
	}
	
	
	public List listaGrid(int tipoLista,FondeoSolicitudBean fondeoSolicitud){		
		List listaFondeos = null;
		
		switch (tipoLista) {
			case Enum_Lis_FondeoSolicitud.principal:		
				//listaFondeos = fondeoSolicitudDAO.listaPrincipal(fondeoSolicitud, tipoLista);				
				break;	
			case Enum_Lis_FondeoSolicitud.gridFondeador:		// lista de fondeadores Para pantalla de alta de credito kubo
				listaFondeos = fondeoSolicitudDAO.listaGridFondeadores(fondeoSolicitud, tipoLista);				
				break;	
			case Enum_Lis_FondeoSolicitud.gridInversiones:		//lista de fondeadores Para pantalla de consulta originacion 
				listaFondeos = fondeoSolicitudDAO.listaGridInverKubo(fondeoSolicitud, tipoLista);				
				break;
			case Enum_Lis_FondeoSolicitud.altoRiesgo:		//lista de fondeadores de Alto Riesgo 
				listaFondeos = fondeoSolicitudDAO.listaInversionistasAltoRiesgo(fondeoSolicitud, tipoLista);				
				break;	 				
				
		}		
		return listaFondeos;
	}
	
	//---------- Asignaciones -----------------------------------------------------------------------

	public void setFondeoSolicitudDAO(FondeoSolicitudDAO fondeoSolicitudDAO) {
		this.fondeoSolicitudDAO = fondeoSolicitudDAO;
	}


	public FondeoSolicitudDAO getFondeoSolicitudDAO() {
		return fondeoSolicitudDAO;
	}
	
	
}

