package invkubo.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import invkubo.bean.TiposFondeadoresBean;
import invkubo.dao.TiposFondeadoresDAO;



public class TiposFondeadoresServicio extends BaseServicio{

	private TiposFondeadoresServicio(){
		super();
	}
	TiposFondeadoresDAO tiposFondeadoresDAO = null;

	public static interface Enum_Tra_TiposFondeadores {
		int alta = 1;
		int modificacion = 2;
		int baja = 3;
		
	}

	public static interface Enum_Con_TiposFondeadores{
		int principal = 1;
	
			
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TiposFondeadoresBean tiposFondeadores){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_TiposFondeadores.alta:
			mensaje = alta(tiposFondeadores);
			break;
		case Enum_Tra_TiposFondeadores.modificacion:
			mensaje = modificacion(tiposFondeadores);
			break;
		case Enum_Tra_TiposFondeadores.baja:
			mensaje = baja(tiposFondeadores);
			break;
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(TiposFondeadoresBean tiposFondeadores){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposFondeadoresDAO.alta(tiposFondeadores);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificacion(TiposFondeadoresBean tiposFondeadores){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposFondeadoresDAO.modifica(tiposFondeadores);		
		return mensaje;
	}	
	
	public MensajeTransaccionBean baja(TiposFondeadoresBean tiposFondeadores){
		MensajeTransaccionBean mensaje = null;
		mensaje = tiposFondeadoresDAO.baja(tiposFondeadores);		
		return mensaje;
	}
	
	public TiposFondeadoresBean consulta(int tipoConsulta, TiposFondeadoresBean tiposFondeadores){
		TiposFondeadoresBean tiposFondeadoresBean = null;
		switch (tipoConsulta) {
			case Enum_Con_TiposFondeadores.principal:		
				tiposFondeadoresBean = tiposFondeadoresDAO.consultaPrincipal(tiposFondeadores, tipoConsulta);				
				break;				
			
		}
		if(tiposFondeadoresBean!=null){
			tiposFondeadoresBean.setTipoFondeadorID(tiposFondeadoresBean.getTipoFondeadorID());
		}
		
		return tiposFondeadoresBean;
	}

	public void setTiposFondeadoresDAO(TiposFondeadoresDAO tiposFondeadoresDAO) {
		this.tiposFondeadoresDAO = tiposFondeadoresDAO;
	}

	public TiposFondeadoresDAO getTiposFondeadoresDAO() {
		return tiposFondeadoresDAO;
	}
	
	


}
