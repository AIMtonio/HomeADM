package operacionesCRCB.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaInversionRequest;
import operacionesCRCB.beanWS.response.AltaInversionResponse;
import operacionesCRCB.dao.AltaInversionesDAO;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;

public class AltaInversionesServicio extends BaseServicio  {

	AltaInversionesDAO altaInversionesDAO = null;
	TransaccionDAO transaccionDAO 	= null;
	ISOTRXServicio isotrxServicio = null;

	private AltaInversionesServicio(){
		super();
	}
	
	public static interface Enum_Tra_Inversiones_WS {
		int altaInversion 		= 1;

	}
	
	// Metodo general para grabar transacciones
	public Object grabaTransaccion(Object object, int tipoTransaccion){
		Object response = null;
		loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
		switch (tipoTransaccion) {
			case Enum_Tra_Inversiones_WS.altaInversion:
				response = altaInvAut((AltaInversionRequest)object);
			break;
		}
		return response;
	}
	
	// Metodo Alta de Inversión
	public AltaInversionResponse altaInvAut(AltaInversionRequest altaInversionRequest){

		AltaInversionResponse altaInversionResponse = new AltaInversionResponse();
		MensajeTransaccionBean mensajeTransaccionBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		int numeroError = 0;
		try {

			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(altaInversionRequest.getCuentaAhoID());
			tarjetaDebitoBean.setMontoOperacion(altaInversionRequest.getMonto());
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.aperturaInversion, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				altaInversionResponse.setMensajeRespuesta("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				altaInversionResponse.setCodigoRespuesta(String.valueOf(Constantes.STR_ERRORISOTRX[1]));
				throw new Exception(altaInversionResponse.getMensajeRespuesta());
			}

			altaInversionResponse = altaInversionesDAO.altaInversionWS(altaInversionRequest);
			if( Utileria.convierteEntero(altaInversionResponse.getCodigoRespuesta()) != Constantes.ENTERO_CERO ) {
				numeroError = 1;
				throw new Exception(altaInversionResponse.getMensajeRespuesta());
			}

		}catch (Exception exception) {
			if( Utileria.convierteEntero(altaInversionResponse.getCodigoRespuesta()) == 0 ) {
				altaInversionResponse.setCodigoRespuesta("999");
			}
			altaInversionResponse.setMensajeRespuesta(exception.getMessage());
			altaInversionResponse.setInversionID(String.valueOf(Constantes.ENTERO_CERO));
			altaInversionResponse.setMontoISR(String.valueOf(Constantes.DOUBLE_VACIO));
			altaInversionResponse.setInteresGenerado(String.valueOf(Constantes.DOUBLE_VACIO));
			altaInversionResponse.setInteresRecibir(String.valueOf(Constantes.DOUBLE_VACIO));
			altaInversionResponse.setMontoTotal(String.valueOf(Constantes.DOUBLE_VACIO));
			altaInversionResponse.setFechaVencimiento(Constantes.FECHA_VACIA);
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Alta de Inversión por Web Service: ", exception);

			// Si el proceso falla si se notifica el saldo de la cuenta
			if( numeroError > Constantes.ENTERO_CERO){
				loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
				mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta , parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 
				if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
					mensajeTransaccionBean.setDescripcion("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
					loggerSAFI.error(mensajeTransaccionBean.getDescripcion());
				}
			}
		}

		return altaInversionResponse;
	}

	
	public AltaInversionesDAO getAltaInversionesDAO() {
		return altaInversionesDAO;
	}

	public void setAltaInversionesDAO(AltaInversionesDAO altaInversionesDAO) {
		this.altaInversionesDAO = altaInversionesDAO;
	}

	public TransaccionDAO getTransaccionDAO() {
		return transaccionDAO;
	}

	public void setTransaccionDAO(TransaccionDAO transaccionDAO) {
		this.transaccionDAO = transaccionDAO;
	}

	public ISOTRXServicio getIsotrxServicio() {
		return isotrxServicio;
	}

	public void setIsotrxServicio(ISOTRXServicio isotrxServicio) {
		this.isotrxServicio = isotrxServicio;
	}
}
