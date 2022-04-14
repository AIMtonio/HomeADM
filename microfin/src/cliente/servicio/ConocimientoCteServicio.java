package cliente.servicio;
import cliente.bean.ConocimientoCteBean;
import cliente.dao.ConocimientoCteDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class ConocimientoCteServicio extends BaseServicio {
	
	private ConocimientoCteServicio(){
		super();
	}

	ConocimientoCteDAO conocimientoCteDAO = null;
	
	public static interface Enum_Con_ConoClient {
		int principal = 1;
		int foranea = 2;
		int existe = 4;
	}

	public static interface Enum_Lis_ConoClient {
		int principal = 1;
	}

	public static interface Enum_Tra_ConoClient {
		int alta = 1;
		int modificacion = 2;
		int altaWS = 3;
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, ConocimientoCteBean conocimiento){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_ConoClient.alta:		
				mensaje = alta(conocimiento);				
				break;				
			case Enum_Tra_ConoClient.modificacion:
				mensaje = modifica(conocimiento);				
				break;
			case Enum_Tra_ConoClient.altaWS:		
				mensaje = altaWS(conocimiento);				
				break;	
	    }
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(ConocimientoCteBean conocimiento){
		MensajeTransaccionBean mensaje = null;
		mensaje = conocimientoCteDAO.altaConocimiento(conocimiento);		
		return mensaje;
	}
	
	public MensajeTransaccionBean altaWS(ConocimientoCteBean conocimiento){
		MensajeTransaccionBean mensaje = null;
		mensaje = conocimientoCteDAO.altaConocimientoWS(conocimiento);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modifica(ConocimientoCteBean conocimiento){
		MensajeTransaccionBean mensaje = null;
		mensaje = conocimientoCteDAO.modificaConocimiento(conocimiento);		
		return mensaje;
	}
	
	public ConocimientoCteBean consulta(int tipoConsulta,ConocimientoCteBean conocimientoBean) {
		ConocimientoCteBean conocimiento = null;
		switch (tipoConsulta) {
			case Enum_Con_ConoClient.principal:		
				conocimiento = conocimientoCteDAO.consultaPrincipal(conocimientoBean, tipoConsulta);				
				break;				
			case Enum_Con_ConoClient.foranea:
				conocimiento = conocimientoCteDAO.consultaForanea(conocimientoBean, tipoConsulta);
				break;	
			case Enum_Con_ConoClient.existe:
				conocimiento = conocimientoCteDAO.consultaExiste(conocimientoBean, tipoConsulta);
				break;
		}
		return conocimiento;
	}

	public void setConocimientoCteDAO(ConocimientoCteDAO conocimientoCteDAO) {
		this.conocimientoCteDAO = conocimientoCteDAO;
	}

	public ConocimientoCteDAO getConocimientoCteDAO() {
		return conocimientoCteDAO;
	}
}
