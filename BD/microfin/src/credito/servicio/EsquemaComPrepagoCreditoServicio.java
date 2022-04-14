package credito.servicio;

import java.util.ArrayList;
import java.util.List;
import java.util.StringTokenizer;

import javax.servlet.http.HttpServletRequest;

import originacion.bean.SolicitudCheckListBean;
import ventanilla.bean.CajasVentanillaBean;
import ventanilla.servicio.CajasVentanillaServicio;
import ventanilla.servicio.CajasVentanillaServicio.Enum_Trans_CajasVentanilla;

import credito.bean.EsquemaComPrepagoCreditoBean;
import credito.dao.EsquemaComPrepagoCreditoDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class EsquemaComPrepagoCreditoServicio extends BaseServicio{
	//---------- Variables ------------------------------------------------------------------------
	EsquemaComPrepagoCreditoDAO esquemaComPrepagoCreditoDAO = null;
	//consulta principal
	public static interface Enum_Con_EsquemaComPrepago {
		int principal   = 1;
	}
	
	public static interface Enum_Tra_EsquemaComisionPrepago {
		int alta = 1;
		int modificacion = 2;
	}

	public EsquemaComPrepagoCreditoServicio(){
	
		super();
	} 
	// TODO Auto-generated constructor stub
	
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, EsquemaComPrepagoCreditoBean  request){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
		case Enum_Tra_EsquemaComisionPrepago.alta:
			mensaje = altaEsquemaComPrepago(request);
			break; 
		case Enum_Tra_EsquemaComisionPrepago.modificacion:
			mensaje = modificaEsquemaComPrepago(request);
			break;
		}

		return mensaje;
	}

		// TODO Auto-generated method stub

	
	public MensajeTransaccionBean altaEsquemaComPrepago(EsquemaComPrepagoCreditoBean esquemaCom){
		MensajeTransaccionBean mensaje = null;
		mensaje = esquemaComPrepagoCreditoDAO.alta(esquemaCom);	
		return mensaje;
	}

	public MensajeTransaccionBean modificaEsquemaComPrepago(EsquemaComPrepagoCreditoBean esquemaCom){
		MensajeTransaccionBean mensaje = null;
		mensaje = esquemaComPrepagoCreditoDAO.modifica(esquemaCom);		
		return mensaje;
	}



	public EsquemaComPrepagoCreditoBean  consultaPrincipal(int tipoConsulta, EsquemaComPrepagoCreditoBean esquema){
		EsquemaComPrepagoCreditoBean esquemaComPrepagoCreditoBean = null;
		switch(tipoConsulta){
			case Enum_Con_EsquemaComPrepago.principal:
				esquemaComPrepagoCreditoBean = esquemaComPrepagoCreditoDAO.consultaPrincipal(esquema, Enum_Con_EsquemaComPrepago.principal);
			break;
			
		}
		return esquemaComPrepagoCreditoBean;
	}
	
	
		//------------------ Geters y Seters ------------------------------------------------------	
	
	
	public EsquemaComPrepagoCreditoDAO getEsquemaComPrepagoCreditoDAO() {
		return esquemaComPrepagoCreditoDAO;
	}


	public void setEsquemaComPrepagoCreditoDAO(
			EsquemaComPrepagoCreditoDAO esquemaComPrepagoCreditoDAO) {
		this.esquemaComPrepagoCreditoDAO = esquemaComPrepagoCreditoDAO;
	}
}
