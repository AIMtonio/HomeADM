package tarjetas.servicio;

import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;

import tarjetas.bean.ExtraerTarjetasBean;
import tarjetas.dao.ExtraerTarjetasDAO;

public class ExtraccionTarjetasServicio extends BaseServicio {
	ExtraerTarjetasDAO extraerTarjetasDAO  =null;
	
	public MensajeTransaccionBean grabaTransaccion (int tipoTransaccion, ExtraerTarjetasBean extraerTarjetasBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
		
		try {
			
			mensaje = extraerTarjetasDAO.procesoEstraccion(extraerTarjetasBean);
			
			
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en leer archivo de Extraccion pos");
		}
		return mensaje;
	}

	public ExtraerTarjetasDAO getExtraerTarjetasDAO() {
		return extraerTarjetasDAO;
	}

	public void setExtraerTarjetasDAO(ExtraerTarjetasDAO extraerTarjetasDAO) {
		this.extraerTarjetasDAO = extraerTarjetasDAO;
	}
	
}
