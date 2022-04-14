package cliente.servicio;

import herramientas.Utileria;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import cuentas.servicio.MonedasServicio.Enum_Lis_Monedas;
import cliente.bean.ClienteBean;
import cliente.bean.PromotoresBean;
import cliente.dao.PromotoresDAO;
import cliente.servicio.ClienteServicio.Enum_Tra_Cliente;
import cliente.servicio.PromotoresServicio.Enum_Con_Promotor;
import cliente.servicio.PromotoresServicio.Enum_Lis_Promotor;

public class PromotoresServicio extends BaseServicio {
	
	//---------- Variables ------------------------------------------------------------------------
	PromotoresDAO promotoresDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_Promotor {
		int principal		= 1;
		int foranea 		= 2;
		int promotorAct 	= 3;
		int proActivo		= 4;
		int conPromCaptacion= 6;
		int conPromExterno  = 7;
		int tipoInstitucion = 8;
		int conPromotorSuc	= 9; //Consulta promotores por sucursal
	}

	public static interface Enum_Lis_Promotor {
		int principal       = 1;
		int promotoresAct   = 2;
		int promotores      = 3;
		int promSucur   	= 4;	
		int promExterno     = 7;
		int promCaptacion	= 8;
		int promActivos		= 10;

	
		
	}

	public static interface Enum_Tra_Promotor {
		int alta = 1;
		int modificacion = 2;

	}
	
	public PromotoresServicio () {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, PromotoresBean promotor){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Promotor.alta:		
				mensaje = altaPromotor(promotor);				
				break;				
			case Enum_Tra_Promotor.modificacion:		
				mensaje = modificaPromotor(promotor);				
				break;		
			
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaPromotor(PromotoresBean promotor){
		MensajeTransaccionBean mensaje = null;
		mensaje = promotoresDAO.altaPromotor(promotor);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificaPromotor(PromotoresBean promotor){
		MensajeTransaccionBean mensaje = null;
		mensaje = promotoresDAO.modificaPromotor(promotor);		
		return mensaje;
	}
		
	public PromotoresBean consulta(int tipoConsulta, PromotoresBean promotor){
		PromotoresBean promotores = null;
		switch(tipoConsulta){
		case Enum_Con_Promotor.principal:	
			promotores = promotoresDAO.consultaPrincipal(promotor,tipoConsulta);
		break;
		case Enum_Con_Promotor.foranea:	
			promotores = promotoresDAO.consultaForanea(promotor,tipoConsulta);
		break;
		case Enum_Con_Promotor.promotorAct:	
			promotores = promotoresDAO.consultaTienePromAct(promotor,tipoConsulta);
			break;
		case Enum_Con_Promotor.proActivo:	
			promotores = promotoresDAO.consultaProActivo(promotor,tipoConsulta);
			break;

		case Enum_Con_Promotor.conPromCaptacion :	
			promotores = promotoresDAO.consultaPromotorCaptacion(promotor,tipoConsulta);		
			break;
		
		case Enum_Con_Promotor.conPromExterno:	
			promotores = promotoresDAO.consultaPromotorExterno(promotor,tipoConsulta);		
			break;
		case Enum_Con_Promotor.tipoInstitucion:	
			promotores = promotoresDAO.consultaTipoInstitucion(promotor,tipoConsulta);		
			break;
		case Enum_Con_Promotor.conPromotorSuc:	
			promotores = promotoresDAO.consultaProActivo(promotor,tipoConsulta);
			break;

			
		}
		
		return promotores;
	}
	
	
	
	public List lista(int tipoLista, PromotoresBean promotores){		
		List listaPromotores = null;
		switch (tipoLista) {
			case Enum_Lis_Promotor.principal:		
				listaPromotores=  promotoresDAO.listaPromotores(promotores,tipoLista);				
				break;		
			case Enum_Lis_Promotor.promotoresAct:		
				listaPromotores=  promotoresDAO.listaPromotoresActivos(promotores,tipoLista);				
				break;	
			case Enum_Lis_Promotor.promSucur:		
				listaPromotores=  promotoresDAO.listaPromSucur(promotores,tipoLista);				
				break;	
			case Enum_Lis_Promotor.promExterno:		
				listaPromotores=  promotoresDAO.listaPromotoresExterno(promotores,tipoLista);				
				break;	
			case Enum_Lis_Promotor.promCaptacion:		
				listaPromotores=  promotoresDAO.listaPromotoresCaptacion(promotores,tipoLista);				
				break;
			case Enum_Lis_Promotor.promActivos:		
				listaPromotores=  promotoresDAO.listaPromotoresAct(promotores,tipoLista);				
				break;
				
				
		}		
		return listaPromotores;
	}
	
	// listas para comboBox
	public  Object[] listaCombo(int tipoLista) {
		List listaPromotores = null;
		switch(tipoLista){
			case (Enum_Lis_Promotor.promotores): 
				listaPromotores =  promotoresDAO.listaPromotores(tipoLista);
				break;
		}
		return listaPromotores.toArray();		
	}
	
	
	
	//------------------ Geters y Seters ------------------------------------------------------	
	public void setPromotoresDAO(PromotoresDAO promotoresDAO) {
		this.promotoresDAO = promotoresDAO;
	}	
	

}
