package cliente.servicio;

import org.apache.log4j.Logger;

import cliente.bean.TransferenciaEntreCuentasBean;
import cliente.dao.TransferenciaEntreCuentasDAO;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.ParametrosAplicacionDAO;
import general.servicio.BaseServicio;
import general.servicio.ParametrosAplicacionServicio.Enum_Con_ParAplicacion;
import herramientas.Constantes;
import herramientas.Utileria;
import sms.bean.SMSEnvioMensajeBean;
import sms.dao.SMSEnvioMensajeDAO;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.servicio.ISOTRXServicio;
import tarjetas.servicio.ISOTRXServicio.Cat_Instrumentos_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Pro_OpePeticion_ISOTRX;
import tarjetas.servicio.ISOTRXServicio.Enum_Tran_ISOTRX;
import ventanilla.bean.IngresosOperacionesBean;

public class TransferenciaEntreCuentasServicio extends BaseServicio {
	
	protected final Logger loggerVent = Logger.getLogger("Vent");

	SMSEnvioMensajeDAO smsEnvioMensajeDAO = null;
	TransferenciaEntreCuentasDAO transferenciaEntreCuentasDAO = null;
	ParametrosAplicacionDAO parametrosAplicacionDAO = null;
	ISOTRXServicio isotrxServicio = null;
	ParametrosSesionBean parametrosSesionBean;
	
	public static interface Enum_Tran_Transferencia {
		int transferenciaCuenta = 1;
	}

	public static interface Enum_Ope_Transferencia {
		String transferenciaCuenta = "10";
	}
	
	public MensajeTransaccionBean grabaTransaccion(int tipoTransaccion, TransferenciaEntreCuentasBean transferenciaEntreCuentasBean){
		
		MensajeTransaccionBean mensajeTransaccionBean = null;
		try {
			
			loggerVent.info("Comienza la transaccion:" + tipoTransaccion);
			switch (tipoTransaccion) {
				case Enum_Tran_Transferencia.transferenciaCuenta:
					mensajeTransaccionBean = transferenciaEntreCuentas(transferenciaEntreCuentasBean);
				break;
				default:
					mensajeTransaccionBean = new MensajeTransaccionBean();
					mensajeTransaccionBean.setNumero(Constantes.ErrorGenerico);
					mensajeTransaccionBean.setDescripcion("Tipo de Transacción desconocida.");
				break;
			}

		} catch (Exception exception) {
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(Constantes.ErrorGenerico);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error en la Operación de Transferencias Entre Cuentas. ");
			}
			loggerVent.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
		
		return mensajeTransaccionBean;
	}
	
	/**
	 * Método para realizar la Transferencia entre Cuentas
	 * @param transferenciaEntreCuentasBean
	 * @return mensajeTransaccionBean
	 */
	public MensajeTransaccionBean transferenciaEntreCuentas(TransferenciaEntreCuentasBean transferenciaEntreCuentasBean) {
		MensajeTransaccionBean mensajeTransaccionBean = null;
		IngresosOperacionesBean ingresosOperacionesBean = null;
		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();

		long numeroTransaccion = 0;
		String descripcion = "";
		String descripcionWS = "";
		String nombreControl = "";
		String consecutivoString = "";
		String notificar = "N";
		int numeroErrorCuentaOrigen  = 0;
		int numeroErrorCuentaDestino = 0;
		
		try {

			ingresosOperacionesBean = asignacionIngresoOperaciones(transferenciaEntreCuentasBean);
			mensajeTransaccionBean = transferenciaEntreCuentasDAO.transferenciaCuentas(ingresosOperacionesBean);
			if( mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO ){
				throw new Exception(mensajeTransaccionBean.getDescripcion());
			}

			if( mensajeTransaccionBean.getNumero() == Constantes.ENTERO_CERO ){
				SMSEnvioMensajeBean smsEnvioMensajeBean = new SMSEnvioMensajeBean();
				smsEnvioMensajeBean.setCuentaAhoID(transferenciaEntreCuentasBean.getCuentaAhoID());
				smsEnvioMensajeBean.setCantidadMov(transferenciaEntreCuentasBean.getMonto());
				smsEnvioMensajeBean.setNumTransaccion(mensajeTransaccionBean.getConsecutivoInt());
				envioSMSCuentaAhorro(smsEnvioMensajeBean);
			}

			notificar = Constantes.STRING_SI;
			numeroTransaccion = Utileria.convierteLong(mensajeTransaccionBean.getConsecutivoInt());
			descripcion = mensajeTransaccionBean.getDescripcion();
			nombreControl = mensajeTransaccionBean.getNombreControl();
			consecutivoString = mensajeTransaccionBean.getConsecutivoString();

			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);

			// Proceso de tarjetas - Cuenta de Cargo
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(transferenciaEntreCuentasBean.getCuentaAhoID());
			tarjetaDebitoBean.setMontoOperacion(String.valueOf(transferenciaEntreCuentasBean.getMonto()));
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.transCuentaCargo, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoID() +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
				numeroErrorCuentaOrigen = numeroErrorCuentaOrigen + Constantes.ENTERO_UNO;
				loggerISOTRX.error("WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoID() +": "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
			}

			loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
			// Proceso de tarjetas - Cuenta de Abono
			tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
			tarjetaDebitoBean.setNumeroInstrumento(transferenciaEntreCuentasBean.getCuentaAhoIDRecepcion());
			tarjetaDebitoBean.setMontoOperacion(String.valueOf(transferenciaEntreCuentasBean.getMonto()));
			mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.transCuentaAbono, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 

			if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
				descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoIDRecepcion() +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
				mensajeTransaccionBean.setNumero(Constantes.STR_ERRORISOTRX[1]);
				numeroErrorCuentaDestino = numeroErrorCuentaDestino + Constantes.ENTERO_UNO;
				loggerISOTRX.error("WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoIDRecepcion() +": "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
			}
			
			if( numeroErrorCuentaOrigen  > Constantes.ENTERO_CERO ||
				numeroErrorCuentaDestino > Constantes.ENTERO_CERO ){
				throw new Exception();
			}

			mensajeTransaccionBean.setDescripcion(descripcion);
			mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
			mensajeTransaccionBean.setNombreControl(nombreControl);
			mensajeTransaccionBean.setConsecutivoString(consecutivoString);
			
		} catch (Exception exception) {
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error en la Operación de Transferencias Entre Cuentas. ");
			}
			loggerVent.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();

			if(notificar.equals(Constantes.STRING_SI)){
				
				// Si el proceso falla si se notifica el saldo de la Cuenta de Cargo
				if( numeroErrorCuentaOrigen > Constantes.ENTERO_CERO ){
					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
					tarjetaDebitoBean.setNumeroInstrumento(transferenciaEntreCuentasBean.getCuentaAhoID());
					
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoID() +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						loggerSAFI.error("<br><b>WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoID() +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					}
				}

				// Si el proceso falla si se notifica el saldo de la Cuenta de Abono
				if( numeroErrorCuentaDestino > Constantes.ENTERO_CERO ){
					loggerISOTRX.info(Constantes.NIVEL_SERVICIO);
					tarjetaDebitoBean.setTipoInstrumento(Cat_Instrumentos_ISOTRX.cuentaAhorro);
					tarjetaDebitoBean.setNumeroInstrumento(transferenciaEntreCuentasBean.getCuentaAhoIDRecepcion());
	
					mensajeTransaccionBean = isotrxServicio.grabaTransaccion(tarjetaDebitoBean, Enum_Pro_OpePeticion_ISOTRX.notificaSaldoCuenta, numeroTransaccion, Enum_Tran_ISOTRX.operacionPeticion); 
					if( mensajeTransaccionBean.getNumero() != Utileria.convierteEntero(Constantes.STR_CODIGOEXITOISOTRX[0]) ) {
						descripcionWS = descripcionWS + "<br><b>WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoIDRecepcion() +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion();
						loggerSAFI.error("<br><b>WS ISOTRX Cuenta "+transferenciaEntreCuentasBean.getCuentaAhoIDRecepcion() +":</b> "+mensajeTransaccionBean.getNumero() +" - "+ mensajeTransaccionBean.getDescripcion());
					}
				}

				// si la operacion se proceso en SFI y fue Existosa se regresa el objeto con mensaje exitoso y el fallo de ISOTRX al momento de notificar
				mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO );
				mensajeTransaccionBean.setDescripcion(descripcion+descripcionWS);
				mensajeTransaccionBean.setNombreControl(nombreControl);
				mensajeTransaccionBean.setConsecutivoString(consecutivoString);
			}
		}
		
		return mensajeTransaccionBean;
	}

	// Se asigna el bean de Entrada
	public IngresosOperacionesBean asignacionIngresoOperaciones(TransferenciaEntreCuentasBean transferenciaEntreCuentasBean) {

		IngresosOperacionesBean ingresosOperacionesBean = null;
		try {

			ingresosOperacionesBean = new IngresosOperacionesBean();

			ParametrosSesionBean datoSesion = new ParametrosSesionBean();
			datoSesion = parametrosAplicacionDAO.consultaFechaSucursal(parametrosSesionBean.getSucursal(), Enum_Con_ParAplicacion.fechaSucursal, parametrosSesionBean.getOrigenDatos());
			parametrosSesionBean.setFechaSucursal(datoSesion.getFechaSucursal());
			parametrosSesionBean.setFechaAplicacion(datoSesion.getFechaAplicacion());

			// cargo a cuenta
			ingresosOperacionesBean.setCuentaAhoID(transferenciaEntreCuentasBean.getCuentaAhoID());
			ingresosOperacionesBean.setClienteID(transferenciaEntreCuentasBean.getClienteID());
			ingresosOperacionesBean.setFecha(String.valueOf(parametrosSesionBean.getFechaAplicacion()));

			ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.cargoCta);
			ingresosOperacionesBean.setCantidadMov(transferenciaEntreCuentasBean.getMonto());
			ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descargoCuentaTrans);
			if( transferenciaEntreCuentasBean.getReferencia().isEmpty()) {
				ingresosOperacionesBean.setReferenciaMov(transferenciaEntreCuentasBean.getCuentaAhoID());
				ingresosOperacionesBean.setReferenciaTicket(Constantes.STRING_VACIO);
			} else {
				ingresosOperacionesBean.setReferenciaMov(transferenciaEntreCuentasBean.getReferencia());
				ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
			}
			ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovTraspasoCuenta);

			ingresosOperacionesBean.setMonedaID(transferenciaEntreCuentasBean.getMonedaID());
			ingresosOperacionesBean.setSucursalID(transferenciaEntreCuentasBean.getSucursalID());
			ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
			ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepTransfeCuentas);

			ingresosOperacionesBean.setAltaDetPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
			ingresosOperacionesBean.setConceptoAho(IngresosOperacionesBean.conceptoAhorro);
			ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);

			// abono a cuenta
			ingresosOperacionesBean.setCuentaCargoAbono(transferenciaEntreCuentasBean.getCuentaAhoIDRecepcion());
			ingresosOperacionesBean.setClienteCargoAbono(transferenciaEntreCuentasBean.getClienteIDRecepcion());
			ingresosOperacionesBean.setReferenciaCargoAbono(transferenciaEntreCuentasBean.getReferencia());
			ingresosOperacionesBean.setNumClienteTCta(transferenciaEntreCuentasBean.getNumClienteTCtaRecep());

			// para el alta en CAJASMOVS
			ingresosOperacionesBean.setCajaID(transferenciaEntreCuentasBean.getNumeroCaja());
			ingresosOperacionesBean.setMontoSBC(Constantes.STRING_CERO);
			ingresosOperacionesBean.setInstrumento(transferenciaEntreCuentasBean.getCuentaAhoID());
			ingresosOperacionesBean.setComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setiVAComision(Constantes.STRING_CERO);
			ingresosOperacionesBean.setConceptoOpDivisa(IngresosOperacionesBean.conceptoDivisa);
			ingresosOperacionesBean.setOpcionCajaID(transferenciaEntreCuentasBean.getTipoOperacion());
			ingresosOperacionesBean.setDenominaciones(Constantes.STRING_CERO);

		} catch (Exception exception) {
			ingresosOperacionesBean = null;
			loggerVent.error("Ha ocurrido un Error en la Asignación de parámetros ", exception);
			exception.printStackTrace();
		}

		return ingresosOperacionesBean;
	}

	// Notificación de Mensaje de Retiro
	private void envioSMSCuentaAhorro(final SMSEnvioMensajeBean smsEnvioMensajeBean) {

		MensajeTransaccionBean mensajeTransaccionBean = null;
		try {
			mensajeTransaccionBean = smsEnvioMensajeDAO.alertasRetirosSMSVentanilla(smsEnvioMensajeBean);
			loggerVent.info(mensajeTransaccionBean.getNumero() + " - " + mensajeTransaccionBean.getDescripcion());
		} catch (Exception exception) {
			if(mensajeTransaccionBean == null){
				mensajeTransaccionBean = new MensajeTransaccionBean();
				mensajeTransaccionBean.setNumero(999);
				mensajeTransaccionBean.setDescripcion("Ha ocurrido un Error en el Énvio de Alerta SMS en Transferencia Entre Cuentas. ");
			}
			loggerVent.error(mensajeTransaccionBean.getDescripcion(), exception);
			exception.printStackTrace();
		}
	}
 
	public SMSEnvioMensajeDAO getSmsEnvioMensajeDAO() {
		return smsEnvioMensajeDAO;
	}

	public void setSmsEnvioMensajeDAO(SMSEnvioMensajeDAO smsEnvioMensajeDAO) {
		this.smsEnvioMensajeDAO = smsEnvioMensajeDAO;
	}

	public TransferenciaEntreCuentasDAO getTransferenciaEntreCuentasDAO() {
		return transferenciaEntreCuentasDAO;
	}

	public void setTransferenciaEntreCuentasDAO(
			TransferenciaEntreCuentasDAO transferenciaEntreCuentasDAO) {
		this.transferenciaEntreCuentasDAO = transferenciaEntreCuentasDAO;
	}

	public ParametrosAplicacionDAO getParametrosAplicacionDAO() {
		return parametrosAplicacionDAO;
	}

	public void setParametrosAplicacionDAO(
			ParametrosAplicacionDAO parametrosAplicacionDAO) {
		this.parametrosAplicacionDAO = parametrosAplicacionDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public ISOTRXServicio getIsotrxServicio() {
		return isotrxServicio;
	}

	public void setIsotrxServicio(ISOTRXServicio isotrxServicio) {
		this.isotrxServicio = isotrxServicio;
	}
}
