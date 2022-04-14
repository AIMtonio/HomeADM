package fondeador.servicio;

import fondeador.bean.CondicionesDesctoCteLinFonBean;
import fondeador.dao.CondicionesDesctoCteLinFonDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.util.List;

public class CondicionesDesctoCteLinFonServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	CondicionesDesctoCteLinFonDAO condicionesDesctoCteLinFonDAO = null;			   

	//---------- Tipo de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_LineaFon {
		int principal = 1;
		int foranea = 2;
	}
	
	//---------- Tipo de Lista ----------------------------------------------------------------
	public static interface Enum_Lis_LineaFon {
		int principal = 1;
	}

	//---------- Tipo de Lista ----------------------------------------------------------------	
	public static interface Enum_Tra_LineaFon {
		int alta = 1;
		int modificacion = 2;
	}
	
	public CondicionesDesctoCteLinFonServicio() {
		super();
		// TODO Auto-generated constructor stub
	}	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_LineaFon.alta:		
				mensaje = alta(condicionesDesctoCteLinFonBean);				
				break;					
			case Enum_Tra_LineaFon.modificacion:		
				mensaje = modificacion(condicionesDesctoCteLinFonBean);				
				break;					
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean alta(CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = condicionesDesctoCteLinFonDAO.altaCondCte(condicionesDesctoCteLinFonBean);		
		return mensaje;
	}
	
	public MensajeTransaccionBean modificacion(CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = condicionesDesctoCteLinFonDAO.modificacion(condicionesDesctoCteLinFonBean);		
		return mensaje;
	}
	public CondicionesDesctoCteLinFonBean consulta(int tipoConsulta, CondicionesDesctoCteLinFonBean condicionesDesctoCteLinFonBean){
		CondicionesDesctoCteLinFonBean lineaFond = null;
		switch (tipoConsulta) {
			case Enum_Con_LineaFon.principal:		
				lineaFond = condicionesDesctoCteLinFonDAO.consultaPrincipal(condicionesDesctoCteLinFonBean, tipoConsulta);				
				break;
			case Enum_Con_LineaFon.foranea:		
				lineaFond = condicionesDesctoCteLinFonDAO.consultaForanea(condicionesDesctoCteLinFonBean, tipoConsulta);				
				break;
		}
				
		return lineaFond;
	}

// ------------------ Geters y Seters ------------------------------------------------------
	public CondicionesDesctoCteLinFonDAO getCondicionesDesctoCteLinFonDAO() {
		return condicionesDesctoCteLinFonDAO;
	}

	public void setCondicionesDesctoCteLinFonDAO(
			CondicionesDesctoCteLinFonDAO condicionesDesctoCteLinFonDAO) {
		this.condicionesDesctoCteLinFonDAO = condicionesDesctoCteLinFonDAO;
	}
	
}

