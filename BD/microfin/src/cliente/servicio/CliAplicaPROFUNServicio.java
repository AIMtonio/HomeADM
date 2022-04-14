package cliente.servicio;

import java.io.ByteArrayOutputStream;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.bean.CliAplicaPROFUNBean;
import cliente.dao.CliAplicaPROFUNDAO;

public class CliAplicaPROFUNServicio extends BaseServicio {

	// Variables 
	CliAplicaPROFUNDAO cliAplicaPROFUNDAO = null;
		
	// tipo de consulta
	public static interface Enum_Tra_CliAplicaPROFUN{
		int alta = 1;
		int autoriza = 2;
		int pagar = 3; // solo como referencia..
		int rechaza = 4;
	}	
		
	//consulta
	public static interface Enum_Con_cliAplicaPROFUN {
		int principal = 1;
		int foranea = 2;
	}
			
	public static interface Enum_Lis_CliAplicaPROFUN {
		int registrado = 1;
		int autorizado =2;
	}
	
	public static interface Enum_Lis_Bene {
		int listaBeneGrid =2; 		
	}
	    
	public static interface Enum_Lis_PagoPROFUNRep {
		int principal		= 1;
	}
	
	public CliAplicaPROFUNServicio() {
		super();
	}

	public MensajeTransaccionBean grabaTransaccion( int tipoTransaccion, CliAplicaPROFUNBean cliAplicaPROFUNBean){ 
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_CliAplicaPROFUN.alta:
				mensaje = altaCliAplicaPROFUN(cliAplicaPROFUNBean);	
				break;
			case Enum_Tra_CliAplicaPROFUN.autoriza:
				mensaje = autorizaCliAplicaPROFUN(cliAplicaPROFUNBean, tipoTransaccion);	//modifique
				break;
			case Enum_Tra_CliAplicaPROFUN.rechaza:
				mensaje = rechazaCliAplicaPROFUN(cliAplicaPROFUNBean, tipoTransaccion); 
				break;				
		}
		return mensaje;
	}
				
	public MensajeTransaccionBean altaCliAplicaPROFUN(CliAplicaPROFUNBean cliAplicaPROFUNBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cliAplicaPROFUNDAO.altaCliAplicaPROFUN(cliAplicaPROFUNBean);		
		return mensaje;
	}
		
	public MensajeTransaccionBean autorizaCliAplicaPROFUN(CliAplicaPROFUNBean cliAplicaPROFUNBean, int tipoTransaccion){ //modifique
		MensajeTransaccionBean mensaje = null;
		mensaje = cliAplicaPROFUNDAO.autorizaRechazaCliAplicaPROFUN(cliAplicaPROFUNBean, tipoTransaccion);		
		return mensaje;
	}
		
	public MensajeTransaccionBean rechazaCliAplicaPROFUN(CliAplicaPROFUNBean cliAplicaPROFUNBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = cliAplicaPROFUNDAO.autorizaRechazaCliAplicaPROFUN(cliAplicaPROFUNBean, tipoTransaccion);
		return mensaje;
	}
				
	public CliAplicaPROFUNBean consulta(CliAplicaPROFUNBean cliAplicaPROF, int tipoConsulta){
		CliAplicaPROFUNBean cliAplicaPROFUNBean = null;
		switch (tipoConsulta) {
			case Enum_Con_cliAplicaPROFUN.principal:		
				cliAplicaPROFUNBean = cliAplicaPROFUNDAO.consultaPrincipal(cliAplicaPROF, Enum_Con_cliAplicaPROFUN.principal);				
				break;				
			}
			return cliAplicaPROFUNBean;
	}
				
	public List lista(int tipoLista, CliAplicaPROFUNBean cliAplicaPROFUNBean){		
		List listaClientesPROFUN = null;
		switch (tipoLista) {
			case Enum_Lis_CliAplicaPROFUN.registrado:		
				listaClientesPROFUN = cliAplicaPROFUNDAO.listaPrincipal(cliAplicaPROFUNBean, tipoLista);				
				break;	
			case Enum_Lis_CliAplicaPROFUN.autorizado:		
				listaClientesPROFUN = cliAplicaPROFUNDAO.listaPrincipal(cliAplicaPROFUNBean, tipoLista);				
				break;
		}	
		return listaClientesPROFUN;
	}	
		
	//------------------ Getters y Setters ------------------------------------------------------	
	public void setCliAplicaPROFUNDAO(CliAplicaPROFUNDAO cliAplicaPROFUNDAO) {
		this.cliAplicaPROFUNDAO = cliAplicaPROFUNDAO;
	}

	public CliAplicaPROFUNDAO getCliAplicaPROFUNDAO() {
		return cliAplicaPROFUNDAO;
	}
				
}

