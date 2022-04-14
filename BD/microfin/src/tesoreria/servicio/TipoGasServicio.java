package tesoreria.servicio;

import java.util.List;

import tesoreria.bean.TipoGasBean;
import tesoreria.dao.TipoGasDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class TipoGasServicio extends BaseServicio {

	private TipoGasServicio(){
		super();
	}
	
	TipoGasDAO tipoGasDAO = null;

	public static interface Enum_Lis_TipoGas{
		int alfanumerica = 1;
		int foranea=2;
	}
	
	public static interface Enum_Con_TipoGas{
		int principal = 1;
	}
	
	public static interface Enum_Tra_TipoGas {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
		
	}
	
	public List lista(int tipoLista, TipoGasBean tipoGas){		
		List listaTipoGas = null;
		switch (tipoLista) {
			case Enum_Lis_TipoGas.alfanumerica:		
				listaTipoGas=  tipoGasDAO.listaAlfanumerica(tipoGas,Enum_Lis_TipoGas.alfanumerica);				
				break;	
			case Enum_Lis_TipoGas.foranea:		
				listaTipoGas=  tipoGasDAO.listaAlfanumerica(tipoGas,Enum_Lis_TipoGas.foranea);				
				break;
		}		
		return listaTipoGas;
	}
	
	public TipoGasBean consulta(int tipoConsulta, TipoGasBean tipoGas){
		TipoGasBean tipoGasBean = null;
		switch(tipoConsulta){
			case Enum_Con_TipoGas.principal:
				tipoGasBean = tipoGasDAO.consultaPrincipal(tipoGas, Enum_Con_TipoGas.principal);
			break;
		}
		return tipoGasBean;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TipoGasBean tipoGas){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_TipoGas.alta:
			mensaje = alta(tipoGas);
			break;
		case Enum_Tra_TipoGas.modificacion:
			mensaje = modificacion(tipoGas);
			break;
		case Enum_Tra_TipoGas.baja:
			mensaje = baja(tipoGas);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(TipoGasBean tipoGas){
		MensajeTransaccionBean mensaje = null;
		mensaje = tipoGasDAO.alta(tipoGas);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificacion(TipoGasBean tipoGas){
		MensajeTransaccionBean mensaje = null;
		mensaje = tipoGasDAO.modifica(tipoGas);		
		return mensaje;
	}	
	
	public MensajeTransaccionBean baja(TipoGasBean tipoGas){
		MensajeTransaccionBean mensaje = null;
		mensaje = tipoGasDAO.baja(tipoGas);		
		return mensaje;
	}
	

		
	public void setTipoGasDAO(TipoGasDAO tipoGasDAO ){
		this.tipoGasDAO = tipoGasDAO;
	}

	public TipoGasDAO getTipoGasDAO() {
		return tipoGasDAO;
	}

	
}
