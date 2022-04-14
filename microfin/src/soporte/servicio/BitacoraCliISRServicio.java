package soporte.servicio;

import java.util.ArrayList;
import java.util.List;

import soporte.dao.BitacoraCliISRDAO;
import regulatorios.bean.RepRegCatalogoMinimoBean;

import soporte.bean.BitacoraCliISRBean;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;

public class BitacoraCliISRServicio  extends	BaseServicio{
	BitacoraCliISRDAO  bitacoraCliISRDAO =null;
	
	
	public  MensajeTransaccionBean GrabaBitacoraClientISR( BitacoraCliISRBean bitacoraCliISRBean){
		
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		
				mensaje = bitacoraCliISRDAO.limpiaHisClientesISR(bitacoraCliISRBean);
				
				return mensaje;
	}


	public BitacoraCliISRDAO getBitacoraCliISRDAO() {
		return bitacoraCliISRDAO;
	}


	public void setBitacoraCliISRDAO(BitacoraCliISRDAO bitacoraCliISRDAO) {
		this.bitacoraCliISRDAO = bitacoraCliISRDAO;
	}
	
	
}
