package ventanilla.servicio;

import java.util.List;

import ventanilla.bean.ChequesEmitidosBean;
import ventanilla.dao.ChequesEmitidosDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ChequesEmitidosServicio  extends BaseServicio{
	
	ChequesEmitidosDAO chequesEmitidosDAO =null;
	
	
	public static interface Enum_Tra_ChequesEmitidos {
		int alta = 1;
	
 
	}
	
	public static interface Enum_Con_ChequesEmitidos {
		int ConPrincipal 		= 1;
		int ConEmitidos	 		= 2;
		int ConNumTransaccion	= 3;
		int conChequesEmiti		= 4;
		int conChequesGastAnt	= 5;
		int conChequesSinRequi	= 6;
		int conChequesConRequi	= 7;
		int conChequesConcilia	= 8;
		
	}
	public static interface Enum_Lis_ChequesEmitidos {
		int Principal 					= 1;
		int Emitidos	 				= 2;
		int chequesEmitidos 			= 3;
		int chequesEmitidosTesoreria	= 5;
		int chequesGastAnt				= 6;
		int chequesSinRequi				= 7;
		int chequesConRequi				= 8;
		
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,ChequesEmitidosBean chequesEmitidosBean ){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) { 
			case Enum_Tra_ChequesEmitidos.alta:		
				mensaje = altachequesEmitidos(chequesEmitidosBean);				
				break;			
		}
		return mensaje;
	}	
	
	public MensajeTransaccionBean altachequesEmitidos(ChequesEmitidosBean chequesEmitidosBean ){
		MensajeTransaccionBean mensaje = null;
	    mensaje = chequesEmitidosDAO.chequesEmitidosAlta(chequesEmitidosBean);
		return mensaje;
	}
	
	
	public ChequesEmitidosBean consulta(int tipoConsulta, ChequesEmitidosBean chequesEmitidosBean){
		ChequesEmitidosBean ChequesEmitidos = null;
		switch (tipoConsulta) {
			case Enum_Con_ChequesEmitidos.ConEmitidos:	
				ChequesEmitidos = chequesEmitidosDAO.consultaChequesEmitidos(chequesEmitidosBean,tipoConsulta);
				break;	
			case Enum_Con_ChequesEmitidos.ConPrincipal:	
				ChequesEmitidos = chequesEmitidosDAO.consultaPrincipal(chequesEmitidosBean,tipoConsulta);
				break;	
			case Enum_Con_ChequesEmitidos.ConNumTransaccion:	
				ChequesEmitidos = chequesEmitidosDAO.conNumTransaCheques(chequesEmitidosBean,tipoConsulta);
				break;
			case Enum_Con_ChequesEmitidos.conChequesEmiti:	
				ChequesEmitidos = chequesEmitidosDAO.consultaCheques(chequesEmitidosBean, tipoConsulta);
				break;
			case Enum_Con_ChequesEmitidos.conChequesGastAnt:	
				ChequesEmitidos = chequesEmitidosDAO.conChequesGastAnticipos(chequesEmitidosBean, tipoConsulta);
				break;
			case Enum_Con_ChequesEmitidos.conChequesSinRequi:	
				ChequesEmitidos = chequesEmitidosDAO.conChequesSinReq(chequesEmitidosBean, tipoConsulta);
				break;
			case Enum_Con_ChequesEmitidos.conChequesConRequi:	
				ChequesEmitidos = chequesEmitidosDAO.conChequesConReq(chequesEmitidosBean, tipoConsulta);
				break;
			case Enum_Con_ChequesEmitidos.conChequesConcilia:	
				ChequesEmitidos = chequesEmitidosDAO.conChequesConciliacion(chequesEmitidosBean, tipoConsulta);
				break;
		}
		return ChequesEmitidos;
	}

	public List listaChequesEmitidos(int tipoLista, ChequesEmitidosBean chequesEmitidosBean){		
		List listaCheques = null;		
		switch(tipoLista){
			case Enum_Lis_ChequesEmitidos.Emitidos:
				listaCheques = chequesEmitidosDAO.listaChequesEmitidos(chequesEmitidosBean, tipoLista); 
				break; 	
			case Enum_Lis_ChequesEmitidos.chequesEmitidos:
				listaCheques = chequesEmitidosDAO.listaPrincipal(chequesEmitidosBean, tipoLista); 
				break;
			case Enum_Lis_ChequesEmitidos.chequesEmitidosTesoreria:
				listaCheques = chequesEmitidosDAO.listaPrincipal(chequesEmitidosBean, tipoLista); 
				break;
			case Enum_Lis_ChequesEmitidos.chequesGastAnt:
				listaCheques = chequesEmitidosDAO.listaChequesGastAnti(chequesEmitidosBean, tipoLista); 
				break;
			case Enum_Lis_ChequesEmitidos.chequesSinRequi:
				listaCheques = chequesEmitidosDAO.listaChequesDispSinReq(chequesEmitidosBean, tipoLista); 
				break;
			case Enum_Lis_ChequesEmitidos.chequesConRequi:
				listaCheques = chequesEmitidosDAO.listaChequesDispConReq(chequesEmitidosBean, tipoLista); 
				break;
		
		}
		
		return listaCheques;
	}
	
	
	//---------------getter y setter--------------------------
	public ChequesEmitidosDAO getChequesEmitidosDAO() {
		return chequesEmitidosDAO;
	}
	public void setChequesEmitidosDAO(ChequesEmitidosDAO chequesEmitidosDAO) {
		this.chequesEmitidosDAO = chequesEmitidosDAO;
	}

	
	
	
}
