package operacionesCRCB.servicio;

import general.bean.MensajeTransaccionBean;
import general.dao.TransaccionDAO;
import general.servicio.BaseServicio;
import herramientas.Constantes;
import herramientas.Utileria;
import operacionesCRCB.beanWS.request.AltaCedesRequest;
import operacionesCRCB.beanWS.response.AltaCedesResponse;
import operacionesCRCB.dao.AltaCedesDAO;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;

public class AltaCedesServicio extends BaseServicio{
	
	AltaCedesDAO altaCedesDAO = null;
	TransaccionDAO transaccionDAO = null;
	ISOTRXServicio isotrxServicio = null;

	public AltaCedesServicio() {
		// TODO Auto-generated constructor stub
		super();
	}

	public static interface Enum_Tra_Cedes_WS {
		int altaCede 		= 1;
	}
	
	// Metodo general para grabar transacciones
	public Object grabaTransaccion(Object object, int tipoTransaccion){
		Object response = null;
		loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
		switch (tipoTransaccion) {
			case Enum_Tra_Cedes_WS.altaCede:
				response = altaCedes((AltaCedesRequest)object);
			break;
		}
		return response;
	}
	
	// Metodo Alta de Cede
	public AltaCedesResponse altaCedes(AltaCedesRequest altaCedesRequest){

		MensajeTransaccionBean mensajeTransaccionBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		AltaCedesResponse altaCedesResponse = new AltaCedesResponse();
		int numeroError = 0;
		try {
			Long numeroTransaccion = transaccionDAO.generaNumeroTransaccionOut();
			parametrosAuditoriaBean.setNumeroTransaccion(numeroTransaccion);
			
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(altaCedesRequest.getCuentaAhoID());
			tarjetaDebitoBean.setMontoOperacion(altaCedesRequest.getMonto());
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.aperturaCede, parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				altaCedesResponse.setMensajeRespuesta("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
				altaCedesResponse.setCodigoRespuesta(String.valueOf(Constantes.STR_ERRORISOTRX[1]));
				throw new Exception(altaCedesResponse.getMensajeRespuesta());
			}
			
			altaCedesResponse = altaCedesDAO.altaCedesWS(altaCedesRequest);
			if( Utileria.convierteEntero(altaCedesResponse.getCodigoRespuesta()) != Constantes.ENTERO_CERO ) {
				numeroError = 1;
				throw new Exception(altaCedesResponse.getMensajeRespuesta());
			}

		}catch (Exception exception) {
			if( Utileria.convierteEntero(altaCedesResponse.getCodigoRespuesta()) == 0 ) {
				altaCedesResponse.setCodigoRespuesta("999");
			}
			altaCedesResponse.setMensajeRespuesta(exception.getMessage());
			altaCedesResponse.setCEDEID(String.valueOf(Constantes.ENTERO_CERO));
			altaCedesResponse.setMontoISR(String.valueOf(Constantes.DOUBLE_VACIO));
			altaCedesResponse.setInteresGenerado(String.valueOf(Constantes.DOUBLE_VACIO));
			altaCedesResponse.setInteresRecibir(String.valueOf(Constantes.DOUBLE_VACIO));
			altaCedesResponse.setMontoTotal(String.valueOf(Constantes.DOUBLE_VACIO));
			altaCedesResponse.setFechaVencimiento(Constantes.FECHA_VACIA);
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en el proceso de Alta de Cede por Web Service: ", exception);
			
			// Si el proceso falla si se notifica el saldo de la cuenta
			if(numeroError > Constantes.ENTERO_CERO){
				loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
				mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta , parametrosAuditoriaBean.getNumeroTransaccion(), Enum_Tran_ISOTRX.operacionPeticion); 
				if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
					mensajeTransaccionBean.setDescripcion("WS ISOTRX: "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
					loggerSAFI.error(mensajeTransaccionBean.getDescripcion());
				}
			}
		}
		return altaCedesResponse;
	}

	public AltaCedesDAO getAltaCedesDAO() {
		return altaCedesDAO;
	}

	public void setAltaCedesDAO(AltaCedesDAO altaCedesDAO) {
		this.altaCedesDAO = altaCedesDAO;
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
