package operacionesCRCB.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AbonoCuentaRequest;
import operacionesCRCB.beanWS.request.RetiroCuentaRequest;
import operacionesCRCB.beanWS.response.AbonoCuentaResponse;
import operacionesCRCB.beanWS.response.RetiroCuentaResponse;
import operacionesCRCB.dao.CargoAbonoCuentaDAO;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;

public class CargoAbonoCuentaServicio extends BaseServicio{

	
	CargoAbonoCuentaDAO cargoAbonoCuentaDAO = null;
	TransaccionDAO transaccionDAO 	= null;
	ISOTRXServicio isotrxServicio = null;
	
	private CargoAbonoCuentaServicio(){
		super();
	}

	public static interface Enum_Tra_CargoAbonoCta_WS {
		int abonoCuenta 		= 1;
		int cargoCuenta			= 2;

	}
	
	// Metodo general para grabar transacciones
	public Object grabaTransaccion(Object beanRequest, int tipoTransaccion){
		Object response = null;
		loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
		switch (tipoTransaccion) {
			case Enum_Tra_CargoAbonoCta_WS.abonoCuenta:
				response = abonoCuenta((AbonoCuentaRequest)beanRequest);
			break;
			case Enum_Tra_CargoAbonoCta_WS.cargoCuenta:
				response = cargoCuenta((RetiroCuentaRequest)beanRequest);
			break;
		}
		return response;
	}
	
	// Metodo abono a cuenta
	public AbonoCuentaResponse abonoCuenta(AbonoCuentaRequest abonoCuentaRequest){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		AbonoCuentaResponse abonoCuentaResponse = new AbonoCuentaResponse();
		int numeroError = 0;
		try {

			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(abonoCuentaRequest.getCuentaAhoID());
			tarjetaDebitoBean.setMontoOperacion(abonoCuentaRequest.getMonto());
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.abonoCuenta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				abonoCuentaResponse.setMensajeRespuesta("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				abonoCuentaResponse.setCodigoRespuesta(String.valueOf(Constantes.STR_ERRORISOTRX[1]));
				throw new Exception(abonoCuentaResponse.getMensajeRespuesta());
			}
			
			abonoCuentaResponse = cargoAbonoCuentaDAO.abonoCtaWS(abonoCuentaRequest);
			if( Utileria.convierteEntero(abonoCuentaResponse.getCodigoRespuesta()) != Constantes.ENTERO_CERO ) {
				numeroError = 1;
				throw new Exception(abonoCuentaResponse.getMensajeRespuesta());
			}

		}
		catch (Exception exception) {
			if( Utileria.convierteEntero(abonoCuentaResponse.getCodigoRespuesta()) == 0 ) {
				abonoCuentaResponse.setCodigoRespuesta("999");
			}
			abonoCuentaResponse.setMensajeRespuesta(exception.getMessage());
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Abono a Cuenta por Web Service: ", exception);
			
			// Si el proceso falla si se notifica el saldo de la cuenta
			if( numeroError > Constantes.ENTERO_CERO){
				loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
				mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 
				if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
					mensajeTransaccionBean.setDescripcion("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
					loggerSAFI.error(mensajeTransaccionBean.getDescripcion());
				}
			}
		}
			
		return abonoCuentaResponse;
	}
	
	// Metodo cargo a cuenta
	public RetiroCuentaResponse cargoCuenta(RetiroCuentaRequest retiroCuentaRequest){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();			
		RetiroCuentaResponse retiroCuentaResponse = new RetiroCuentaResponse();
		
		try {

			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);			
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(retiroCuentaRequest.getCuentaAhoID());
			tarjetaDebitoBean.setMontoOperacion(retiroCuentaRequest.getMonto());
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.retiroCuenta, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				retiroCuentaResponse.setMensajeRespuesta("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				retiroCuentaResponse.setCodigoRespuesta(String.valueOf(Constantes.STR_ERRORISOTRX[1]));
				throw new Exception(retiroCuentaResponse.getMensajeRespuesta());
			}
	
			retiroCuentaResponse = cargoAbonoCuentaDAO.retiroCtaWS(retiroCuentaRequest);
			if( Utileria.convierteEntero(retiroCuentaResponse.getCodigoRespuesta()) != Constantes.ENTERO_CERO ) {
				throw new Exception(retiroCuentaResponse.getMensajeRespuesta());
			}

		}catch (Exception exception) {
			if( Utileria.convierteEntero(retiroCuentaResponse.getCodigoRespuesta()) == 0 ) {
				retiroCuentaResponse.setCodigoRespuesta("999");
			}
			retiroCuentaResponse.setMensajeRespuesta(exception.getMessage());
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Cargo a Cuenta por Web Service: ", exception);
			
			// Si el proceso falla si se notifica el saldo de la cuenta
			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta , parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 
			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				mensajeTransaccionBean.setDescripcion("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
				loggerSAFI.error(mensajeTransaccionBean.getDescripcion());
			}
		}
		return retiroCuentaResponse;
	}

	public CargoAbonoCuentaDAO getCargoAbonoCuentaDAO() {
		return cargoAbonoCuentaDAO;
	}

	public void setCargoAbonoCuentaDAO(CargoAbonoCuentaDAO cargoAbonoCuentaDAO) {
		this.cargoAbonoCuentaDAO = cargoAbonoCuentaDAO;
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
