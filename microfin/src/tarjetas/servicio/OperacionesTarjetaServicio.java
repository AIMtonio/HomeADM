package tarjetas.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;

import java.util.List;

import org.springframework.core.task.TaskExecutor;

import tarjetas.bean.OperacionesTarjetaBean;
import tarjetas.beanWS.request.OperacionesTarjetaRequest;
import tarjetas.beanWS.response.OperacionesTarjetaResponse;
import tarjetas.dao.OperacionesTarjetaDAO;


public class OperacionesTarjetaServicio extends BaseServicio {

	//---------- Variables ------------------------------------------------------------------------
	private TaskExecutor taskExecutor;
	OperacionesTarjetaDAO operacionesTarjetaDAO = null;	
	TransaccionDAO transaccionDAO = null;
	long numTransaccion = 0;
	
	//---------- Tipo de Consulta ----------------------------------------------------------------


	
	//---------- tipos Transacciones ------------------------------------------------------------------------
	
	public static interface Enum_Tra_OpeTarjeta{
		int compraNormal 	= 1;
		int retiroEfectivo 	= 2;
		int consultaSaldo	= 3;
		int pago			= 4;
		int compraRetiroE	= 5;
	}
	

	
	public OperacionesTarjetaResponse grabaTransaccion(int tipoTransaccion, OperacionesTarjetaBean operacionesTarjetaBean){
		OperacionesTarjetaResponse respuesta = new OperacionesTarjetaResponse();

        switch (tipoTransaccion) {
        case Enum_Tra_OpeTarjeta.compraNormal:                
        	respuesta = operacionesTarjetaDAO.operacionTarjetaAlta(operacionesTarjetaBean);
        	//if(respuesta.getCodigoRespuesta().equals(OperacionesTarjetaBean.mensajeExito)){
        		complementoTransaccionTDCompraNormal(operacionesTarjetaBean,respuesta.getCodigoRespuesta());
        	//}
        	break;

        case Enum_Tra_OpeTarjeta.retiroEfectivo:                
        	respuesta = operacionesTarjetaDAO.operacionTarjetaAlta(operacionesTarjetaBean);
        	//if(respuesta.getCodigoRespuesta().equals(OperacionesTarjetaBean.mensajeExito)){
            	complementoTransaccionTDRetiroEfec(operacionesTarjetaBean,respuesta.getCodigoRespuesta());
        	//}
        	break;

        case Enum_Tra_OpeTarjeta.pago:                
        	respuesta = operacionesTarjetaDAO.operacionTarjetaAlta(operacionesTarjetaBean);
        	//if(respuesta.getCodigoRespuesta().equals(OperacionesTarjetaBean.mensajeExito)){
        		complementoTransaccionTDDepositoEfec(operacionesTarjetaBean,respuesta.getCodigoRespuesta());
       // 	}
        	break;

        case Enum_Tra_OpeTarjeta.consultaSaldo:         
        	respuesta = operacionesTarjetaDAO.consultaSaldoWSTarjetas(operacionesTarjetaBean, Enum_Tra_OpeTarjeta.consultaSaldo);
        	//if(respuesta.getCodigoRespuesta().equals(OperacionesTarjetaBean.mensajeExito)){
        		complementoTransaccionTDConsulta(operacionesTarjetaBean,respuesta.getCodigoRespuesta());
        	//}
        	break;
        case Enum_Tra_OpeTarjeta.compraRetiroE:         
        	respuesta = operacionesTarjetaDAO.operacionTarjetaAlta(operacionesTarjetaBean);
        	//if(respuesta.getCodigoRespuesta().equals(OperacionesTarjetaBean.mensajeExito)){
        		complementoTransaccionTDCompraRetiro(operacionesTarjetaBean,respuesta.getCodigoRespuesta());
        //	}
        	break;
        default:
        	respuesta.setNumeroTransaccion(Constantes.STRING_CERO);
			respuesta.setSaldoActualizado(Constantes.STRING_CERO);
			respuesta.setCodigoRespuesta("12");
			respuesta.setMensajeRespuesta("Transaccion Invalida.");
        }

    	respuesta.setNumeroTransaccion(String.valueOf(numTransaccion)); 
        return respuesta;
	}
	
	
	public void complementoTransaccionTDCompraNormal(final OperacionesTarjetaBean operacionesTarjetaBean, final String mensajeExito){
		taskExecutor.execute(new Runnable() {
			public void run() {
				boolean resultado = false;
				numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				operacionesTarjetaDAO.bitacoraMovsTarAlta(operacionesTarjetaBean, numTransaccion) ;
				if(mensajeExito.equals(OperacionesTarjetaBean.mensajeExito)){
					mensajeTransaccionBean =operacionesTarjetaDAO.opeTarjetaCompraNormal(operacionesTarjetaBean, numTransaccion);
				}
				//TODO : VALIDAR MENSAJE TRANSACCION DE OPERACION, SI ES ERROR METERLO EN UNA BITACORA DE OPERACION NO APLICADA.
			}
		});
	}
	
	public void complementoTransaccionTDRetiroEfec(final OperacionesTarjetaBean operacionesTarjetaBean, final String mensajeExito){
		taskExecutor.execute(new Runnable() {
			public void run() {
				boolean resultado = false;
				numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				operacionesTarjetaDAO.bitacoraMovsTarAlta(operacionesTarjetaBean, numTransaccion) ;
				if(mensajeExito.equals(OperacionesTarjetaBean.mensajeExito)){
					mensajeTransaccionBean =operacionesTarjetaDAO.opeTarjetaRetiroEfectivo(operacionesTarjetaBean, numTransaccion);
				}
				//TODO : VALIDAR MENSAJE TRANSACCION DE OPERACION, SI ES ERROR METERLO EN UNA BITACORA DE OPERACION NO APLICADA.
			}
		});
	}
	
	public void complementoTransaccionTDDepositoEfec(final OperacionesTarjetaBean operacionesTarjetaBean, final String mensajeExito){
		taskExecutor.execute(new Runnable() {
			public void run() {
				boolean resultado = false;
				numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				operacionesTarjetaDAO.bitacoraMovsTarAlta(operacionesTarjetaBean, numTransaccion) ;
				if(mensajeExito.equals(OperacionesTarjetaBean.mensajeExito)){
					mensajeTransaccionBean =operacionesTarjetaDAO.opeTarjetaDeposito(operacionesTarjetaBean, numTransaccion);
				}
				//TODO : VALIDAR MENSAJE TRANSACCION DE OPERACION, SI ES ERROR METERLO EN UNA BITACORA DE OPERACION NO APLICADA.
			}
		});
	}
	
	public void complementoTransaccionTDConsulta(final OperacionesTarjetaBean operacionesTarjetaBean, final String mensajeExito){
		taskExecutor.execute(new Runnable() {
			public void run() {
				boolean resultado = false;
				numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				operacionesTarjetaDAO.bitacoraMovsTarAlta(operacionesTarjetaBean, numTransaccion) ;
				//TODO : VALIDAR MENSAJE TRANSACCION DE OPERACION, SI ES ERROR METERLO EN UNA BITACORA DE OPERACION NO APLICADA.
			}
		});
	}
	
	public void complementoTransaccionTDCompraRetiro(final OperacionesTarjetaBean operacionesTarjetaBean, final String mensajeExito){
		taskExecutor.execute(new Runnable() {
			public void run() {
				boolean resultado = false;
				numTransaccion = transaccionDAO.generaNumeroTransaccionOut();
				MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
				operacionesTarjetaDAO.bitacoraMovsTarAlta(operacionesTarjetaBean, numTransaccion) ;
				if(mensajeExito.equals(OperacionesTarjetaBean.mensajeExito)){
					mensajeTransaccionBean =operacionesTarjetaDAO.opeTarjetaCompraRetiroEfectivo(operacionesTarjetaBean, numTransaccion);
				}
				//TODO : VALIDAR MENSAJE TRANSACCION DE OPERACION, SI ES ERROR METERLO EN UNA BITACORA DE OPERACION NO APLICADA.
			}
		});
	}
	

	// ------------------------------Getter y Setters ------------------------------ 
	 
	public void setTaskExecutor(TaskExecutor taskExecutor) {
	    this.taskExecutor = taskExecutor;
	}
	
	public OperacionesTarjetaDAO getOperacionesTarjetaDAO() {
		return operacionesTarjetaDAO;
	}
	public void setOperacionesTarjetaDAO(OperacionesTarjetaDAO operacionesTarjetaDAO) {
		this.operacionesTarjetaDAO = operacionesTarjetaDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}


	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}
}

