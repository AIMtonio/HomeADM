package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

import java.util.List;

import cliente.bean.CliExtranjeroBean;
import cliente.dao.CliExtranjeroDAO;



public class CliExtranjeroServicio  extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	CliExtranjeroDAO cliExtranjeroDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CteExt {
		int principal = 1;
		int foranea = 2;
	}

	public static interface Enum_Lis_CteExt {
		int principal = 1;
	}

	public static interface Enum_Tra_CteExt {
		int alta = 1;
		int modificacion = 2;

	}

	
	public CliExtranjeroServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CliExtranjeroBean cliExBean){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CteExt.alta:		
				mensaje = altaClientExt(cliExBean);				
				break;				
			case Enum_Tra_CteExt.modificacion:
				mensaje = modificaClientExt(cliExBean);				
				break;
			
		}
		return mensaje;
	}
	
	public MensajeTransaccionBean altaClientExt(CliExtranjeroBean cliExBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cliExtranjeroDAO.altaClientEx(cliExBean);		
		return mensaje;
	}

	public MensajeTransaccionBean modificaClientExt(CliExtranjeroBean cliExBean){
		MensajeTransaccionBean mensaje = null;
		mensaje = cliExtranjeroDAO.modificaCteExt(cliExBean);		
		return mensaje;
	}	

	public CliExtranjeroBean consulta(int tipoConsulta,CliExtranjeroBean cliEx){
		CliExtranjeroBean cliExBean = null;
		switch (tipoConsulta) {
			case Enum_Con_CteExt.principal:		
				cliExBean = cliExtranjeroDAO.consultaPrincipal(cliEx, tipoConsulta);				
				break;				
			case Enum_Con_CteExt.foranea:
				cliExBean = cliExtranjeroDAO.consultaForanea(cliEx, tipoConsulta);
				break;
		}
		if(cliExBean!=null){
			cliExBean.setClienteID(Utileria.completaCerosIzquierda(cliExBean.getClienteID(),CliExtranjeroBean.LONGITUD_ID));
		}
		
		return cliExBean;
	}

	//------------------ Geters y Seters ------------------------------------------------------	
	
	public void setCliExtranjeroDAO(CliExtranjeroDAO cliExtranjeroDAO) {
		this.cliExtranjeroDAO = cliExtranjeroDAO;
	}
	
}
