package credito.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

import credito.bean.AvalesBean;
import credito.dao.AvalesDAO;
import credito.servicio.AvalesPorSoliciServicio.Enum_Lis_avales;

public class AvalesServicio extends BaseServicio {

	private AvalesServicio(){
		super();
	}
	
	AvalesDAO avalesDAO = null;
	
	public static interface Enum_Tra_Avales {
		int alta = 1;
		int modificacion = 2;
	}
	public static interface Enum_Con_Avales {
		int principal = 1;
		int conCredAval = 2;
		int ConCredCliente = 3;
		int ConCredProspecto = 4;
		int conPersonaFisica = 5;
	}
	public static interface Enum_Lis_Avales{
		int alfanumerica 	= 1;
		int creditosAva 	= 2;
		int avalesxcliente 	= 3;
		int avalesSol		= 4;

		int avalesPersonaFisica	= 5;
		int avalesPersonaMoral =6;

		

	}
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, AvalesBean avales){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_Avales.alta:
			
				mensaje = altaAval(avales);								
				break;					
			case Enum_Tra_Avales.modificacion:		
				
				mensaje = modificacionAval(avales);								
				break;
		}
		return mensaje;
	}
	
	public AvalesBean consulta(int tipoConsulta, AvalesBean avalesBean){
		AvalesBean avales = null;
		switch(tipoConsulta){
			case Enum_Con_Avales.principal:
				avales = avalesDAO.consultaPrincipal(avalesBean, Enum_Con_Avales.principal);
			break;
			case Enum_Con_Avales.conCredAval:
				avales = avalesDAO.consultaCreditosAvalados(avalesBean, Enum_Con_Avales.conCredAval);
			break;
			
			case Enum_Con_Avales.ConCredCliente:
				avales = avalesDAO.consultaCreditosAvalados(avalesBean, Enum_Con_Avales.ConCredCliente);
			break;
			
			case Enum_Con_Avales.ConCredProspecto:
				avales = avalesDAO.consultaCreditosAvalados(avalesBean, Enum_Con_Avales.ConCredProspecto);
			break;
			case Enum_Con_Avales.conPersonaFisica:
				avales = avalesDAO.consultaAvalesPersonaFisica(avalesBean, Enum_Con_Avales.conPersonaFisica);
			break;
			
		}
		return avales;
	}
	
	public MensajeTransaccionBean altaAval(AvalesBean avales){
		MensajeTransaccionBean mensaje = null;
		mensaje = avalesDAO.altaAval(avales);		
		return mensaje;
	}
	public MensajeTransaccionBean modificacionAval(AvalesBean avales){
		MensajeTransaccionBean mensaje = null;
		mensaje = avalesDAO.modificacionAval(avales);		
		return mensaje;
	}

	public List lista(int tipoLista, AvalesBean avales){		
		List listaAvales = null;
		switch (tipoLista) {
			case Enum_Lis_Avales.alfanumerica:		
				listaAvales=  avalesDAO.listaAlfanumerica(avales, Enum_Lis_Avales.alfanumerica);				
				break;	
			case Enum_Lis_Avales.creditosAva:		
				listaAvales=  avalesDAO.listaCreditos(avales, tipoLista);				
				break;
			case Enum_Lis_Avales.avalesxcliente:
				listaAvales=  avalesDAO.listaAvalesxCliente(avales, Enum_Lis_Avales.avalesxcliente);
				break;
			case Enum_Lis_Avales.avalesSol:		
				listaAvales=  avalesDAO.listaAvalesSol(avales, Enum_Lis_Avales.avalesSol);				
				break;

			case Enum_Lis_Avales.avalesPersonaFisica:		
				listaAvales=  avalesDAO.listaAlfanumerica(avales, Enum_Lis_Avales.avalesPersonaFisica);				
				break;
			case Enum_Lis_Avales.avalesPersonaMoral:		
				listaAvales=  avalesDAO.listaAlfanumerica(avales, Enum_Lis_Avales.avalesPersonaMoral);				
				break;

		}		
		return listaAvales;
	}

	
	public AvalesDAO getAvalesDAO() {
		return avalesDAO;
	}

	public void setAvalesDAO(AvalesDAO avalesDAO) {
		this.avalesDAO = avalesDAO;
	}	
	
	
	
	
	
	
}
