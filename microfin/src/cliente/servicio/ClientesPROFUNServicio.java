package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import cliente.bean.ClientesPROFUNBean;
import cliente.dao.ClientesPROFUNDAO;


public class ClientesPROFUNServicio extends BaseServicio {
	    // Variables 
		ClientesPROFUNDAO clientesPROFUNDAO = null;
		
	    // tipo de consulta
		public static interface Enum_Tra_ClientesPROFUN{
			int alta = 1;
			int cancela = 2;
		    
		}		
		public static interface Enum_Act_ClientesPROFUN{
			int cancela = 1;
		}	
	    public static interface Enum_Con_ClientesPROFUN { 
					int principal = 1;
					int montoAdeudo = 2;
				}
	    public static interface Enum_Lis_ClientesPROFUN {
					int principal = 1;
				}
	    				
		public ClientesPROFUNServicio() {
			super();
		}

		public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, ClientesPROFUNBean clientesPROFUNBean){
			MensajeTransaccionBean mensaje = null;
			switch(tipoTransaccion){
				case Enum_Tra_ClientesPROFUN.alta:
					mensaje = altaClientesPROFUN(clientesPROFUNBean);	
					break;
				case Enum_Tra_ClientesPROFUN.cancela:
					mensaje = actualizaClientesPROFUN(clientesPROFUNBean,tipoActualizacion);
					break;
			}
			return mensaje;
		}
				
		public MensajeTransaccionBean altaClientesPROFUN(ClientesPROFUNBean clientesPROFUNBean){
			MensajeTransaccionBean mensaje = null;
			mensaje = clientesPROFUNDAO.altaClientesPROFUN(clientesPROFUNBean);		
	
			
	
			
			return mensaje;
		}

		public ClientesPROFUNBean consulta(int tipoConsulta,ClientesPROFUNBean clientesPROF){
			ClientesPROFUNBean clientesPROFUNBean = null;
			switch (tipoConsulta) {
				case Enum_Con_ClientesPROFUN.principal:		
					clientesPROFUNBean = clientesPROFUNDAO.consultaPrincipal(clientesPROF, Enum_Con_ClientesPROFUN.principal);				
					break;	
				case Enum_Con_ClientesPROFUN.montoAdeudo:		
					clientesPROFUNBean = clientesPROFUNDAO.consultaMontoAdeudo(clientesPROF, Enum_Con_ClientesPROFUN.montoAdeudo);				
					break;	
			}
			return clientesPROFUNBean;
		}
		
	public MensajeTransaccionBean actualizaClientesPROFUN(ClientesPROFUNBean clientesPROFUNBean,int tipoActualizacion){
		MensajeTransaccionBean mensaje = null;
		switch(tipoActualizacion){
		case Enum_Act_ClientesPROFUN.cancela:
			mensaje = clientesPROFUNDAO.actualizaClientesPROFUN(clientesPROFUNBean, tipoActualizacion);	
		break;
		}
		return mensaje;
	}	
			
	//------------------ Getters y Setters ------------------------------------------------------	
	public void setClientesPROFUNDAO(ClientesPROFUNDAO clientesPROFUNDAO) {
		this.clientesPROFUNDAO = clientesPROFUNDAO;
	}

	public ClientesPROFUNDAO getClientesPROFUNDAO() {
		return clientesPROFUNDAO;
	}
				
}

