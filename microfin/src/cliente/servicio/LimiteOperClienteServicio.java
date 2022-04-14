package cliente.servicio;

import java.util.List;

import cliente.bean.LimiteOperClienteBean;
import cliente.dao.LimiteOperClienteDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class LimiteOperClienteServicio extends BaseServicio {
	
	LimiteOperClienteDAO limiteOperClienteDAO = null;
	
	public static interface Enum_Tra_Cte{
		int grabar = 1;
		int modificar = 2;
	}
	
	public static interface Enum_Con_Cte{
		int principal   = 1;				
	}
	
	public static interface Enum_Lis_Cte{
		int clientesReg = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, int tipoActualizacion, LimiteOperClienteBean limiteOperClienteBean){		
		MensajeTransaccionBean mensaje = null;		
		switch(tipoTransaccion){		
			case Enum_Tra_Cte.grabar:
				mensaje = limiteOperClienteDAO.altaLimiteOperCliente(limiteOperClienteBean);	
			break;	
			case Enum_Tra_Cte.modificar:
				mensaje = limiteOperClienteDAO.modificaLimiteOperCliente(limiteOperClienteBean);
			break;			
		}		
		return mensaje;	
	}
	
	// Consulta para las cuentas BCA
	public LimiteOperClienteBean consulta(int tipoConsulta, LimiteOperClienteBean limiteOperClienteBean){
		LimiteOperClienteBean imiteOperClienteBeanCon = null;
		switch(tipoConsulta){
			case Enum_Con_Cte.principal:
				imiteOperClienteBeanCon = limiteOperClienteDAO.consultaPrincipal(limiteOperClienteBean, tipoConsulta);
			break;			
		
		}
		return imiteOperClienteBeanCon;
	}
	
	public List lista(int tipoLista, LimiteOperClienteBean limiteOperClienteBean) {
		List listaUsuario = null;
		switch (tipoLista) {
			case Enum_Lis_Cte.clientesReg:
				listaUsuario = limiteOperClienteDAO.listaUsuario(limiteOperClienteBean, tipoLista);
			break;			
			
		}
		return listaUsuario;
	}
	
	
	
	public LimiteOperClienteDAO getLimiteOperClienteDAO() {
		return limiteOperClienteDAO;
	}

	public void setLimiteOperClienteDAO(LimiteOperClienteDAO limiteOperClienteDAO) {
		this.limiteOperClienteDAO = limiteOperClienteDAO;
	}

}
