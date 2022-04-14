package operacionesCRCB.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.DesembolsoCreditoRequest;
import operacionesCRCB.beanWS.response.DesembolsoCreditoResponse;
import operacionesCRCB.dao.DesembolsoCreditoDAO;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;

public class DesembolsoCreditoServicio extends BaseServicio {

	DesembolsoCreditoDAO desembolsoCreditoDAO = null;
	ISOTRXServicio isotrxServicio = null;
	TransaccionDAO transaccionDAO 	= null;
	
	
	public DesembolsoCreditoServicio() {
		// TODO Auto-generated constructor stub
		super();
	}


	public static interface Enum_Tra_Desembolso_WS {
		int desembolso 		= 1;
	}
	
	// Metodo general para grabar transacciones
	public Object grabaTransaccion(Object object, int tipoTransaccion){
		Object response = null;
		loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
		switch (tipoTransaccion) {
			case Enum_Tra_Desembolso_WS.desembolso:
				response = desembolso((DesembolsoCreditoRequest) object);
			break;
		
		}
		return response;
	}
	
	// Metodo Desembolso de Crédito
	public DesembolsoCreditoResponse desembolso(DesembolsoCreditoRequest desembolsoCreditoRequest){

		DesembolsoCreditoResponse desembolsoCreditoResponse = new DesembolsoCreditoResponse();
		MensajeTransaccionBean mensajeTransaccionBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		int numeroError = 0;
		try {

			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.credito);
			tarjetaDebitoBean.setNumeroInstrumento(desembolsoCreditoRequest.getCreditoID());
			tarjetaDebitoBean.setMontoOperacion(Constantes.STRING_CERO);
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.desembolsoCredito, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				desembolsoCreditoResponse.setMensajeRespuesta("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				desembolsoCreditoResponse.setCodigoRespuesta(String.valueOf(Constantes.STR_ERRORISOTRX[1]));
				throw new Exception(desembolsoCreditoResponse.getMensajeRespuesta());
			}

			desembolsoCreditoResponse = desembolsoCreditoDAO.desembolsoCred(desembolsoCreditoRequest);
			if( Utileria.convierteEntero(desembolsoCreditoResponse.getCodigoRespuesta()) != Constantes.ENTERO_CERO ) {
				numeroError = 1;
				throw new Exception(desembolsoCreditoResponse.getMensajeRespuesta());
			}

		}catch (Exception exception) {
			if( Utileria.convierteEntero(desembolsoCreditoResponse.getCodigoRespuesta()) == 0 ) {
				desembolsoCreditoResponse.setCodigoRespuesta("999");
			}
			desembolsoCreditoResponse.setMensajeRespuesta(exception.getMessage());
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Desembolso de Crédito por Web Service: ", exception);

			// Si el proceso falla si se notifica el saldo de la cuenta
			if( numeroError > Constantes.ENTERO_CERO ){
				loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
				mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta , parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 
				if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
					mensajeTransaccionBean.setDescripcion("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
					loggerSAFI.error(mensajeTransaccionBean.getDescripcion());
				}
			}
		}

		return desembolsoCreditoResponse;
	}	
	
	public DesembolsoCreditoDAO getDesembolsoCreditoDAO() {
		return desembolsoCreditoDAO;
	}

	public void setDesembolsoCreditoDAO(DesembolsoCreditoDAO desembolsoCreditoDAO) {
		this.desembolsoCreditoDAO = desembolsoCreditoDAO;
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
