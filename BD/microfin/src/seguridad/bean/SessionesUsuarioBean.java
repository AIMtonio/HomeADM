package seguridad.bean;

import java.util.HashMap;

import org.apache.log4j.Logger;

public class SessionesUsuarioBean {
	protected final Logger loggerSAFI = Logger.getLogger("SAFI");

	static HashMap sesionesAplicacion = new HashMap();

	
	public SessionesUsuarioBean() {
		super();
		loggerSAFI.info("Creando el Bean SessionesUsuarioBean");
	}

	public HashMap getSesionesAplicacion() {
		loggerSAFI.debug("Obteniendo Sessiones de la Aplicacion");
		return sesionesAplicacion;
	}

	public void setSesionesAplicacion(HashMap sesionesAplicacion) {
		loggerSAFI.info("Seteando Sessiones de la Aplicacion");
		this.sesionesAplicacion = sesionesAplicacion;
	}

	
	
}
