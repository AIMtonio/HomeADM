package tesoreria.servicio;

import soporte.bean.ParamGeneralesBean;
import soporte.servicio.ParamGeneralesServicio;
import tesoreria.bean.ResTransferenciaSantaBean;
import tesoreria.dao.ResTransferenciaSantaDAO;
import general.bean.MensajeTransaccionBean;
import general.servicio.BaseServicio;
import herramientas.Utileria;

public class ResTransferenciaSantaServicio extends BaseServicio{
	ResTransferenciaSantaDAO resTransferenciaSantaDAO = null;
	ParamGeneralesServicio paramGeneralesServicio = null;
	
	public static interface Enum_Tra_CuentaSantander {
		int respuestaTansSanta	= 1;
	}
	
	public MensajeTransaccionBean grabaResTranferSantander(int tipoTransaccion, ResTransferenciaSantaBean resTransferenciaSantaBean){
		MensajeTransaccionBean mensaje = null;		
		switch (tipoTransaccion){
			case Enum_Tra_CuentaSantander.respuestaTansSanta:
				mensaje = ProcesaArchivoRes(resTransferenciaSantaBean);
				break;
			}
		
		return mensaje;
	}
	
	public synchronized MensajeTransaccionBean ProcesaArchivoRes(final ResTransferenciaSantaBean resTransferenciaSantaBean){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			// VALIDAMOS LA CONFIGURACION ARCHIVO PROPETIES
			ParamGeneralesBean paramGeneralesBean = new ParamGeneralesBean();
			paramGeneralesBean = paramGeneralesServicio.consulta(44, paramGeneralesBean);
			
			if(paramGeneralesBean.getValorParametro()==null || paramGeneralesBean.getValorParametro()==""){
				mensaje.setNumero(800);
				mensaje.setDescripcion("El SAFI ha tenido un problema al concretar la operación." +
										" Favor de revisar la Configuración de <b>Conexión</b>");
				
				Utileria.borraArchivo(resTransferenciaSantaBean.getRutaArchivo());
				throw new Exception(mensaje.getDescripcion());
			}
			
			mensaje = resTransferenciaSantaDAO.procesaArchivoTransfer(resTransferenciaSantaBean, paramGeneralesBean.getValorParametro());
			
			if(mensaje.getNumero() != 0){
				throw new Exception(mensaje.getDescripcion());
			}

		} catch (Exception e) {
			if(mensaje .getNumero()==0){
				mensaje .setNumero(999);
				mensaje.setDescripcion("Error en Proceso el archivo");
			}
			mensaje.setDescripcion(e.getMessage());
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en Proceso el archivo", e);
		}
		
		
		return mensaje;
	}

	public ResTransferenciaSantaDAO getResTransferenciaSantaDAO() {
		return resTransferenciaSantaDAO;
	}

	public void setResTransferenciaSantaDAO(
			ResTransferenciaSantaDAO resTransferenciaSantaDAO) {
		this.resTransferenciaSantaDAO = resTransferenciaSantaDAO;
	}

	public ParamGeneralesServicio getParamGeneralesServicio() {
		return paramGeneralesServicio;
	}

	public void setParamGeneralesServicio(
			ParamGeneralesServicio paramGeneralesServicio) {
		this.paramGeneralesServicio = paramGeneralesServicio;
	}
			
	
	
}
