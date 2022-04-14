package tesoreria.servicio;

import java.util.List;

import cuentas.bean.TiposCuentaBean;
import tesoreria.bean.ProveedoresBean;
import tesoreria.bean.TipoproveedoresBean;
import tesoreria.dao.TipoproveedoresDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;


public class TipoproveedoresServicio  extends BaseServicio {

	
	//---------- Variables ------------------------------------------------------------------------
	TipoproveedoresDAO tipoproveedoresDAO = null;

	//---------- Tipos de Listas---------------------------------------------------------------
	public static interface Enum_Lis_TipoProvee{
		int principal   = 1;
	}
	public static interface Enum_Tra_TipoProvee {
		int alta = 1;
		int modificacion = 2;
		int grabarLista = 3;

	}
	
	public static interface Enum_Con_TipoProvee {
		int principal	 	= 1;
		int foranea 		= 2;
		int actualizacion 	= 3;
	}

	public TipoproveedoresServicio () {
		super();
		// TODO Auto-generated constructor stub
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TipoproveedoresBean tipoproveedores){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_TipoProvee.alta:
			mensaje = alta(tipoproveedores);
			break;
		case Enum_Tra_TipoProvee.modificacion:
			mensaje = modifica(tipoproveedores);
			break;

		}
		return mensaje;

	}
	
	
	public MensajeTransaccionBean alta(TipoproveedoresBean tipoproveedores){
		MensajeTransaccionBean mensaje = null;
		mensaje = tipoproveedoresDAO.alta(tipoproveedores);		
		return mensaje;
	}

	public MensajeTransaccionBean modifica(TipoproveedoresBean tipoproveedores){
		MensajeTransaccionBean mensaje = null;
		mensaje = tipoproveedoresDAO.modifica(tipoproveedores);		
		return mensaje;
	}
	
	// Consulta de tipo de proveedor 
	public TipoproveedoresBean consulta(int tipoConsulta, TipoproveedoresBean tipoprovBean){
		TipoproveedoresBean tipoprovee= null;
		switch(tipoConsulta){
			case Enum_Con_TipoProvee.foranea:
				tipoprovee = tipoproveedoresDAO.consultaForanea(tipoprovBean, tipoConsulta);
			break;
		
		}
		return tipoprovee;
	}
	
	// Consulta principal del tipo de proveedor 
	public TipoproveedoresBean consultaPrincipal(int tipoConsulta, TipoproveedoresBean tipoprovBean){
		TipoproveedoresBean tipoprovee= null;
		switch(tipoConsulta){
			case Enum_Con_TipoProvee.principal:
				tipoprovee = tipoproveedoresDAO.consultaPrincipal(tipoprovBean, tipoConsulta);
			break;
		
		}
		return tipoprovee;
	}
	
	public List lista(int tipoLista, TipoproveedoresBean tipoProveedorBean){		
		List listaTipoProveedor = null;
		switch (tipoLista) {
		case Enum_Lis_TipoProvee.principal:		
			listaTipoProveedor=  tipoproveedoresDAO.listaTipoProveedores(tipoProveedorBean,  Enum_Lis_TipoProvee.principal);				
			break;	
		}		
		return listaTipoProveedor;
	}


	//------------------ Geters y Seters ------------------------------------------------------	
	public TipoproveedoresDAO getTipoproveedoresDAO() {
		return tipoproveedoresDAO;
	}


	public void setTipoproveedoresDAO(TipoproveedoresDAO tipoproveedoresDAO) {
		this.tipoproveedoresDAO = tipoproveedoresDAO;
	}
	
	
	
}
