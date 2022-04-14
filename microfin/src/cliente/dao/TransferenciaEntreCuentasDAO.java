package cliente.dao;

import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import cuentas.bean.BloqueoSaldoBean;
import cuentas.dao.BloqueoSaldoDAO;
import cuentas.servicio.BloqueoSaldoServicio;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.dao.IngresosOperacionesDAO;

public class TransferenciaEntreCuentasDAO extends BaseDAO {

	BloqueoSaldoDAO			bloqueoSaldoDAO			= null;
	IngresosOperacionesDAO  ingresosOperacionesDAO	= null;
	PolizaDAO				polizaDAO				= null;
	ParametrosSesionBean	parametrosSesionBean;
	final boolean			origenVent				= true;

	public TransferenciaEntreCuentasDAO() {
		super();
	}

	public MensajeTransaccionBean transferenciaCuentas(final IngresosOperacionesBean ingresosOperacionesBean) {
		MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
		final String cuentaAhoID = ingresosOperacionesBean.getCuentaAhoID();
		if (ingresosOperacionesBean.getCantidadMov().equals(Constantes.STRING_CERO)) {
			mensajeTransaccion.setNumero(Constantes.ErrorGenerico);
			mensajeTransaccion.setDescripcion("El Monto esta Vacío");
			mensajeTransaccion.setNombreControl("monto");
			mensajeTransaccion.setConsecutivoString(Constantes.STRING_CERO);
			return mensajeTransaccion;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);		
			int contador = Constantes.ENTERO_CERO;
			while (contador <= Constantes.IntentosPoliza) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > Constantes.ENTERO_CERO) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > Constantes.ENTERO_CERO) {
				mensajeTransaccion = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeTransaccionBean = new MensajeTransaccionBean();
						String numeroPoliza = "", numeroCliente = "";
						String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
						
						BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
						try {
							// ----- se hace el Cargo a cuenta ---
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeTransaccionBean = ingresosOperacionesDAO.cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
								throw new Exception(mensajeTransaccionBean.getDescripcion());
							}
							numeroCliente = ingresosOperacionesBean.getClienteID(); //Reimpresion ticket

							numeroPoliza = mensajeTransaccionBean.getConsecutivoInt();
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							//----- se realiza el abono a cuenta ---	
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());// Reimpresion ticket											
							ingresosOperacionesBean.setNatMovimiento(IngresosOperacionesBean.abonoCta);
							ingresosOperacionesBean.setTipoMov(IngresosOperacionesBean.tipoMovTraspasoCuenta);
							ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
							ingresosOperacionesBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaCargoAbono());
							ingresosOperacionesBean.setCuentaIDDeposito(ingresosOperacionesBean.getCuentaAhoID()); //Reimpresion ticket
							ingresosOperacionesBean.setClienteID(ingresosOperacionesBean.getNumClienteTCta());
							ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getReferenciaCargoAbono());
							ingresosOperacionesBean.setAbonos(Constantes.STRING_CERO);
							ingresosOperacionesBean.setCargos(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.salidaNO);
							mensajeTransaccionBean = ingresosOperacionesDAO.cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
								throw new Exception(mensajeTransaccionBean.getDescripcion());
							}
							//Consulta si Bloquea el Saldo, del monto Depositado, de manera Automatica de acuerdo al Tipo de Cuenta										
							bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
							bloqueoSaldoBean.setTiposBloqID(BloqueoSaldoBean.TIPO_BLOQUEOAUTOMATICO);
							bloqueoSaldoBean.setNatMovimiento(BloqueoSaldoBean.NAT_BLOQUEO);
							bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getCantidadMov());
							bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
							bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaCargoAbono());
							bloqueoSaldoBean.setDescripcion(BloqueoSaldoBean.DESCRI_BLOQUEOAUTTRANSCTA);
							bloqueoSaldoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

							bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVent);

							if( bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
								bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
								mensajeTransaccionBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeTransaccionBean.getNumero() != Constantes.ENTERO_CERO) {
									throw new Exception(mensajeTransaccionBean.getDescripcion());
								}
							}

							mensajeTransaccionBean.setNumero(Constantes.ENTERO_CERO);
							mensajeTransaccionBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeTransaccionBean.setNombreControl("cuentaAhoID");
							mensajeTransaccionBean.setConsecutivoString(cuentaAhoID);
							mensajeTransaccionBean.setConsecutivoInt(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

						} catch (Exception exception) {
							if (mensajeTransaccionBean.getNumero() == Constantes.ENTERO_CERO) {
								mensajeTransaccionBean.setNumero(Constantes.ErrorGenerico);
							}
							mensajeTransaccionBean.setConsecutivoString(cuentaAhoID);
							mensajeTransaccionBean.setNombreControl("cuentaAhoID");
							mensajeTransaccionBean.setDescripcion(exception.getMessage());
							transaction.setRollbackOnly();
							exception.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Tranferencia entre Cuentas", exception);

						}
						return mensajeTransaccionBean;
					}
				});
				if(mensajeTransaccion.getNumero() != Constantes.ENTERO_CERO){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);					
				}
			} else {
				mensajeTransaccion.setNumero(Constantes.ErrorGenerico);
				mensajeTransaccion.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensajeTransaccion.setNombreControl("cuentaAhoID");
				mensajeTransaccion.setConsecutivoString(cuentaAhoID);
			}
		}
		return mensajeTransaccion;
	}

	public BloqueoSaldoDAO getBloqueoSaldoDAO() {
		return bloqueoSaldoDAO;
	}

	public void setBloqueoSaldoDAO(BloqueoSaldoDAO bloqueoSaldoDAO) {
		this.bloqueoSaldoDAO = bloqueoSaldoDAO;
	}

	public IngresosOperacionesDAO getIngresosOperacionesDAO() {
		return ingresosOperacionesDAO;
	}

	public void setIngresosOperacionesDAO(
			IngresosOperacionesDAO ingresosOperacionesDAO) {
		this.ingresosOperacionesDAO = ingresosOperacionesDAO;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

}

