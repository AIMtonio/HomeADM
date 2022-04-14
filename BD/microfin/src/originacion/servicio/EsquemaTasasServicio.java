package originacion.servicio;

import java.util.List;

import credito.bean.CreditosBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import originacion.bean.EsquemaTasasBean;
import originacion.dao.EsquemaTasasDAO;



public class EsquemaTasasServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	EsquemaTasasDAO esquemaTasasDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_EsqTasas {
		int principal = 1;
		int tasaVar = 2;
	
	}
	
	public static interface Enum_List_EsqTasas {
		int principal = 1;
		int tasaVar = 2;
	
	}
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_EsqTasas {
		int principal = 1;

	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_EsqTasas {
		int alta = 1;
		int modificacion = 2;
		int elimina = 3;
	}
	
	public EsquemaTasasServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaTasasBean esquemaTasasBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		switch (tipoTransaccion) {
			case Enum_Tra_EsqTasas.alta:		
				mensaje = altaEsquemaTasas(esquemaTasasBean);								
				break;	
			case Enum_Tra_EsqTasas.modificacion:		
				mensaje = modificaEsquemaTasas(esquemaTasasBean);								
				break;
			case Enum_Tra_EsqTasas.elimina:		
				mensaje = eliminaEsquemaTasas(esquemaTasasBean);								
				break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaEsquemaTasas(EsquemaTasasBean esquemaTasasBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = esquemaTasasDAO.altaEsquemaTasas(esquemaTasasBean);		
		return mensaje;
	}
	public MensajeTransaccionBean modificaEsquemaTasas(EsquemaTasasBean esquemaTasasBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = esquemaTasasDAO.modificaEsquemaTasas(esquemaTasasBean);		
		return mensaje;
	}
	public MensajeTransaccionBean eliminaEsquemaTasas(EsquemaTasasBean esquemaTasasBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = esquemaTasasDAO.eliminaEsquemaTasas(esquemaTasasBean);		
		return mensaje;
	}
	
	
	public EsquemaTasasBean consulta(int tipoConsulta, EsquemaTasasBean esquemaTasasBean){
		EsquemaTasasBean esquemaTasas = null;
		switch (tipoConsulta) {
			case Enum_Con_EsqTasas.principal:	
				esquemaTasas = esquemaTasasDAO.consultaPrincipal(esquemaTasasBean, tipoConsulta);				
			break;	
			case Enum_Con_EsqTasas.tasaVar:		
				esquemaTasas = esquemaTasasDAO.consultaPrincipal(esquemaTasasBean, tipoConsulta);
			break;
			
		}				
		return esquemaTasas;
	}
		
	public List lista(int tipoLista, EsquemaTasasBean esquemaTasasBean){
		List listaResul = null;
		switch (tipoLista) {
			case Enum_List_EsqTasas.principal:
				listaResul = esquemaTasasDAO.consultaListaPrincipal(esquemaTasasBean, tipoLista);
			break;	
		}	
		return listaResul;
	}
	
	public Object listaCombo(int tipoLista, EsquemaTasasBean esquemaTasasBean){
		List listaResul = null;
		switch (tipoLista) {
			case Enum_List_EsqTasas.tasaVar:
				listaResul = esquemaTasasDAO.consultaListaPrincipal(esquemaTasasBean, tipoLista);
			break;	
		}	
		return listaResul.toArray();
	}
	//------------------ Geters y Seters ------------------------------------------------------	

	public EsquemaTasasDAO getEsquemaTasasDAO() {
		return esquemaTasasDAO;
	}



	public void setEsquemaTasasDAO(EsquemaTasasDAO esquemaTasasDAO) {
		this.esquemaTasasDAO = esquemaTasasDAO;
	}	
}


