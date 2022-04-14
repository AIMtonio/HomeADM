package cliente.servicio;
import java.util.ArrayList;
import java.util.List;
import soporte.bean.ParamGeneralesBean;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.ParamGeneralesServicio;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import cliente.bean.HuellaDigitalBean;
import cliente.dao.HuellaDigitalDAO;
/* Imports Valida Huella Repetida */
import com.digitalpersona.uareu.Engine;
import com.digitalpersona.uareu.Engine.Candidate;
import com.digitalpersona.uareu.dpfj.EngineImpl;
import com.digitalpersona.uareu.dpfj.ImporterImpl;
import com.digitalpersona.uareu.Fmd;
import com.digitalpersona.uareu.UareUException;
import com.digitalpersona.uareu.UareUGlobal;

/* End Imports Huella Repetida */

public class HuellaDigitalServicio extends BaseServicio {
	//---------- Variables ------------------------------------------------------------------------
	HuellaDigitalDAO huellaDigitalDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	UsuarioDAO usuarioDAO = null;
	ImporterImpl importer = null;
	Engine engine = null;

	public static interface Enum_Tra_Huella {
		int registro		 = 1;
		int actualiza		 = 3;
	}

	public static interface Enum_Tra_Estatus {
		int inicioRegistro		 = 10;
		int finRegistro			 = 11;
	}

	public static interface Enum_Con_Huella {
		int con_cliente 	= 1; /*consulta por cliente */
		int foranea 		= 2;
		int con_firmante		= 3;
		int noHuellas	= 4;
		int con_usuarioServ	= 6; // Esta consulta se agrega para la pantalla de la funcionalidad 15 de la carta SFP_CC_0090_Detección_PLD_en_Remesas
	}

	public static interface Enum_Lis_Huella {
		int lis_usuario			= 2;
		int lis_huellasGral		= 3;
		int lis_huelaVent		= 4;
		int lis_usuarioServ		= 5;
	}

	public HuellaDigitalServicio() {
		super();
	}

	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, HuellaDigitalBean huellaDigital){
		MensajeTransaccionBean mensaje = null;
		switch (tipoTransaccion) {
			case Enum_Tra_Huella.registro:
				mensaje = registroHuella(huellaDigital);
			break;
			case Enum_Tra_Huella.actualiza:
				mensaje = registroHuella(huellaDigital);
			break;
		}
		return mensaje;
	}

	public MensajeTransaccionBean registroHuella(HuellaDigitalBean huellaDigital){
		MensajeTransaccionBean mensaje = null;
		String[] datosCuenta = null ;
		try {

			mensaje = huellaDigitalDAO.registraHuellaDigital(huellaDigital);
		}catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.info("REG_HUELLADIGITAL: Ocurrio un error Servicio Huella - " +e);
			if(mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(901);
				mensaje.setDescripcion("Ocurrio un error al registrar la huella");
			}
		}

		return mensaje;
	}

	public HuellaDigitalBean consulta(int tipoConsulta ,HuellaDigitalBean huellaDigitalBean ){
		HuellaDigitalBean huellaDigitalBeanResponse = null;
		switch (tipoConsulta) {
			case Enum_Con_Huella.con_cliente:
				huellaDigitalBeanResponse = huellaDigitalDAO.consultaHuellaCliente(huellaDigitalBean,tipoConsulta);
			break;
			case Enum_Con_Huella.foranea:
				huellaDigitalBeanResponse = huellaDigitalDAO.consultaHuellaCliente(huellaDigitalBean,tipoConsulta);
			break;
			case Enum_Con_Huella.con_firmante:
				huellaDigitalBeanResponse = huellaDigitalDAO.consultaHuellaCliente(huellaDigitalBean,tipoConsulta);
				break;
			case Enum_Con_Huella.noHuellas:
				huellaDigitalBeanResponse = huellaDigitalDAO.consultaNoHuellas(huellaDigitalBean, Enum_Con_Huella.noHuellas);
			break;
			case Enum_Con_Huella.con_usuarioServ:
				huellaDigitalBeanResponse = huellaDigitalDAO.consultaHuellaCliente(huellaDigitalBean,tipoConsulta);
				break;
		}
		return huellaDigitalBeanResponse;
	}

	public  Object[] listaHuellasCombo(int tipoLista, HuellaDigitalBean huellaDigital) {

		List listaTiposCtas = null;

		switch(tipoLista){
			case (Enum_Lis_Huella.lis_huelaVent):
				listaTiposCtas =  huellaDigitalDAO.listaHuellaVentanilla(huellaDigital, tipoLista);
			break;
			case (Enum_Lis_Huella.lis_usuarioServ):
				listaTiposCtas =  huellaDigitalDAO.listaHuellaVentanilla(huellaDigital, tipoLista);
			break;
		}

		return listaTiposCtas.toArray();
	}


	public HuellaDigitalDAO getHuellaDigitalDAO() {
		return huellaDigitalDAO;
	}

	public void setHuellaDigitalDAO(HuellaDigitalDAO huellaDigitalDAO) {
		this.huellaDigitalDAO = huellaDigitalDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}

}