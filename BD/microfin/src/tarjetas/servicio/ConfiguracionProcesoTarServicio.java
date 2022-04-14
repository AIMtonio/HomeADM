package tarjetas.servicio;

import java.util.ArrayList;

import com.google.gson.Gson;

import antlr.collections.List;
import tarjetas.bean.CargaArchivosTarjetaBean;
import tarjetas.bean.ConfigFTPProsaBean;
import tarjetas.bean.DestinatariosCorreoFTPProsaBean;
import tarjetas.bean.SolicitudTarDebBean;
import tarjetas.dao.ConfiguracionProcesoTarDAO;
import tarjetas.dao.DestinatariosCorreoFTPProsaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Constantes;

public class ConfiguracionProcesoTarServicio extends BaseServicio {
	ConfiguracionProcesoTarDAO configuracionProcesoTarDAO = null;
	DestinatariosCorreoFTPProsaDAO destinatariosCorreoFTPProsaDAO = null;
	
	public ConfiguracionProcesoTarServicio(){
		super();
	}
	public static interface Enum_Tra_Graba {
		int modificaconf = 1;
	}
	public static interface Enum_Con_Config{
		int conConfig = 1;
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion,   ConfigFTPProsaBean configFTPProsaBean){
		MensajeTransaccionBean mensaje = null;
		switch(tipoTransaccion){
			case Enum_Tra_Graba.modificaconf:
				mensaje = configuracionProcesoTarDAO.confifFTPProsaMod(tipoTransaccion, configFTPProsaBean);
				break;		
		}
		return mensaje;
	}
	public ConfigFTPProsaBean consulta(int tipoConsulta, ConfigFTPProsaBean configFTPProsaBean){
		ConfigFTPProsaBean configuracion = null;
		switch(tipoConsulta){
			case Enum_Con_Config.conConfig:
				configuracion = configuracionProcesoTarDAO.principal(Enum_Con_Config.conConfig, configFTPProsaBean);
			break;	
		}
		return configuracion;
	}
	public MensajeTransaccionBean actualiza( ConfigFTPProsaBean configFTPProsaBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		mensaje = configuracionProcesoTarDAO.configFTPProsaAct(tipoTransaccion,configFTPProsaBean);		
		return mensaje;
	}
	public MensajeTransaccionBean actualizaDestinatarios(final ConfigFTPProsaBean configFTPProsaBean, int tipoTransaccion){
		MensajeTransaccionBean mensaje = null;
		DestinatariosCorreoFTPProsaBean destinatariosCorreoFTPProsaBean = null;
		java.util.List<String> destinatariosID = new ArrayList<String>();
		//dar de alta el remitente con el mensaje
		mensaje = configuracionProcesoTarDAO.configFTPProsaAct(tipoTransaccion, configFTPProsaBean);
		try {
			if (configFTPProsaBean.getUsuarioDest() != null) {
				destinatariosID = configFTPProsaBean.getUsuarioDest();
				mensaje = destinatariosCorreoFTPProsaDAO.destinatariosBaj(tipoTransaccion, destinatariosCorreoFTPProsaBean);
				if (mensaje.getNumero() == Constantes.CODIGO_SIN_ERROR) {
					for (String destina : destinatariosID) {
						destinatariosCorreoFTPProsaBean = new DestinatariosCorreoFTPProsaBean();
						if(!destina.equals("")) {
							destinatariosCorreoFTPProsaBean.setUsuario(destina);
							mensaje = destinatariosCorreoFTPProsaDAO.destinatariosAlta(destinatariosCorreoFTPProsaBean);
						}
						
					}
				}
			}	
		} catch (Exception e) {
			e.printStackTrace();
		}
		return mensaje;
	}
	public ConfiguracionProcesoTarDAO getConfiguracionProcesoTarDAO() {
		return configuracionProcesoTarDAO;
	}
	public void setConfiguracionProcesoTarDAO(
			ConfiguracionProcesoTarDAO configuracionProcesoTarDAO) {
		this.configuracionProcesoTarDAO = configuracionProcesoTarDAO;
	}
	public DestinatariosCorreoFTPProsaDAO getDestinatariosCorreoFTPProsaDAO() {
		return destinatariosCorreoFTPProsaDAO;
	}
	public void setDestinatariosCorreoFTPProsaDAO(
			DestinatariosCorreoFTPProsaDAO destinatariosCorreoFTPProsaDAO) {
		this.destinatariosCorreoFTPProsaDAO = destinatariosCorreoFTPProsaDAO;
	}
	
}
