package cliente.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


 
import cliente.bean.CicloBaseIniBean;
import cliente.dao.CicloBaseIniDAO;

public class CicloBaseIniServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	private CicloBaseIniDAO cicloBaseIniDAO = null;

	//---------- Tipod de Consulta ----------------------------------------------------------------
	public static interface Enum_Con_CicloBaseIni {
		int principal = 1;
		
	}

	
	
	public static interface Enum_Lis_CicloBaseIni {
		int principal = 1;
	
	}

	public static interface Enum_Tra_CicloBaseIni {
		int alta = 1;
		int modificacion = 2;

	}

	
	public CicloBaseIniServicio() {
		super();
		// TODO Auto-generated constructor stub
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, CicloBaseIniBean cliente){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_CicloBaseIni.alta:		
				mensaje = cicloBaseIniAlta(cliente);				
				break;				
			case Enum_Tra_CicloBaseIni.modificacion:
				mensaje = cicloBaseIniModifica(cliente);				
				break;

		}
		return mensaje;
	}
	
	public MensajeTransaccionBean cicloBaseIniAlta(CicloBaseIniBean cliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = getCicloBaseIniDAO().cicloBaseIniAlta(cliente);		
		return mensaje;
	}

	public MensajeTransaccionBean cicloBaseIniModifica(CicloBaseIniBean cliente){
		MensajeTransaccionBean mensaje = null;
		mensaje = getCicloBaseIniDAO().cicloBaseIniModifica(cliente);		
		return mensaje;
	}	

	
	public CicloBaseIniBean consultaCicloBaseIni(int tipoConsulta, String numeroCliente, String prospectoID, String productoID){
		CicloBaseIniBean cliente = null;
		switch (tipoConsulta) {
			case Enum_Con_CicloBaseIni.principal :		
				cliente = getCicloBaseIniDAO().consultaCicloBaseIni(Integer.parseInt(numeroCliente),Integer.parseInt(prospectoID),Integer.parseInt(productoID), tipoConsulta);				
				break;	
		}
		return cliente;
	}
	//------------------ Geters y Seters ------------------------------------------------------
	/**
	 * @return the cicloBaseIniDAO
	 */
	public CicloBaseIniDAO getCicloBaseIniDAO() {
		return cicloBaseIniDAO;
	}

	/**
	 * @param cicloBaseIniDAO the cicloBaseIniDAO to set
	 */
	public void setCicloBaseIniDAO(CicloBaseIniDAO cicloBaseIniDAO) {
		this.cicloBaseIniDAO = cicloBaseIniDAO;
	}
	
}
