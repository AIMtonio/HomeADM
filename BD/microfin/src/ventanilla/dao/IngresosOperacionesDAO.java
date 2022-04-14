package ventanilla.dao;

import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import psl.dao.PSLCobroSLDAO;
import psl.rest.BaseBeanResponse;
import seguridad.servicio.SeguridadRecursosServicio;
import soporte.bean.UsuarioBean;
import soporte.dao.UsuarioDAO;
import soporte.servicio.UsuarioServicio;
import tarjetas.bean.TarjetaDebitoBean;
import tarjetas.dao.TarjetaDebitoDAO;
import tarjetas.servicio.TarjetaDebitoServicio;
import ventanilla.bean.CatalogoGastosAntBean;
import ventanilla.bean.IngresosOperacionesBean;
import ventanilla.bean.ReversasOperBean;
import ventanilla.servicio.IngresosOperacionesServicio;
import ventanilla.servicio.IngresosOperacionesServicio.Enum_Tra_Ventanilla;
import arrendamiento.bean.ArrendamientosBean;
import arrendamiento.dao.ArrendamientosDAO;
import cliente.bean.ApoyoEscolarSolBean;
import cliente.bean.ClienteExMenorBean;
import cliente.bean.ClientesCancelaBean;
import cliente.bean.ServiFunFoliosBean;
import cliente.dao.ApoyoEscolarSolDAO;
import cliente.dao.ClienteExMenorDAO;
import cliente.dao.ClientesCancelaDAO;
import cliente.dao.ServiFunEntregadoDAO;
import cliente.dao.ServiFunFoliosDAO;
import cliente.servicio.ApoyoEscolarSolServicio;
import cliente.servicio.ClienteExMenorServicio;
import cliente.servicio.ClientesCancelaServicio;
import cliente.servicio.ServiFunFoliosServicio;
import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import credito.bean.AmortizacionCreditoBean;
import credito.bean.CastigosCarteraBean;
import credito.bean.CreditoDevGLBean;
import credito.bean.CreditosBean;
import credito.dao.AmortizacionCreditoDAO;
import credito.dao.CastigosCarteraDAO;
import credito.dao.CreditoDevGLDAO;
import credito.dao.CreditosDAO;
import credito.dao.SeguroVidaDAO;
import credito.servicio.AmortizacionCreditoServicio;
import credito.servicio.CastigosCarteraServicio;
import credito.servicio.CreditoDevGLServicio;
import credito.servicio.CreditosServicio;
import cuentas.bean.BloqueoSaldoBean;
import cuentas.bean.ComisionesSaldoPromedioBean;
import cuentas.bean.CuentasAhoBean;
import cuentas.dao.BloqueoSaldoDAO;
import cuentas.dao.ComisionesSaldoPromedioDAO;
import cuentas.dao.CuentasAhoDAO;
import cuentas.servicio.BloqueoSaldoServicio;


public class IngresosOperacionesDAO extends BaseDAO {

	BloqueoSaldoDAO			bloqueoSaldoDAO			= null;
	CreditosDAO				creditosDAO				= null;
	SeguroVidaDAO			seguroVidaDAO			= null;
	ParamFaltaSobraDAO		paramFaltaSobraDAO		= null;
	ServiFunEntregadoDAO	serviFunEntregadoDAO	= null;
	ApoyoEscolarSolDAO		apoyoEscolarSolDAO		= null;
	ParametrosSesionBean	parametrosSesionBean;
	TarjetaDebitoDAO		tarjetaDebitoDAO		= null;
	ClientesCancelaDAO		clientesCancelaDAO		= null;
	CatalogoGastosAntDAO	catalogoGastosAntDAO	= null;
	ClienteExMenorDAO		clienteExMenorDAO		= null;
	PolizaDAO				polizaDAO				= null;
	String					CadenaLog				= "";
	ServiFunFoliosDAO		serviFunFoliosDAO		= null;
	AmortizacionCreditoDAO	amortizacionCreditoDAO	= null;
	CastigosCarteraDAO		castigosCarteraDAO		= null;
	CreditoDevGLDAO			creditoDevGLDAO			= null;
	UsuarioDAO				usuarioDAO				= null;
	CuentasAhoDAO			cuentasAhoDAO			= null;
	ArrendamientosDAO		arrendamientosDAO		= null;
	PSLCobroSLDAO 			pslCobroSLDAO 			= null;
	ComisionesSaldoPromedioDAO comisionesSaldoPromedioDAO = null;
	ComisionesSaldoPromedioBean comisionesSaldoPromBean;

	final String			saltoLinea				= " <br> ";
	final boolean			origenVent				= true;

	double cantidadComision = 0.0;
	double montoFinalMov = 0.0;
	/**
	 * Método para dar de alta los Cargos/Abonos
	 * @param ingresosOperacionesBean : {@link IngresosOperacionesBean} Bean con la informacion de la Operación
	 * @param numTransaccion : {@link long} Numero de Transaccion
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean cargoAbonoCuenta(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CARGOABONOCTAPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?, ?,?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_NumeroMov", numTransaccion);
							sentenciaStore.setDate("Par_Fecha", parametrosSesionBean.getFechaSucursal());
							sentenciaStore.setDate("Par_FechaAplicacion", parametrosSesionBean.getFechaAplicacion());
							sentenciaStore.setString("Par_NatMovimiento", ingresosOperacionesBean.getNatMovimiento());
							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setString("Par_DescripcionMov", ingresosOperacionesBean.getDescripcionMov());
							sentenciaStore.setString("Par_ReferenciaMov", ingresosOperacionesBean.getReferenciaMov());
							sentenciaStore.setString("Par_TipoMovAhoID", ingresosOperacionesBean.getTipoMov());

							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setInt("Par_SucCliente", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());
							sentenciaStore.setInt("Par_ConceptoCon", Utileria.convierteEntero(ingresosOperacionesBean.getConceptoCon()));
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_AltaPoliza", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setInt("Par_ConceptoAho", Utileria.convierteEntero(ingresosOperacionesBean.getConceptoAho()));
							sentenciaStore.setString("Par_NatConta", ingresosOperacionesBean.getNatConta());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
							sentenciaStore.setInt("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cargo de abono en cuenta", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cargo de abono en cuenta", e);
					}
				}
				return mensajeBean;

			}
		});
		return mensaje;
	}

	/**
	 * Método para dar de alta los movimientos de la Caja
	 * @param ingresosOperacionesBean : IngresosOperacionesBean Bean con la Información de la Vaja
	 * @param numTransaccion : Número de Transaccion
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaMovsCaja(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CAJASMOVSALT(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setDate("Par_Fecha", parametrosSesionBean.getFechaSucursal());

							sentenciaStore.setLong("Par_Transaccion", numTransaccion);
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setDouble("Par_MontoEnFir", Utileria.convierteDoble(ingresosOperacionesBean.getMontoEnFirme()));
							sentenciaStore.setDouble("Par_MontoSBC", Utileria.convierteDoble(ingresosOperacionesBean.getMontoSBC()));

							sentenciaStore.setInt("Par_TipoOpe", Utileria.convierteEntero(ingresosOperacionesBean.getTipoOperacion()));
							sentenciaStore.setLong("Par_Instrumento", Utileria.convierteLong(ingresosOperacionesBean.getInstrumento()));
							sentenciaStore.setString("Par_Referencia", ingresosOperacionesBean.getReferenciaMov());

							sentenciaStore.setDouble("Par_Comision", Utileria.convierteDoble(ingresosOperacionesBean.getComision()));
							sentenciaStore.setDouble("Par_IVAComision", Utileria.convierteDoble(ingresosOperacionesBean.getiVAComision()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de movimientos en caja", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de movimientos en caja", e);
					}

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para dar de alta los movimientos de la Caja
	 * @param ingresosOperacionesBean : Bean con la información para el Alta de los movimientos de la CAja
	 * @param ingOpeBilletesMonBean : Bean con la información de las denominaciones
	 * @param numTransaccion : Número de Transacción
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return
	 */
	public MensajeTransaccionBean altaDenominacionMovimientos(final IngresosOperacionesBean ingresosOperacionesBean, final IngresosOperacionesBean ingOpeBilletesMonBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call DENOMINAMOVSALT("
									+ "?,?,?,?,?, "
									+ "?,?,?,?,?, "
									+ "?,?,?,?,?, "
									+ "?,?,?,?,?, "
									+ "?,?,?,?,?, "
									+ "?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setDate("Par_Fecha", parametrosSesionBean.getFechaSucursal());
							sentenciaStore.setLong("Par_Transaccion", numTransaccion);
							sentenciaStore.setInt("Par_Naturaleza", Utileria.convierteEntero(ingOpeBilletesMonBean.getNaturalezaDenominacion()));

							sentenciaStore.setInt("Par_DenominacionID", Utileria.convierteEntero(ingOpeBilletesMonBean.getDenominacionID()));
							sentenciaStore.setDouble("Par_Cantidad", Utileria.convierteDoble(ingOpeBilletesMonBean.getCantidadDenominacion()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingOpeBilletesMonBean.getMontoDenominacion()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());

							sentenciaStore.setString("Par_Instrumento", ingresosOperacionesBean.getInstrumento());
							sentenciaStore.setString("Par_Referencia", ingresosOperacionesBean.getReferenciaMov());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setString("Par_DesMovCaja", ingresosOperacionesBean.getDesMovCaja());

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Var_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Types.BIGINT);

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2) + ": " + resultadosStore.getString(4));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de denominacion de movimientos", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de denominacion de movimientos", e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Cobro de Comision por apertura de Credito
	 * @param ingresosOperacionesBean
	 * @param numTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean cobroComisionAperturaCredito(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call COBROCOMAPERCREPRO("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setInt("Par_ProdCreID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));

							sentenciaStore.setDouble("Par_MontoComAp", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setDouble("Par_IvaComAp", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setString("Par_ForCobroComAper", ingresosOperacionesBean.getFormaCobroComApCre());
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_OrigenPago", Constantes.ORIGEN_PAGO_VENTANILLA);
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de comision por apertura", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de comision por apertura", e);
					}

				}
				return mensajeBean;
			}
		});
		return mensaje;

	}
	/**
	 * Método para realizar la Operación de Abono a Cuenta
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la Información de la Operación
	 * @param billetesMonedas : Lista de Denominaciones
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaAbonoACuenta(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = new MensajeTransaccionBean();

			MensajeTransaccionBean mensajeVal = new MensajeTransaccionBean();
			CuentasAhoBean cuentaAhoBean = new CuentasAhoBean();

			cuentaAhoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
			cuentaAhoBean.setMontoMovimiento(ingresosOperacionesBean.getCantidadMov());
			cuentaAhoBean.setFechaMovimento(ingresosOperacionesBean.getFecha());

			mensajeVal = depCuentasValVentanilla(cuentaAhoBean);
			final CuentasAhoBean cuentaAhoBeanDentro = cuentaAhoBean;
			final MensajeTransaccionBean mensajeValDentro = mensajeVal;


			if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Monto esta Vacío");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			} else {
				String mensajeValidacion = "";
				mensajeValidacion += mensajeVal.getDescripcion();
				if (mensajeVal.getNumero() == 0 || mensajeVal.getNumero() == 3 || mensajeVal.getNumero() == 4) {
					transaccionDAO.generaNumeroTransaccion(origenVent);
					int contador = 0;
					while (contador <= 3) {
						contador++;
						polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
							break;
						}
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion(mensajeValidacion);
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
					return mensaje;
				}

				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = "";
							String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
							BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
							try {
								String mensajeValidacion = "";
								numeroPoliza = ingresosOperacionesBean.getPolizaID();
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);

								if (mensajeValDentro.getNumero() == 0) {
									mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								if (mensajeValDentro.getNumero() == 3 || mensajeValDentro.getNumero() == 4) {
									mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
									cuentaAhoBeanDentro.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
									cuentaAhoBeanDentro.setCanal("E");
									cuentaAhoBeanDentro.setMotivoLimite(mensajeValDentro.getNumero());
									cuentaAhoBeanDentro.setDescripcionLimite(mensajeValDentro.getDescripcion());
									cuentaAhoBeanDentro.setFechaMovimento(ingresosOperacionesBean.getFecha());
									MensajeTransaccionBean mensajeLimExCtas = cuentasAhoDAO.altaLimExCuentas(cuentaAhoBeanDentro, origenVent);
									if (mensajeLimExCtas.getNumero() != 0) {
										throw new Exception(mensajeLimExCtas.getDescripcion());
									}

								} else {
									if (mensajeValDentro.getNumero() == 1 || mensajeValDentro.getNumero() == 2) {
										throw new Exception(mensajeValidacion);
									}
								}

								// Se realiza el Proceso de Cobro de Comisones Pendientes de Saldo Promedio
								comisionesSaldoPromBean = new ComisionesSaldoPromedioBean();
								comisionesSaldoPromBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
								comisionesSaldoPromBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
								comisionesSaldoPromBean.setMontoMovPago(ingresosOperacionesBean.getCantidadMov());
								loggerSAFI.info("BEAN comisionesSaldoPromBean :\n"+Utileria.logJsonFormat(comisionesSaldoPromBean));
								mensajeBean = comisionesSaldoPromedioDAO.cobraComSaldoPromedio(comisionesSaldoPromBean,  parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								// Se valida si existen monto cobrado de Comison por Saldo Promedio para considerar el Monto por la parte del  Bloqueo
								if(Utileria.convierteDoble(mensajeBean.getCampoGenerico()) > Constantes.ENTERO_CERO){
									cantidadComision = Utileria.convierteDoble(mensajeBean.getCampoGenerico());
									montoFinalMov = Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov());
									bloqueoSaldoBean.setMontoBloq(String.valueOf(montoFinalMov - cantidadComision));

								}else{
									bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getCantidadMov());
								}


								//Consulta si Bloquea el Saldo, del monto Depositado, de manera Automatica de acuerdo al Tipo de Cuenta
								bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
								bloqueoSaldoBean.setTiposBloqID(BloqueoSaldoBean.TIPO_BLOQUEOAUTOMATICO);
								bloqueoSaldoBean.setNatMovimiento(BloqueoSaldoBean.NAT_BLOQUEO);
								bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
								bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
								bloqueoSaldoBean.setDescripcion(BloqueoSaldoBean.DESCRI_BLOQUEOAUTOMATICO);
								bloqueoSaldoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

								bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVent);

								if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
									mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntEfCta);

								//Reimpresion de ticket
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntEfCta);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
								// Reimpresion de ticket
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDepCta);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								// Reimpresion de ticket
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								if ((Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida())) > 0) {

									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									// Reimpresion de ticket
									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida());

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								// se hacen los movimientos por denominacion

								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());

								}

								//Se hace la insercion a la tabla de reimpresion de tickets
								ingresosOperacionesBean.setCuentaIDDeposito(ingresosOperacionesBean.getCuentaAhoID());
								ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								// Validamos la transacion de la Caja
								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Operación Realizada Exitosamente." + saltoLinea + mensajeValidacion);
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de abono a cuenta", e);

							}
							return mensajeBean;
						}
					});
					if(mensaje.getNumero() != 0){
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
						polizaDAO.bajaPoliza(bajaPolizaBean);
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar la Operación de Abono a Cuenta.", ex);
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la Operación de Abono a Cuenta.");
			}
		}
		return mensaje;
	}

	/**
	 * Método para realizar el Cargo a Cuenta
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la informacion para realizar la Operacion de Cargo a Cuenta
	 * @param billetesMonedas : Lista con las Denominaciones
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaCargoACuenta(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// se hace el Cargo a cuenta
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							/*se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida*/
							/*Movimiento de Entrada*/
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajCarCta);
							/*Reimpresion del Ticket*/
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getMontoEnFirme());
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajCarCta);
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							/*Movimiento de Salida: Efectivo o Cheque*/
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequeCargoCta);
							} else {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalEfCta);
							}

							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							/* se dan de alta movimientos de entrada de efectivo por cambio si los hubieran, siempre y cuando NO sea un Cheque la Salida*/
							if (!ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
									/*Reimpresion de Ticket*/
									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada());
									/*Movimiento de Entrada de Efectivo por Cambio*/
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}

							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							/* Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque*/
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {

								ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getCuentaAhoID());
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

								/* reimpresion de ticket*/
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);

								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {/*se hacen los movimientos por denominacion si la Salida fue en Efectivo*/

								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);

								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							/* Se hace la insercion a la tabla de reimpresion de tickets */
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							/* Validamos la transacion de la Caja*/
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
							mensajeBean.setConsecutivoInt(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en alta de cargo a cuenta", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				mensaje.setConsecutivoInt("0");
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar la operación de Alta Cargo Cuenta.", ex);
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la operación de Alta Cargo Cuenta.");
			}
		}
		return mensaje;
	}
	/**
	 * Metodo para ejecutar un deposito de garantia Liquida
	 * @param ingresosOperacionesBean
	 * @param bloqueoSaldoBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean depositoGarantiaLiquida(final IngresosOperacionesBean ingresosOperacionesBean, final BloqueoSaldoBean bloqueoSaldoBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto esta Vacío");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						String depositoEfectivo = "DE";
						String cargoCuenta = "CC";

						try {
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
							if ((ingresosOperacionesBean.getFormaPagoGL()).equals(depositoEfectivo)) { // Deposito en Efectivo
								mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntGarLiq);

								//Reimpresion de ticket
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntGarLiq);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);

								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); // Reimpresion de ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

								if (mensajeBean.getNumero() == 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajDepGarLiq);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
									ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); // Reimpresion de ticket

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
										ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
										ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion de ticket

										mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
									// se hacen los movimientos por denominacion
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
									ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
									ingresosOperacionesBean.setPolizaID(numeroPoliza);
									IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
									if (billetesMonedas.size() > 0) {
										for (int i = 0; i < billetesMonedas.size(); i++) {
											ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
											mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
											if (mensajeBean.getNumero() != 0) {
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									} else {
										mensajeBean.setNumero(999);
										mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
										mensajeBean.setNombreControl("numeroTransaccion");
										mensajeBean.setConsecutivoString("0");
										CadenaLog = "";
										CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
										loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

										throw new Exception(mensajeBean.getDescripcion());

									}
								} else {
									throw new Exception(mensajeBean.getDescripcion());
								}

								// Se setea de nuevo los beans para el detalle de póliza .....
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
								ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
								ingresosOperacionesBean.setEsDepODev(IngresosOperacionesBean.EsDeposito);
								ingresosOperacionesBean.setTipoBloq(IngresosOperacionesBean.BloqGar);
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descMovsDetalleGL);

								// se manda a llamar el store que agregará los detalles.......
								mensajeBean = agregaDetallesGL(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								//Validamos que la operacion de la Caja

								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

							} else if ((ingresosOperacionesBean.getFormaPagoGL()).equals(cargoCuenta)) { // Deposito con Cargo  aCuenta
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaDepGLCargoCta);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								//Reimpresion de ticket
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajaDepGLCargoCta);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_AbonoCuenta);
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajDepGarLiq);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								String moneda = "1";
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo); //indicamos que si tenga encabezado de los datalles en la poliza
								ingresosOperacionesBean.setConceptoCon(IngresosOperacionesBean.concepBloqGarLiq);//concepto para el bloqueo de saldo cuando se trata de un deposito de GL
								ingresosOperacionesBean.setEsDepODev(IngresosOperacionesBean.EsDeposito); //Indicamos que se trata de un Bloqueo
								ingresosOperacionesBean.setTipoBloq(IngresosOperacionesBean.BloqGar);
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descMovsDepGlCTA);
								mensajeBean = agregaDetallesGL(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								//Validamos que la operacion de la Caja

								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desMovBloqGaranLiq);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setCreditoID(ingresosOperacionesBean.getReferenciaMov());

							// Deposito Garantia liquida
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion(e.getMessage());
							}
							mensajeBean.setConsecutivoInt("0");
							mensajeBean.setNombreControl("");
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en deposito de garantia liquida", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}

	/**
	 * Pago de Arrendamiento en Efectivo Ventanilla
	 * @param ingresosOperacionesBean
	 * @param ArrendamientosBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean pagoArrendamientoEfectivo(final IngresosOperacionesBean ingresosOperacionesBean, final ArrendamientosBean arrendamientosBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(origenVent);

		int contador = 0;
		while (contador <= 3) {
			contador++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
					String numeroPoliza = "";
					try {
						numeroPoliza = ingresosOperacionesBean.getPolizaID();
						ingresosOperacionesBean.setPolizaID(numeroPoliza);
						ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
						if (Double.parseDouble(arrendamientosBean.getMontoPagarArrendamiento()) == 0) {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("El monto a pagar no es puede ser cero ");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString("0");
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean = arrendamientosDAO.PagoArrendamiento(arrendamientosBean, parametrosAuditoriaBean.getNumeroTransaccion(), Integer.parseInt(numeroPoliza), origenVent);

						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntPagArrendamiento);
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

						//Reimpresion ticket
						ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntPagArrendamiento);
						ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
						ingresosOperacionesBean.setTotalOperacion(arrendamientosBean.getMontoPagarArrendamiento());
						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalPagArrendamiento);
						ingresosOperacionesBean.setMontoEnFirme(arrendamientosBean.getMontoPagarArrendamiento());

						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
						ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
							ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

						}

						//Se hace la insercion a la tabla de reimpresion de tickets
						ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.depPagoArrendamiento);
						//MONTO
						ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
						ingresosOperacionesBean.setArrendaID(arrendamientosBean.getArrendaID());
						ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
						ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntPagArrendamiento);

						mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						// se hacen los movimientos por denominacion
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
						ingresosOperacionesBean.setPolizaID(numeroPoliza);
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
						IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
						if (billetesMonedas.size() > 0) {
							for (int i = 0; i < billetesMonedas.size(); i++) {
								ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("La Operación No Fue Realizada, Favor de Intentarlo Nuevamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString("0");
							CadenaLog = "";
							CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

							throw new Exception(mensajeBean.getDescripcion());

						}
						// Validamos la transacion de la Caja
						mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de arrendamiento en efectivo", e);

					}
					return mensajeBean;
				}
			});
		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}

	/**
	 * Pago de crédtio en Efectivo Ventanilla
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la informacion de la Operacion de Pago de Crédito
	 * @param creditosBean : Bean CreditosBean con la Información del Crédito
	 * @param billetesMonedas : Lista de Denominaciones
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagoCreditoEfectivo(final IngresosOperacionesBean ingresosOperacionesBean, final CreditosBean creditosBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion(origenVent);

			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
						String numeroPoliza = "";
						String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
						try {
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							if (Double.parseDouble(creditosBean.getMontoPagar()) > 0) {

								mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								mensajeBean = creditosDAO.PagoCredito(creditosBean, parametrosAuditoriaBean.getNumeroTransaccion(), Integer.parseInt(numeroPoliza), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntPagCre);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								//Reimpresion ticket
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntPagCre);
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
								ingresosOperacionesBean.setTotalOperacion(creditosBean.getMontoPagar());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalPagCre);
								ingresosOperacionesBean.setMontoEnFirme(creditosBean.getMontoPagar());

								if (Double.parseDouble(ingresosOperacionesBean.getGarantiaLiqAdi()) > 0) {
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getMontoPagadoCredito());
									ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getMontoPagadoCredito()); // Reimpresion ticket

								} else {
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
									ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket

								}
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion ticket

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

								}
							} else {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntGLAdi);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								//Reimpresion ticket
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntGLAdi);
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getTotalEntrada());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion de ticket

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

								}
							}

							// Se revisa si hay un valor para cobrar garantia liquida adicional
							if (Double.parseDouble(ingresosOperacionesBean.getGarantiaLiqAdi()) > 0) {
								// se hace el abono a cuenta por GL adicional
								// se hacen los movimientos por denominacion
								if (Double.parseDouble(creditosBean.getMontoPagar()) > 0) {
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
									ingresosOperacionesBean.setPolizaID(numeroPoliza);
								} else {
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);//Borrar
								}
								ingresosOperacionesBean.setCantidadMov(ingresosOperacionesBean.getGarantiaLiqAdi());
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desMovBloqGaranLiqAdi);
								ingresosOperacionesBean.setCuentaAhoID(ingresosOperacionesBean.getCtaGLAdiID());

								mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								bloqueoSaldoBean.setClienteID(ingresosOperacionesBean.getClienteID());
								bloqueoSaldoBean.setNatMovimiento(IngresosOperacionesBean.natBloqueo);
								bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCtaGLAdiID());
								bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
								bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getGarantiaLiqAdi());
								bloqueoSaldoBean.setTiposBloqID(IngresosOperacionesBean.tipoMovBloGLAdi);
								bloqueoSaldoBean.setDescripcion(IngresosOperacionesBean.desMovBloqGaranLiqAdi);
								bloqueoSaldoBean.setReferencia(creditosBean.getCreditoID()); // XXX

								// se bloquea el saldo que corresponde a GL adicional
								bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVent);
								if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
									mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								// se da de alta el movimiento de salida por GL adicional
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajDepGLAdic);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getGarantiaLiqAdi());
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCtaGLAdiID());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

							}// GA >0

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.depPagoCredito);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							ingresosOperacionesBean.setIVATicket(ingresosOperacionesBean.getiVAComision());
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setCreditoID(creditosBean.getCreditoID());
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntPagCre);

							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());

							}
							// Validamos la transacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de credito en efectivo", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar la operación de Pago de Crédito.", ex);
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la operación de Pago de Crédito.");
			}
		}
		return mensaje;
	}

	/**
	 * Método de Pago de Crédito Grupal en Efectivo
	 * @param ingresosOperacionesBean
	 * @param creditosBean
	 * @param billetesMonedas
	 * @param listaCtasGLAd
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean pagoGrupalCreditoEfectivo(final IngresosOperacionesBean ingresosOperacionesBean, final CreditosBean creditosBean, final List billetesMonedas, final List listaCtasGLAd, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(origenVent);
		int contador = 0;
		while (contador <= 3) {
			contador++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
					String numeroPoliza = "0";
					String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
					try {
						numeroPoliza = ingresosOperacionesBean.getPolizaID();
						creditosBean.setPolizaID(numeroPoliza);
						// COMIENZA PAGO DE CREDITO
						if (Utileria.convierteDoble(creditosBean.getMontoPagar()) > 0) {
							creditosBean.setFormaPago(CreditosBean.Efectivo);
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo); //Reimpresion ticket
							creditosBean.setOrigenPago(Constantes.ORIGEN_PAGO_VENTANILLA);
							mensajeBean = creditosDAO.pagoGrupalCredito(creditosBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntPagCre);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalPagCre);
							if (Utileria.convierteDoble(ingresosOperacionesBean.getGarantiaLiqAdi()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getMontoPagadoCredito());
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getMontoPagadoCredito());
							} else {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// FIN PAGO DE CREDITO ---------------------------------------------------------
						} else { // monto a pagar >0 solo se paga garantía adicional no hay pago de credito
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntGLAdi);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

							//Reimpresion ticket
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getTotalEntrada());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

						// Se revisa si hay un valor para cobrar garantia liquida adicional
						if (Utileria.convierteDoble(ingresosOperacionesBean.getGarantiaLiqAdi()) > 0) {
							IngresosOperacionesBean ingresosOperaciones = new IngresosOperacionesBean();
							// e bloquea el saldo por GL adicional
							for (int i = 0; i < listaCtasGLAd.size(); i++) {
								ingresosOperaciones = (IngresosOperacionesBean) listaCtasGLAd.get(i);
								ingresosOperacionesBean.setCantidadMov(ingresosOperaciones.getGarantiaLiqAdi());
								if (Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()) > 0) {
									// Se revisa si hay un valor para cobrar garantia liquida adicional
									if (Utileria.convierteDoble(ingresosOperacionesBean.getGarantiaLiqAdi()) > 0) {
										// se hacen los movimientos por denominacion
										if (Utileria.convierteDoble(creditosBean.getMontoPagar()) > 0) {
											ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
										} else {
											if (Integer.parseInt(numeroPoliza) == 0) {
												ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
											} else {
												ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
											}
										}
										// se hace el abono a cuenta por GL adicional
										ingresosOperacionesBean.setCantidadMov(ingresosOperaciones.getGarantiaLiqAdi());
										ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desMovBloqGaranLiqAdi);
										ingresosOperacionesBean.setCuentaAhoID(ingresosOperaciones.getCtaGLAdiID());
										ingresosOperacionesBean.setClienteID(ingresosOperaciones.getClienteID());
										ingresosOperacionesBean.setGarantiaLiqAdi(ingresosOperaciones.getGarantiaLiqAdi());
										ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntGLAdi);
										mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);

										ingresosOperacionesBean.setPolizaID(numeroPoliza);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}

										//Se hace la insercion a la tabla de reimpresion de tickets
										ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.depPagoCredito);
										ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
										ingresosOperacionesBean.setIVATicket(ingresosOperacionesBean.getiVAComision());
										ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
										ingresosOperacionesBean.setCreditoID(creditosBean.getCreditoID());
										ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
										//PAGO GRUPAL CREDITO
										mensajeBean = reimpresionTicket(ingresosOperacionesBean, creditosBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}

										bloqueoSaldoBean.setClienteID(ingresosOperacionesBean.getClienteID());
										bloqueoSaldoBean.setNatMovimiento(IngresosOperacionesBean.natBloqueo);
										bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
										bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
										bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getGarantiaLiqAdi());
										bloqueoSaldoBean.setTiposBloqID(IngresosOperacionesBean.tipoMovBloGLAdi);
										bloqueoSaldoBean.setDescripcion(IngresosOperacionesBean.desMovBloqGaranLiqAdi);
										bloqueoSaldoBean.setReferencia(creditosBean.getCreditoID());

										// se bloquea el saldo que corresponde a GL adicional
										bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVentanilla); // XXX
										if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
											mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
											if (mensajeBean.getNumero() != 0) {
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
										// se da de alta el movimiento de salida por GL adicional
										ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajDepGLAdic);
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getGarantiaLiqAdi());
										ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCuentaAhoID());
										mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
									}
								}
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {// GA >0
								//Se hace la insercion a la tabla de reimpresion de tickets
							for (int i = 0; i < listaCtasGLAd.size(); i++) {
								IngresosOperacionesBean ingresosOperaciones = new IngresosOperacionesBean();
								ingresosOperaciones = (IngresosOperacionesBean) listaCtasGLAd.get(i);
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntPagCre);
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desMovBloqGaranLiqAdi);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
								ingresosOperacionesBean.setClienteID(ingresosOperaciones.getClienteID());
								ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
								ingresosOperacionesBean.setIVATicket(ingresosOperacionesBean.getiVAComision());
								ingresosOperacionesBean.setCreditoID(creditosBean.getCreditoID());
								ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
								ingresosOperacionesBean.setGarantiaLiqAdi(Constantes.STRING_CERO);
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}
						// se hacen los movimientos por denominacion
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
						ingresosOperacionesBean.setPolizaID(numeroPoliza);
						ingresosOperacionesBean.setClienteID(ingresosOperacionesBean.getClienteCargoAbono()); // Para sacar la sucursal origen del Cliente
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
						IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
						if (billetesMonedas.size() > 0) {
							for (int i = 0; i < billetesMonedas.size(); i++) {
								ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString("0");
							CadenaLog = "";
							CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

							throw new Exception(mensajeBean.getDescripcion());
						}
						//validamos que la operacion de la Caja
						mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVentanilla);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pagogrupal decredito en efectivo", e);

					}
					return mensajeBean;
				}
			});
			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);
			}
		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}
	/**
	 * Método para realizar el pago de la comision por apertura de crédito
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean comisionAperturaCredito(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto esta Vacío");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							//Reimpresion ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajSalComApCre);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());

							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean = cobroComisionAperturaCredito(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntComApCre);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalComApCre);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());

							}

							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setDescripcionMov("COMISION POR APERTURA DE CREDITO");
							//Ticket comisionAperturaCredito
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en comision de apertura de credito", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}

		return mensaje;
	}
	/**
	 * Método para desembolso de credito en efectivo
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean desembolsoCredito(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String varMontoporDesembolsar = "";
		double totalRetirar = Double.parseDouble(ingresosOperacionesBean.getCantidadMov());
		varMontoporDesembolsar = consultaMontoPendiCredito(ingresosOperacionesBean, CreditosServicio.Enum_Con_Creditos.Con_ComDesVent);
		double montoporDesembolsar = Double.parseDouble(varMontoporDesembolsar);
		if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto esta Vacío");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}

		if (totalRetirar > montoporDesembolsar) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto a Desembolsar es Mayor al Monto Pendiente de Desembolso");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {

			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// se hace el Cargo a cuenta
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							//Movimiento de Entrada
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntDesCre);
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//Movimiento de Salida: Efectivo o Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequeDesembCredito);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);
							} else {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDesCre);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							}
							//Reimpresion ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							//Movimiento de Salida
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());//Reimpresion ticket
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//********* se dan de alta movimientos de entrada de efectivo por cambio si los hubieran
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada());//Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntDesCre);
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.retDesemCre);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							ingresosOperacionesBean.setCreditoID(ingresosOperacionesBean.getReferenciaMov());
							//TICKET  Desembolso de credito
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							CreditosBean creditos = new CreditosBean();
							creditos.setCreditoID(ingresosOperacionesBean.getReferenciaMov());
							creditos.setMontoRetDes(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = creditosDAO.actualizarMontosDesembolsados(creditos, CreditosServicio.Enum_Act_Creditos.actMontosDesembolsados, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean = creditosDAO.altaEstSolicitudCred(creditos, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}


							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
							mensajeBean.setConsecutivoInt(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en desembolso de credito", e);
						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				mensaje.setConsecutivoInt("0");
			}
		}
		return mensaje;
	}
	/**
	 * Método para devolucion de garantia Liquida
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean devolucionGarantiaLiquida(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String garatia = "";
		CreditoDevGLBean creditoDevGLBean = new CreditoDevGLBean();
		creditoDevGLBean.setCreditoID(ingresosOperacionesBean.getReferenciaMov());

		garatia = creditoDevGLDAO.consultaGarantiaLiquida(creditoDevGLBean, CreditoDevGLServicio.Enum_Con_CreditoDevGL.principal);
		if (!garatia.equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("Ya se ha Devuelto el Monto de la Garantía Liquida");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto esta Vacío");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}

		else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// se inserta el registro en la tabla de devoluciones

							mensajeBean = altaDevolucionGL(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se realiza el cargo a cuenta
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Se realiza el movimiento de entrada
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntDevGL);

							// Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntDevGL);
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setCreditoID(ingresosOperacionesBean.getReferenciaMov());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() == 0) {

								// Se realiza el movimiento de Salida
								//Movimiento de Salida: Efectivo o Cheque
								if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequeDevGarantiaLiq);

									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);// Reimpresion de ticket
								} else {
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDevGL);

									// Reimpresion de ticket
									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
									ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());
								}

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

								//********* se dan de alta movimientos de entrada de efectivo por cambio si los hubieran
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada());// Reimpresion de ticket
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

								}

								// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
								if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
									mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
									ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
									IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
									if (billetesMonedas.size() > 0) {
										for (int i = 0; i < billetesMonedas.size(); i++) {
											ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
											mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
											if (mensajeBean.getNumero() != 0) {
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									} else {
										mensajeBean.setNumero(999);
										mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
										mensajeBean.setNombreControl("numeroTransaccion");
										mensajeBean.setConsecutivoString("0");
										CadenaLog = "";
										CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
										loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								// Se setea de nuevo los beans para el detalle de póliza
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
								ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.abonoCta);
								ingresosOperacionesBean.setEsDepODev(IngresosOperacionesBean.EsDevolucion);
								ingresosOperacionesBean.setTipoBloq(IngresosOperacionesBean.BloqGar);
								// se manda a llamar el store que agregará los detalles
								mensajeBean = agregaDetallesGL(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								//validamos que la operacion de la Caja
								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								//Se hace la insercion a la tabla de reimpresion de tickets
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desMovDevGaranLiq);
								ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
								ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
								//Ticket devolucionGarantiaLiquida
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion(e.getMessage());
							}
							mensajeBean.setConsecutivoInt("0");
							mensajeBean.setNombreControl("");
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en devolucion de garantia liquida", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * Se da de alta la devolucion de la GL
	 * @param ingresosOperacionesBean
	 * @param numeroTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean altaDevolucionGL(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CREDITODEVGLALT(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getReferenciaMov()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_CuentaID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));

							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setString("Par_Fecha", String.valueOf(parametrosSesionBean.getFechaSucursal()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de la Devolucion de GL", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de la Devolucion de GL", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * METODO PAGO SEGURO DE VIDA, RELACIONADO AL CREDITO, SUCEDE CUANDO, EL CAJERO PAGA EL SEGURO EN CASO DE SINIESTRO
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean pagoSeguroVida(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String estatusSeg = "";

		estatusSeg = consultaEstatusSeguroVida(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_EstatusSegVida.consultaEstatus);
		if (!estatusSeg.equals("V")) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Poliza de Cobertura no se Encuentra Vigente.");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		} else {

			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {

							// Se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							//Movimiento de Salida
							//Movimiento de Salida: Efectivo o Cheque
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequePagoCobRiesgo);
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajaChequePagoCobRiesgo);// Reimpresion ticket
							} else {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaSalpagoseguroVida);
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajaSalpagoseguroVida); // Reimpresion ticket
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida()); //6000
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());//Reimpresion ticket

							}

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//movimiento en caja de ENTRADA
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaEntpagoseguroVida);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov()); //500

							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//********* se dan de alta movimientos de ENTRADA de efectivo por CAMBIO si los hubieran
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);//1000
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); // Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se realizan los movimientos contables, se actualiza el estatus del seguro y se obtiene la poliza
							mensajeBean = aplicaSeguroVidaPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getClienteID());
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque); //Reimpresion ticket

								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());

								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo); //Reimpresion ticket
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());

								}
							}

							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							if (!ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								//Se hace la insercion a la tabla de reimpresion de tickets
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoSegAyuda);
								ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
								ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
								// Ticket pagoSeguroVida
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de seguro de vida", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;

	}
	/**
	 * METODO PARA EL COBRO DEL SEGURO DE VIDA ES EL COBRO DEL CAJERO DEL MONTO DE SEGURO DE VIDA, RELACIONADO AL CREDITO
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean cobroSeguroVida(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String saldo = "";
		saldo = consultaCoberturaRiesgo(ingresosOperacionesBean, CreditosServicio.Enum_Con_Creditos.Con_ComDesVent);

		double montoPendiente = Double.parseDouble(saldo);
		double cantidadMov = Double.parseDouble(ingresosOperacionesBean.getCantidadMov());
		if (cantidadMov > montoPendiente) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto del Pago es mayor al Adeudo");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// Se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida

							// Movimiento en caja de Salida:Efectivo o Cheque
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaSalCobroseguroVida);

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajaSalCobroseguroVida);
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getMontoEnFirme());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Movimiento en caja de Entrada
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaEntCobroseguroVida);
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//********* se dan de alta movimientos de SALIDA de efectivo por CAMBIO si los hubieran
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida());//Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

							}
							//Se realizan los movimientos contables,se actualiza estatus de seguro y genera poliza
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeBean = cobroSeguroVidaPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID()); // registra el numero de caja
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());

							}

							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desCobroSegAyuda);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							// Ticket cobroSeguroVida
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de seguro de vida", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;

	}
	//CONSULTA PARA DISPONIBLE POR DENOMINACION
	public List  consultaDisponibleDenominacion(final IngresosOperacionesBean ingresosOperacionesBean, final int tipoConsulta){
		List listIngresosOperacionesBean = null ;
		try{

			//Query con el Store Procedure
			String query = "call BALANZADENOMCON(?,?,?,?,?, ?,?,?,?,?, ?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()),
					Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()),
					Utileria.convierteEntero(ingresosOperacionesBean.getDenominacionID()),
					Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()),
					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"IngresosOperacionesDAO.consultaDisponibleDenominacion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call BALANZADENOMCON(" + Arrays.toString(parametros)  +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					IngresosOperacionesBean ingresosOperacionesBean = new IngresosOperacionesBean();
					ingresosOperacionesBean.setSucursalID(resultSet.getString(1));
					ingresosOperacionesBean.setCajaID(resultSet.getString(2));
					ingresosOperacionesBean.setDenominacionID(resultSet.getString(3));
					ingresosOperacionesBean.setCantidadDenominacion(resultSet.getString(4));
					return ingresosOperacionesBean;
				}
			});
			listIngresosOperacionesBean= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta disponible en denominacion", e);

		}
		return listIngresosOperacionesBean;
	}

	public MensajeTransaccionBean aplicaSeguroVidaPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call APLICASEGUROVIDAPRO(?,?,?,?,?  ,?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SeguroVidaID", Utileria.convierteEntero(ingresosOperacionesBean.getSeguroVidaID()));
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setInt("Par_ProdCreID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));
							sentenciaStore.setDouble("Par_MontoPago", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en aplica segurode vida", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en aplica segurode vida", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para realizar el proceso de cobro sel Seguro de Vida
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean cobroSeguroVidaPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call COBROSEGUROVIDAPRO(?,?,?,?,?  ,?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SeguroVidaID", Utileria.convierteEntero(ingresosOperacionesBean.getSeguroVidaID()));
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setInt("Par_ProdCreID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));
							sentenciaStore.setDouble("Par_MontoPago", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de seguro de vida", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de seguro de vida", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * METODO PARA EL CAMBIO DE EFECTIVO EN CAJA
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean cambioEfectivo(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(origenVent);
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String numeroPoliza = "";
				try {
					// Operacion de Entrada
					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaEntCambioEfec);
					ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajaEntCambioEfec);//Reimpresion ticket

					if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
						//Reimpresion ticket
						ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getTotalEntrada());
						ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEfectivo());
					}
					mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					//Operacion de Salida
					ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaSalCambioEfec);
					if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

						ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //ReimpresionTicket
					}
					mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
					// se hacen los movimientos por denominacion
					IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
					ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
					ingresosOperacionesBean.setReferenciaMov(IngresosOperacionesBean.cambioEfectivo);
					if (billetesMonedas.size() > 0) {
						for (int i = 0; i < billetesMonedas.size(); i++) {
							ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
							if (i == 0) { // Para la primera Denomincion se da de alta de la Poliza
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaSi);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								numeroPoliza = mensajeBean.getConsecutivoInt();
							} else {
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							}
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} else {
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString("0");
						CadenaLog = "";
						CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
						loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

						throw new Exception(mensajeBean.getDescripcion());

					}
					//validamos que la	 operacion de la Caja

					mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					//Se hace la insercion a la tabla de reimpresion de tickets
					ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.cambioEfectivo);
					ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
					ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
					// Cambio de Efectivo
					mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}

					mensajeBean.setNumero(0);
					mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
					mensajeBean.setNombreControl("numeroTransaccion");
					mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Cambio de Efectivo", e);

				}
				return mensajeBean;
			}
		});
		return mensaje;

	}
	/**
	 * Método para realizar el Proceso de Transferencia entre Cuentas
	 * @param ingresosOperacionesBean
	 * @return
	 */
	public MensajeTransaccionBean transferenciaCuentas(final IngresosOperacionesBean ingresosOperacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto esta Vacío");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "", numeroCliente = "";
						String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
						BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
						try {
							// ----- se hace el Cargo a cuenta ---
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							numeroCliente = ingresosOperacionesBean.getClienteID(); //Reimpresion ticket

							numeroPoliza = mensajeBean.getConsecutivoInt();
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							//----- se realiza el abono a cuenta ---
							String NO = "N";
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
							ingresosOperacionesBean.setAltaEnPoliza(NO);
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
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

							if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
								bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
								mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntCajaTransferCta);
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntCajaTransferCta); //Reimpresion ticket

							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); // Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalCajaTransferCta);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//validamos que la operacion de la Caja

							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descargoCuentaTrans);
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_AbonoCuenta);
							ingresosOperacionesBean.setClienteID(numeroCliente);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							// Ticket transferenciaCuentas
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Tranferencia entre Cuentas", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	public MensajeTransaccionBean agregaDetallePoliza(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion){
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

					try {

						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call DETALLEPOLIZAPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,? ,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_Poliza",Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
									sentenciaStore.setInt("Par_Empresa",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setDate("Par_Fecha",OperacionesFechas.conversionStrDate(ingresosOperacionesBean.getFecha()));
									sentenciaStore.setInt("Par_Cliente",Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
									sentenciaStore.setInt("Par_ConceptoOpera",Utileria.convierteEntero(ingresosOperacionesBean.getConceptoAho()));
									sentenciaStore.setLong("Par_CuentaID",Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
									sentenciaStore.setInt("Par_Moneda",Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
									sentenciaStore.setDouble("Par_Cargos",Utileria.convierteDoble(ingresosOperacionesBean.getCargos()));
									sentenciaStore.setDouble("Par_Abonos",Utileria.convierteDoble(ingresosOperacionesBean.getAbonos()));
									sentenciaStore.setString("Par_Descripcion",ingresosOperacionesBean.getDescripcionMov());
									sentenciaStore.setString("Par_Referencia",ingresosOperacionesBean.getCuentaAhoID());
									sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

									return sentenciaStore;
								}
							},new CallableStatementCallback() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if(callableStatement.execute()){
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);
						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
						}else if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					} catch (Exception e) {

						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en alta de detalle de la poliza", e);

					}
					return mensajeBean;
				}
			});
			return mensaje;
	}
	/**
	 * Método para Realizar el Proceso de Pago de Aportación Social
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean aportacionSocial(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String saldo = "";
		saldo = consultaSaldoAportacionSoc(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_AportacionSocial.consultaSaldo);
		String datos[] = saldo.split("&");
		double saldoAportacion = Double.parseDouble(datos[0]);
		double montoAportacion = Double.parseDouble(datos[1]);
		double cantidadMov = Double.parseDouble(ingresosOperacionesBean.getCantidadMov());
		double totalSaldo = saldoAportacion + cantidadMov;

		if (totalSaldo > montoAportacion) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto del Deposito Excede el Monto de Aportacion Solicitado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto esta Vacío");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// ----- Se realiza el alta de la Aportacion del Socio, se realiza el alta de Movimientos
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeBean = aportacionSocioPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntAportacionSocio);
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntAportacionSocio); //Reimpresion ticket

							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalAportacionSocio);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

							//Reimpresion ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// movimiento de Salida por Cambio
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());

							}
							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());

							// Ticket aportacionSocial
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Tranferencia entre Cuentas", e);

						}

						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * Método que realiza el proceso del Pago de la Aportación Social del Cliente
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean aportacionSocioPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call APORTACIONSOCIOPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_NumeroMov", numeroTransaccion);
							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID())); //?? checar como enviar
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago de la Aportacion Social", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago de la Aportacion Social", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método de Devolución de la Aportación Social
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean devolucionAportacionSocial(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		try {
			String saldo = "";
			saldo = consultaSaldoAportacionSoc(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_AportacionSocial.consultaSaldoDev);
			saldo = saldo.replace(",", "");
			String datos[] = saldo.split("&");

			double saldoAportacion = Double.parseDouble(datos[0]);
			double cantidadMov = Double.parseDouble(ingresosOperacionesBean.getCantidadMov());

			if (cantidadMov != saldoAportacion) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Monto de la Devolucion no es Igual al Saldo Disponible");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}
			if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Monto esta Vacío");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			} else {
				transaccionDAO.generaNumeroTransaccion(origenVent);
				int contador = 0;
				while (contador <= 3) {
					contador++;
					polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
						break;
					}
				}
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = "";
							try {
								// -----  se realiza el alta de Movimientos de la aportacion y la actualizacion del saldo
								numeroPoliza = ingresosOperacionesBean.getPolizaID();
								ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								mensajeBean = devolucionAportacionSocio(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								// Se hace el alta de los dos movimientos de caja de entrada
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntDevolucionAS);
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntDevolucionAS); //Reimpresion ticket

								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								// Se hace el alta de los dos movimientos de caja de Salida
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());
								}

								//Movimiento de Salida: Efectivo o Cheque
								if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequeDevAportaSocial);
									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque); //Reimpresion ticket
								} else {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalDevolucionAS);
									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo); //Reimpresion ticket
								}

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								// movimiento de Salida por Cambio
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaEntCambioEfec);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}

								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());

								// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
								if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
									mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								} else {
									// se hacen los movimientos por denominacion
									IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
									ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
									if (billetesMonedas.size() > 0) {
										for (int i = 0; i < billetesMonedas.size(); i++) {
											ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
											mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
											if (mensajeBean.getNumero() != 0) {
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									} else {
										mensajeBean.setNumero(999);
										mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
										mensajeBean.setNombreControl("numeroTransaccion");
										mensajeBean.setConsecutivoString("0");
										CadenaLog = "";
										CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
										loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

										throw new Exception(mensajeBean.getDescripcion());

									}
								}
								//validamos que la operacion de la Caja

								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								//Se hace la insercion a la tabla de reimpresion de tickets
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desDevolucionASocio);
								ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
								//Ticket devolucionAportacionSocial
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Tranferencia entre Cuentas", e);

							}
							return mensajeBean;
						}
					});
					if(mensaje.getNumero() != 0){
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
						polizaDAO.bajaPoliza(bajaPolizaBean);
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}
			}

		} catch (Exception e) {

			mensaje.setDescripcion("Error en la Devolucion de Aportacion Social");
			e.printStackTrace();
			loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "la Devolucion de Aportacion Social", e);
		}

		return mensaje;
	}
	/**
	 *
	 * @param ingresosOperacionesBean
	 * @param numeroTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean devolucionAportacionSocio(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call APORTASOCIODEVPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_NumeroMov", numeroTransaccion);
							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID())); //?? checar como enviar
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago de la Aportacion Social", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago de la Aportacion Social", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * COBRO SEGURO DE AYUDA SUCEDE CUANDO EL CAJERO COBRA AL CLIENTE EL MONTO DEL SEGURO DE AYUDA, NO RELACIONADO AL CREDITO
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean cobroSeguroAyuda(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(origenVent);
		int contador = 0;
		while (contador <= 3) {
			contador++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "";
					try {

						numeroPoliza = ingresosOperacionesBean.getPolizaID();
						ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
						ingresosOperacionesBean.setPolizaID(numeroPoliza);
						mensajeBean = seguroClienteAyudaPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntCobroSegAyuda);
						ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntCobroSegAyuda);

						if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
						}
						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalCobroSegAyuda);
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

						ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						// movimiento de Salida por Cambio
						if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

							ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						// se hacen los movimientos por denominacion
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
						IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
						if (billetesMonedas.size() > 0) {
							for (int i = 0; i < billetesMonedas.size(); i++) {
								ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString("0");
							CadenaLog = "";
							CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

							throw new Exception(mensajeBean.getDescripcion());

						}
						//validamos que la operacion de la Caja

						mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//Se hace la insercion a la tabla de reimpresion de tickets
						ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desCobroSegAyuda);
						ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
						ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
						ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());

						// Ticket cobroSeguroAyuda
						mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en cobro Seguro Ayuda", e);

					}
					return mensajeBean;
				}
			});
			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);
			}
		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}
	//--------------------------------COBRO del seguro de Ayuda
	/**
	 * Método para realizar el procesode Cobro de Seguro de Ayuda
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean seguroClienteAyudaPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SEGUROCLIENTEPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_NumeroMov", numeroTransaccion);
							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cobro del Seguro de Vida", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Cobro del Seguro de Vida", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	// ------------------ PAGO del seguro de Ayuda   ------------------
	// ------------------ SUCEDE CUANDO EL CAJERO LE PAGA AL CLIENTE, EL MONTO DE LA POLIZA, NO RELACIONADO AL CREDITO, EN CASO SE SINIESTRO ------------------
	public MensajeTransaccionBean pagoSeguroAyuda(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String estatusSeg = "";

		estatusSeg = consultaAplicaSeguroVida(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_AplicaSeguroAyuda.consultaEstatus);
		if (estatusSeg.equals(IngresosOperacionesBean.estatusCobrado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Seguro de Ayuda ya fue Cobrado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");

		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// ----- Se realiza el alta de la Aportacion del Socio, se realiza el alta de Movimientos

							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeBean = pagoSeguroClienteAyudaPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Se hace el alta del movimiento de caja de entrada
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntCPagoSegAyuda);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

							//Reimpresion de ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntCPagoSegAyuda);

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Se hace el alta del movimiento de caja de Salida: Efectivo o Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequeAplicaSegAyuda);

								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque); //Reimpresion ticket
							} else {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalPagoSegAyuda);

								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo); //Reimpresion ticket
							}

							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// movimiento de Salida por Cambio
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);

							// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getClienteID());
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							//validamos que la operacion de la Caja

							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoSegAyuda);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setPolizaID(ingresosOperacionesBean.getPolizaSeguro());
							// Ticket pagoSeguroAyuda
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago del Seguro de Ayuda", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * Método para realizar el Pago de Seguro de Ayuda
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagoSeguroClienteAyudaPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call SEGUROCLIPAGOPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_NumeroMov", numeroTransaccion);
							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));
							sentenciaStore.setInt("Par_SeguroClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaSeguro()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago del Seguro de Ayuda", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago del Seguro de Ayuda", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para Realizar el Proceso de Pago de Remesas
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean pagoRemesas(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String NumeroReferencia = "";

		if (mensaje.getNumero() == 0) {
			NumeroReferencia = consultaRemesas(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_Remesas.consultafolio);
			if (!NumeroReferencia.equals("0")) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("La Referencia Indicada ya fue Pagada");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");

			} else {

				transaccionDAO.generaNumeroTransaccion(origenVent);
				int contador = 0;
				while (contador <= 3) {
					contador++;
					polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
						break;
					}
				}
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = "";
							String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
							BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
							try {
								// ----- Se realiza el alta del Pago de la Remesa, se da de alta la poliza y detalle de la poliza contable
								numeroPoliza = ingresosOperacionesBean.getPolizaID();
								ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								mensajeBean = pagoRemesasPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								//Operacion de Entrada en Caja
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntradaPagoRemesa);
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntradaPagoRemesa); //Reimpresion ticket

								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);

								// Operacion de Salida
								if (ingresosOperacionesBean.getFormaPago().equals(IngresosOperacionesBean.formaPago_AbonoCuenta)) {

									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_AbonoCuenta);// Reimpresion ticket

									// El Cliente no se llevo el efectivo (Lo deposito a su Cuenta)
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalRemesaAbonoCta);
									if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

									}

									//Alta del movimiento de Salida en Caja
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

									mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
									//Consulta si Bloquea el Saldo, del monto Depositado, de manera Automatica de acuerdo al Tipo de Cuenta
									bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
									bloqueoSaldoBean.setTiposBloqID(BloqueoSaldoBean.TIPO_BLOQUEOAUTOMATICO);
									bloqueoSaldoBean.setNatMovimiento(BloqueoSaldoBean.NAT_BLOQUEO);
									bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getCantidadMov());
									bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
									//bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
									bloqueoSaldoBean.setDescripcion(BloqueoSaldoBean.DESCRI_BLOQUEOAUTPAGOREM);
									bloqueoSaldoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

									ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID()); //Reimpresion ticket
									bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVent);

									if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
										bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
										mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
									//validamos que la operacion de la Caja

									mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								} else if (ingresosOperacionesBean.getFormaPago().equals(IngresosOperacionesBean.formaPago_Efectivo)) {
									// El Cliente se llevo el Efectivo
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalidaPagoRemesa);
									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo); //Reimpresion ticket
									if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
										ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
									}
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
									// movimiento de Salida por Cambio (Si lo Hay)
									if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
										ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

										ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
										mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}

									// se hacen los movimientos por denominacion
									IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
									ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
									if (billetesMonedas.size() > 0) {
										for (int i = 0; i < billetesMonedas.size(); i++) {
											ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
											mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
											if (mensajeBean.getNumero() != 0) {
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									} else {
										mensajeBean.setNumero(999);
										mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
										mensajeBean.setNombreControl("numeroTransaccion");
										mensajeBean.setConsecutivoString("0");
										CadenaLog = "";
										CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
										loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

										throw new Exception(mensajeBean.getDescripcion());

									}
									//validamos que la operacion de la Caja

									mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								} else {
									//Salida por Cheque
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequePagoRemesa);

									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque); //Reimpresion ticket

									if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									}

									//Alta del movimiento de Salida en Caja
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

									//Registramos la Salida del Cheque
									mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
									mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

								}

								//Se hace la insercion a la tabla de reimpresion de tickets
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoRemesas);
								ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
								//pagoRemesas
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago de remesa", e);

							}
							return mensajeBean;
						}
					});
					if(mensaje.getNumero() != 0){
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
						polizaDAO.bajaPoliza(bajaPolizaBean);
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}
			}
		}
		return mensaje;
	}

	/**
	 * Método que Realiza el Proceso de Pago de Remesas
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return
	 */
	public MensajeTransaccionBean pagoRemesasPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOREMESASPRO(" + "?,?,?,?,?, ?,?,?,?,?," + "?,?,?,?,?, ?,?,?,?,?," + "?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_RemesaFolio", ingresosOperacionesBean.getReferenciaPago());
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setString("Par_NombreCompleto", ingresosOperacionesBean.getNombreCliente());
							sentenciaStore.setString("Par_Direccion", ingresosOperacionesBean.getDireccionCliente());

							sentenciaStore.setString("Par_NumTelefono", ingresosOperacionesBean.getTelefonoCliente());
							sentenciaStore.setInt("Par_TipoIdentiID", Utileria.convierteEntero(ingresosOperacionesBean.getTipoIdentifiCliente()));
							sentenciaStore.setString("Par_FolioIdentific", ingresosOperacionesBean.getFolioIdentifiCliente());
							sentenciaStore.setString("Par_FormaPago", ingresosOperacionesBean.getFormaPago());
							sentenciaStore.setLong("Par_NumeroCuenta", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));
							sentenciaStore.setLong("Par_NumeroMov", numeroTransaccion);

							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setInt("Par_RemesaCatalogoID", Utileria.convierteEntero(ingresosOperacionesBean.getRemesaCatalogoID()));
							sentenciaStore.setInt("Par_UsuarioServicioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuarioID()));
							
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());

							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método que Realiza el Proceso de Pago de Oportunidades
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean pagoOportunidades(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String NumeroReferencia = "";
		NumeroReferencia = consultaOportunidades(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_Oportunidades.consultafolio);
		if (!NumeroReferencia.equals("0")) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Referencia Indicada ya fue Pagada");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");

		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
						BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
						try {
							// ----- Se realiza el alta del Pago de la Remesa, se da de alta la poliza y detalle de la poliza contable
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeBean = pagoOportunidadesPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntPagoOportnidads);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntPagoOportnidads);
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
							// El Cliente deposita su pago a su cuenta
							if (ingresosOperacionesBean.getFormaPago().equals(IngresosOperacionesBean.formaPago_AbonoCuenta)) {

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalPagoOportAbonoCta); // 83 salida Abono a Cuta
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_AbonoCuenta);
								if (Float.parseFloat(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								}
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								//Consulta si Bloquea el Saldo, del monto Depositado, de manera Automatica de acuerdo al Tipo de Cuenta
								bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
								bloqueoSaldoBean.setTiposBloqID(BloqueoSaldoBean.TIPO_BLOQUEOAUTOMATICO);
								bloqueoSaldoBean.setNatMovimiento(BloqueoSaldoBean.NAT_BLOQUEO);
								bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getCantidadMov());
								bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
								bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
								bloqueoSaldoBean.setDescripcion(BloqueoSaldoBean.DESCRI_BLOQUEOAUTPAGOPORT);
								bloqueoSaldoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

								bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVent);

								if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
									bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
									mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								//validamos que la operacion de la Caja

								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else if (ingresosOperacionesBean.getFormaPago().equals(IngresosOperacionesBean.formaPago_Efectivo)) {
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalPagoOportnidads);
								if (Float.parseFloat(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
								}
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								// movimiento de Salida por Cambio
								if (Float.parseFloat(ingresosOperacionesBean.getTotalEntrada()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								// se hacen los movimientos por denominacion
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								//validamos que la operacion de la Caja

								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {
								//Salida por Cheque
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequePagoOportun);
								if (Float.parseFloat(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								}
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);
								//Alta del movimiento de Salida en Caja
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								//Registramos la Salida del Cheque
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoOportunidades);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							// TICKET pagoOportunidades
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago de remesa", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}

	public String consultaRemesas(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String folioRemesa = "0";

		try{
			String query = "call PAGOREMESASCON(?,?,?,?,?,  ?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getReferenciaPago(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOREMESASCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String folio = new String();

					folio=resultSet.getString("Remesafolio");
						return folio;
				}
			});
		folioRemesa= matches.size() > 0 ? (String) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de folio de Remesas", e);

		}
		return folioRemesa;
	}

	public String consultaOportunidades(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String folioOportundidades = "0";

		try{
			String query = "call PAGOPORTUNIDADESCON(?,?,?,?,?,  ?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getReferenciaPago(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PAGOPORTUNIDADESCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String oportunidades = new String();

					oportunidades=resultSet.getString("Referencia");
						return oportunidades;
				}
			});
		folioOportundidades= matches.size() > 0 ? (String) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de folio de Oportunidades", e);

		}
		return folioOportundidades;
	}

	public String consultaAplicaSeguroVida(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String estatusSeguro = "";

		try{
			String query = "call SEGUROCLIENTECON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getPolizaSeguro(),
									ingresosOperacionesBean.getClienteID(),

									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROCLIENTECON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String aplicaSeguro = new String();

					aplicaSeguro=resultSet.getString("Estatus");
						return aplicaSeguro;
				}
			});
		estatusSeguro= matches.size() > 0 ? (String) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Estatus de Aplica Seguro Vida Ayuda", e);

		}
		return estatusSeguro;
	}

	public String consultaRecepcionChequeSBC(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String numeroChequeSBC = "0";
		try{
			String query = "call ABONOCHEQUESBCCON(?,?,?,?,?, ?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getNumeroCheque(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									ingresosOperacionesBean.getBancoEmisor(),
									ingresosOperacionesBean.getCuentaCargoAbono(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ABONOCHEQUESBCCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String numCheque = new String();

					numCheque=resultSet.getString("NumCheque");
						return numCheque;
				}
			});
		numeroChequeSBC= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Numero de Cheque SBC", e);

		}
		return numeroChequeSBC;
	}

	public String consultaAplicaChequeSBC(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String estatusAplicaCheqSBC = "";

		try{
			String query = "call ABONOCHEQUESBCCON(?,?,?,?,?, ?,  ?,?,?,?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getChequeSBCID(),
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call ABONOCHEQUESBCCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String estatuscheque = new String();

					estatuscheque=resultSet.getString("Estatus");
						return estatuscheque;
				}
			});
		estatusAplicaCheqSBC= matches.size() > 0 ? (String) matches.get(0) : "";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Estatus Aplica Cheque SBC", e);

		}
		return estatusAplicaCheqSBC;
	}

	public String consultaSaldoAportacionSoc(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String saldo = "0";
		try{
			String query = "call APORTACIONSOCIOCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getClienteID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call APORTACIONSOCIOCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String saldoAportacion = new String();

					saldoAportacion=resultSet.getString("Saldo") + "&" + resultSet.getString("MontoAportacion");
						return saldoAportacion;

				}
			});

		saldo= matches.size() > 0 ? (String) matches.get(0) : "0&0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Saldo de Aportacion social", e);

		}
		return saldo;
	}

	public String consultaMontoPendiCredito(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String montoPorDesembolsar = "";
		try{
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getReferenciaMov(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String montoxdesembolsar = new String();

					montoxdesembolsar=resultSet.getString("MontoPorDesemb");
						return montoxdesembolsar;
				}
			});
		montoPorDesembolsar= matches.size() > 0 ? (String) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta del Monto pendiente por desembolsar", e);

		}
		return montoPorDesembolsar;
	}

	public String consultaEstatusSeguroVida(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String estatusSeg = "0";
		try{
			String query = "call SEGUROVIDACON(?,?,?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									ingresosOperacionesBean.getReferenciaMov(),
									Constantes.ENTERO_CERO,

									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGUROVIDACON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String estatus = new String();

					estatus=resultSet.getString("Estatus");
						return estatus;
				}
			});
		estatusSeg= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Estatus Seguro de vida", e);

		}
		return estatusSeg;
	}

	public String consultaCoberturaRiesgo(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		String montoPendiente = "0";
		try{
			String query = "call CREDITOSCON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	ingresosOperacionesBean.getCreditoID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"IngresosOperacionesDAO.ConsultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CREDITOSCON(" + Arrays.toString(parametros) + ")");


		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					String montoPen = new String();

					montoPen=resultSet.getString("MontoPendiente");
						return montoPen;

				}
			});

		montoPendiente= matches.size() > 0 ? (String) matches.get(0) : "0";
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta del Monto pendiente de pago", e);

		}
		return montoPendiente;
	}
	/**
	 * Método que realiza el Proceso de Pago de Oportunidades de Ingreso de Operaciones
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean pagoOportunidadesPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PAGOPORTUNIDAESPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_Referencia", ingresosOperacionesBean.getReferenciaPago());
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setString("Par_NombreCompleto", ingresosOperacionesBean.getNombreCliente());
							sentenciaStore.setString("Par_Direccion", ingresosOperacionesBean.getDireccionCliente());
							sentenciaStore.setString("Par_NumTelefono", ingresosOperacionesBean.getTelefonoCliente());

							sentenciaStore.setInt("Par_TipoIdentiID", Utileria.convierteEntero(ingresosOperacionesBean.getTipoIdentifiCliente()));
							sentenciaStore.setString("Par_FolioIdentific", ingresosOperacionesBean.getFolioIdentifiCliente());
							sentenciaStore.setString("Par_FormaPago", ingresosOperacionesBean.getFormaPago());
							sentenciaStore.setLong("Par_NumeroCuenta", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));

							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));
							sentenciaStore.setLong("Par_NumeroMov", numeroTransaccion);
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para el proceso de Cobro de los Cheques SBC
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean recepcionChequeSBC(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String numeroChequeSBC = "";

		numeroChequeSBC = consultaRecepcionChequeSBC(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_ChequeSBC.recepcionCheque);
		if (!numeroChequeSBC.equals(IngresosOperacionesBean.enteroCero)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Cheque SBC ya se Encuentra Registrado en el Sistema");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			int validacion = 0;

			while (contador <= 3) {
				contador++;
				if (ingresosOperacionesBean.getTipoCuenta().equalsIgnoreCase("E") && !ingresosOperacionesBean.getAfectaContaSBC().equalsIgnoreCase("S")) {
					ingresosOperacionesBean.setPolizaID("0");
					validacion = 1;
					break;
				} else {
					polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

				}

				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					validacion = 1;
					break;
				}
			}

			if (validacion > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
						BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
						try {
							// ----- Se realiza el alta del Pago de la Remesa, se da de alta la poliza y detalle de la poliza contable
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							//Se verifica si la forma de pago fue interna en Efectivo para setear el nombre del Benenficiario
							if (ingresosOperacionesBean.getTipoCuenta().equalsIgnoreCase("I") && ingresosOperacionesBean.getFormaCobro().equalsIgnoreCase("E")) {
								ingresosOperacionesBean.setNombreCliente(ingresosOperacionesBean.getNombreBeneficiario());
							}

							mensajeBean = chequeSBCCobroPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Reimpresion ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntRecepChequeSBC);

							if (ingresosOperacionesBean.getTipoCuenta().equalsIgnoreCase("I")) { // CUENTA INTERNA
								//Movimiento de Entrada
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntChequeFirme);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								if (ingresosOperacionesBean.getFormaCobro().equalsIgnoreCase("E")) {//COBRO EN EFECTIVO
									// Movimiento de Salida
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalEfecCobroChequeFirme);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

									//Reimpresion ticket
									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
									ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
									// Movimiento de Entrada por Cambio
									if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {

										ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

										ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
										mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
									// se hacen los movimientos por denominacion
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
									ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
									IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
									if (billetesMonedas.size() > 0) {
										for (int i = 0; i < billetesMonedas.size(); i++) {
											ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
											mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
											if (mensajeBean.getNumero() != 0) {
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									} else {
										mensajeBean.setNumero(999);
										mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
										mensajeBean.setNombreControl("numeroTransaccion");
										mensajeBean.setConsecutivoString("0");
										CadenaLog = "";
										CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
										loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

										throw new Exception(mensajeBean.getDescripcion());

									}
								} else {// Deposito a cuenta
										// Movimiento de Salida
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalDepCtaChequeFirme);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

									//Reimpresion ticket
									ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
									ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_AbonoCuenta); //Reimpresion ticket

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

									//Consulta si Bloquea el Saldo, del monto Depositado, de manera Automatica de acuerdo al Tipo de Cuenta
									bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
									bloqueoSaldoBean.setTiposBloqID(BloqueoSaldoBean.TIPO_BLOQUEOAUTOMATICO);
									bloqueoSaldoBean.setNatMovimiento(BloqueoSaldoBean.NAT_BLOQUEO);
									bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getCantidadMov());
									bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
									bloqueoSaldoBean.setDescripcion(BloqueoSaldoBean.DESCRI_BLOQUEOAUTCHEQUE);
									bloqueoSaldoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

									bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVent);

									if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
										bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
										mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
									// Bloquear Saldo de la Cuenta
								}

							} else {// SBC
									//se ingresan los movimientos de caja, uno de entrada y otro de salida SBC
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntRecepChequeSBC);
								ingresosOperacionesBean.setMontoSBC(ingresosOperacionesBean.getCantidadMov());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalRecepChequeSBC);
								ingresosOperacionesBean.setMontoSBC(ingresosOperacionesBean.getCantidadMov());

								//Reimpresion ticket
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
								ingresosOperacionesBean.setFormaPagoCobro("E"); //forma de pago externa

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descCobroChequeCtaInt);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setCuentaIDDeposito(ingresosOperacionesBean.getCuentaAhoID());
							//Ticket recepcionChequeSBC
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en recepcion de Cheque SBC", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}

	public MensajeTransaccionBean chequeSBCCobroPro(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CHEQUESBCCOBROPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?, ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setString("Par_NombreReceptor", ingresosOperacionesBean.getNombreCliente());
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_BancoEmisor", Utileria.convierteEntero((ingresosOperacionesBean.getBancoEmisor())));

							sentenciaStore.setString("Par_CuentaEmisor", ingresosOperacionesBean.getCuentaCargoAbono());
							sentenciaStore.setLong("Par_NumCheque", Utileria.convierteLong(ingresosOperacionesBean.getNumeroCheque()));

							sentenciaStore.setString("Par_NombreEmisor", ingresosOperacionesBean.getNombreEmisor());
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));
							sentenciaStore.setString("Par_TipoCuentaCheque", ingresosOperacionesBean.getTipoCuenta());
							sentenciaStore.setString("Par_FormaCobro", ingresosOperacionesBean.getFormaCobro());
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_TipoChequera", ingresosOperacionesBean.getTipoChequeraRecep());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de cobro de Cheque SBC", e);
					} else {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de cobro de Cheque SBC", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para Aplicar los Cheques SBC
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean aplicaChequeSBC(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(origenVent);

		String estatusChequeSBC = "";

		estatusChequeSBC = consultaAplicaChequeSBC(ingresosOperacionesBean, IngresosOperacionesServicio.Enum_Con_ChequeSBC.aplicaCheque);

		if (estatusChequeSBC.equals(ingresosOperacionesBean.estatusAplicado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Cheque SBC ya fue Depositado en una Operacion");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (estatusChequeSBC.equals(ingresosOperacionesBean.estatusCancelado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Cheque SBC Esta Cancelado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {

			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						String bloquearSaldo = BloqueoSaldoBean.BLOQUEAR_NO;
						BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
						try {
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							mensajeBean = aplicaChequeEfectivoSBC(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							//Consulta si Bloquea el Saldo, del monto Depositado, de manera Automatica de acuerdo al Tipo de Cuenta
							bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
							bloqueoSaldoBean.setTiposBloqID(BloqueoSaldoBean.TIPO_BLOQUEOAUTOMATICO);
							bloqueoSaldoBean.setNatMovimiento(BloqueoSaldoBean.NAT_BLOQUEO);
							bloqueoSaldoBean.setMontoBloq(ingresosOperacionesBean.getCantidadMov());
							bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
							bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
							bloqueoSaldoBean.setDescripcion(BloqueoSaldoBean.DESCRI_BLOQUEOAUTAPLDOCSBC);
							bloqueoSaldoBean.setReferencia(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));

							bloquearSaldo = bloqueoSaldoDAO.consultaAplicaBloqueoAutomatico(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.consultaBloqueoAuto, origenVent);

							if (bloquearSaldo != null && bloquearSaldo.equalsIgnoreCase(BloqueoSaldoBean.BLOQUEAR_SI)) {
								bloqueoSaldoBean.setFechaMov(String.valueOf(parametrosSesionBean.getFechaSucursal()));
								mensajeBean = bloqueoSaldoDAO.bloqueosPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntAplicaChequeSBC);
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntAplicaChequeSBC); //Reimpresion ticket

							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalAplicaChequeSBC);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// movimiento de Salida por Cambio
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);/*GUARDABA NUM 60 */
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion  wwx
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());

							}

							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descAplicaChequeSBC);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());

							// Ticket aplicaChequeSBC
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Aplicacion del Cheque SBC", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}

	/**
	 * Método para realizar la aplicación de los Cheques SBC
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean aplicaChequeEfectivoSBC(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CHEQUESBCAPLICAPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?, ?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_ChequeSBCID", Utileria.convierteEntero(ingresosOperacionesBean.getChequeSBCID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));

							sentenciaStore.setInt("Par_NumCheque", Utileria.convierteEntero(ingresosOperacionesBean.getNumeroCheque()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de Cheque SBC", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de Cheque SBC", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método que realizar el Proceso de Prepago de Crédito en la Ventanilla
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @param TipoTransaccion
	 * @return
	 */
	public MensajeTransaccionBean prepagoCreditoEfectivo(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas, final int TipoTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		String totalCapVigente = "";
		AmortizacionCreditoBean amortizacionCreditoBean = new AmortizacionCreditoBean();
		amortizacionCreditoBean.setCreditoID(ingresosOperacionesBean.getReferenciaMov());

		totalCapVigente = amortizacionCreditoDAO.consultaCapVigente(amortizacionCreditoBean, AmortizacionCreditoServicio.Enum_Con_AmortizacionCredito.conCapVignente);
		double totalCapitalVig = Double.parseDouble(totalCapVigente);
		double montoPagar = Double.parseDouble(ingresosOperacionesBean.getCantidadMov());
		String TipPrepago = ingresosOperacionesBean.getTipoPrepago();

		if (montoPagar > totalCapitalVig && !TipPrepago.equals("P")) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("No Puede PrePagar el Total del Capital, Por Favor Seleccione la Opcion Finiquito");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {

				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						CreditosBean creditosBean = new CreditosBean();
						try {
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							//Seteamos las variables
							creditosBean.setCreditoID(ingresosOperacionesBean.getReferenciaMov());
							creditosBean.setCuentaID(ingresosOperacionesBean.getInstrumento());
							creditosBean.setMontoPagar(ingresosOperacionesBean.getCantidadMov());
							creditosBean.setMonedaID(ingresosOperacionesBean.getMonedaID());
							creditosBean.setCicloGrupo(ingresosOperacionesBean.getCicloGrupo());
							creditosBean.setGrupoID(ingresosOperacionesBean.getGrupoID());

							if (TipoTransaccion == Enum_Tra_Ventanilla.prepagoCredito) { // Prepago Individual
								ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
								mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean = creditosDAO.prepagoCredito(creditosBean, parametrosAuditoriaBean.getNumeroTransaccion(), Integer.parseInt(numeroPoliza), origenVent, Constantes.ORIGEN_PAGO_VENTANILLA);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else if (TipoTransaccion == Enum_Tra_Ventanilla.prepagoCreditoGrupal) { // Prepago de Credito Grupal
								creditosBean.setFormaPago("E");
								creditosBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
								creditosBean.setOrigenPago(Constantes.ORIGEN_PAGO_VENTANILLA);
								mensajeBean = creditosDAO.prepagoCreditoGrupal(creditosBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

							}

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntCajaPrepagoCred);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

							//Reimpresion ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntCajaPrepagoCred);

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalCajaPrepagoCred);
							ingresosOperacionesBean.setMontoEnFirme(creditosBean.getMontoPagar());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida());//Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());

							}
							//validamos que la operacion de la Caja

							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Reimpresion ticket
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPrepagoCredito);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setCreditoID(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setReferenciaTicket(String.valueOf(TipoTransaccion));
							//prepagoCreditoEfectivo
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, creditosBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de credito en efectivo", e);

						}
						return mensajeBean;
					}
				});
				if (mensaje.getNumero() != 0) {
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	//PAGO DE SERVICIOS
	public MensajeTransaccionBean pagoServicios(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(origenVent);
		int contador = 0;
		while (contador <= 3) {
			contador++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "";
					try {
						// Movimientos Operativos y Contables
						numeroPoliza = ingresosOperacionesBean.getPolizaID();
						ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
						ingresosOperacionesBean.setPolizaID(numeroPoliza);
						mensajeBean = pagoServicios(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						// Operacion de Entrada en Caja
						ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getReferenciaPago());
						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntCajaPagoServicio);
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

						//Reimpresion ticket
						ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntCajaPagoServicio);
						ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						// Operacion de Salida en Caja
						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalCajaPagoServicio);
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalPagar());
						ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getTotalPagar()); //Reimpresion ticket

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}
						// Operacion de Salida por Cambio(Si lo Hay)
						if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

							ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion ticket
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
						// se hacen los movimientos por denominacion
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
						ingresosOperacionesBean.setPolizaID(numeroPoliza);
						IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
						if (billetesMonedas.size() > 0) {
							for (int i = 0; i < billetesMonedas.size(); i++) {
								ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString("0");
							CadenaLog = "";
							CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

							throw new Exception(mensajeBean.getDescripcion());

						}
						//validamos que la operacion de la Caja

						mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//Se hace la insercion a la tabla de reimpresion de tickets
						ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagServ);
						ingresosOperacionesBean.setIVATicket(ingresosOperacionesBean.getiVAComision());
						ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaPago()); //Reimpresion ticket
						ingresosOperacionesBean.setReferenciaPago(Constantes.STRING_VACIO);
						//Reimpresion ticket
						ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
						//Ticket pagoServicios
						mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de Servicios", e);

					}
					return mensajeBean;
				}
			});
			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);
			}

		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}
	/**
	 * Método para realizar el proceso de Pago de Servicios
	 * @param ingresosOperacionesBean
	 * @param numeroTransaccion
	 * @return
	 */
	public MensajeTransaccionBean pagoServicios(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					final String origenPago = "V"; // Origen del pago en ventanilla
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CONTAPAGOSERVPRO(" + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?,?,?,?,?," + "?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_CatalogoServID", Utileria.convierteEntero(ingresosOperacionesBean.getCatalogoServID()));
							sentenciaStore.setInt("Par_PagoServicioID", Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursal()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setString("Par_Fecha", Utileria.convierteFecha(ingresosOperacionesBean.getFecha()));

							sentenciaStore.setString("Par_Referencia", ingresosOperacionesBean.getReferenciaPago());
							sentenciaStore.setString("Par_SegundaRefe", ingresosOperacionesBean.getReferenciaMov());
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setDouble("Par_MontoServicio", Utileria.convierteDoble(ingresosOperacionesBean.getMonto()));
							sentenciaStore.setDouble("Par_IvaServicio", Utileria.convierteDoble(ingresosOperacionesBean.getIVAMonto()));

							sentenciaStore.setDouble("Par_Comision", Utileria.convierteDoble(ingresosOperacionesBean.getComision()));
							sentenciaStore.setDouble("Par_IVAComision", Utileria.convierteDoble(ingresosOperacionesBean.getiVAComision()));
							sentenciaStore.setDouble("Par_Total", Utileria.convierteDoble(ingresosOperacionesBean.getTotalPagar()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(ingresosOperacionesBean.getProspectoID()));

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setString("Par_OrigenPago", origenPago);

							sentenciaStore.setString("Par_AltaPagoServ", Constantes.salidaSI);
							sentenciaStore.setString("Par_AltaEncPol", ingresosOperacionesBean.getAltaEnPoliza());
							sentenciaStore.setString("Par_AltaDetPol", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setString("Par_NatDetPol", IngresosOperacionesBean.naturalezaAbono);

							sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());

							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	//////////////////////////////////////INICIO WEB SERVICES PAGO DE SERVICIO /////////////////////////////////////////
	public MensajeTransaccionBean pagoServiciosWS(final IngresosOperacionesBean ingresosOperacionesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call PAGOSERVICIOWSPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?,  ?,?,?,?,?,  ?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_CatalogoServID", Utileria.convierteEntero(ingresosOperacionesBean.getCatalogoServID()));
								sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
								sentenciaStore.setString("Par_Referencia",ingresosOperacionesBean.getReferenciaPago());
								sentenciaStore.setString("Par_SegundaRefe",ingresosOperacionesBean.getReferenciaMov());
								sentenciaStore.setDouble("Par_MontoServicio", Utileria.convierteDoble(ingresosOperacionesBean.getMonto()));
								sentenciaStore.setDouble("Par_IvaServicio", Utileria.convierteDoble(ingresosOperacionesBean.getIVAMonto()));
								sentenciaStore.setDouble("Par_Comision", Utileria.convierteDoble(ingresosOperacionesBean.getComision()));
								sentenciaStore.setDouble("Par_IVAComision", Utileria.convierteDoble(ingresosOperacionesBean.getiVAComision()));
								sentenciaStore.setDouble("Par_Total", Utileria.convierteDoble(ingresosOperacionesBean.getTotalPagar()));
								sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));

								sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));

								sentenciaStore.setString("Par_Salida", Constantes.salidaNO);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
								sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();
										resultadosStore.next();

									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
									mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero()==0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en pago de Servicios WS", e);

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	////////////////////////////////////FIN WEB SERVICES PAGO DE SERVICIO /////////////////////////////////////////
	/**
	 * Recuperacion de cartera castigada
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean recuperaCarteraCastigada(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String montoRecuperar = "";
		CastigosCarteraBean castigosCarteraBean = new CastigosCarteraBean();
		castigosCarteraBean.setCreditoID(ingresosOperacionesBean.getCreditoID());

		montoRecuperar = castigosCarteraDAO.consultaMontoRecuperar(castigosCarteraBean, CastigosCarteraServicio.Enum_ConCastigosCartera.consultaPrincipal);

		double montoRecu = Double.parseDouble(montoRecuperar);// lo que resta por recuperar bd
		double parTotalRecuperar = Double.parseDouble(ingresosOperacionesBean.getTotalPagar());
		if (parTotalRecuperar > montoRecu) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto del Deposito Excede el Total del Monto por Recuperar");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {

			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// Movimientos Operativos y Contables
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							mensajeBean = recuperacionCarteraVencida(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Operacion de Entrada en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntradaCarteraVen);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntradaCarteraVen);
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Operacion de Salida en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalidaCarteraVen);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalPagar());
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());

							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getTotalPagar()); //Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Operacion de Salida por Cambio(Si lo Hay)
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());

							}
							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descRecCarteraCast);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							//Tikcet recuperaCarteraCastigada
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Recuperacion de CArtera Vencida", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * Método para realizar el proceso de recuperacion de Cartera Castigada
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean recuperacionCarteraVencida(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CRECASTIGOSRECPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getMonto()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_DescripcionMov", ingresosOperacionesBean.getDescripcionMov());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());

							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para el Proceso de Pago de Servicios Funerarios
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean pagoSERVIFUN(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String estatusSolServifun = "";
		ServiFunFoliosBean servifunFoliosBean = new ServiFunFoliosBean();
		servifunFoliosBean.setServiFunFolioID(ingresosOperacionesBean.getServiFunFolioID());
		estatusSolServifun = serviFunFoliosDAO.consultaEstatusServifun(servifunFoliosBean, ServiFunFoliosServicio.Enum_Con_serviFunFolios.principal);
		if (estatusSolServifun.equals(ingresosOperacionesBean.estatusPagado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Folio ya fue Pagado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (estatusSolServifun.equals(ingresosOperacionesBean.estatusCapturado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Folio no esta Autorizado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {

			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// ----- Se da de alta la poliza y detalle de la poliza contable
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							mensajeBean = serviFunEntregadoDAO.pagoSERVIFUNPro(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida

							//Movimiento de Entrada
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntradaPagoServifun);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntradaPagoServifun);
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Movimiento de Salida: Efectivo o Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequePagoServifun);

								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque); //Reimpresion ticket
							} else {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalidaPagoServifun);

								//Reimpresion ticket
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							}

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// movimiento de Salida por Cambio
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada());//Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);

							// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoSERVIFUN);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							// Ticket pagoSERVIFUN
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en pago SERVIFUN IngresosOperacionesDAO", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	//Apoyo Escolar
	public MensajeTransaccionBean pagoApoyoEscolar(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		ApoyoEscolarSolBean apoyoEscolarSolBean = new ApoyoEscolarSolBean();
		apoyoEscolarSolBean.setApoyoEscSolID(ingresosOperacionesBean.getApoyoEscSolID());

		String estatusSoli = "";
		estatusSoli = apoyoEscolarSolDAO.consultaEstatusSoliApoyoEsc(apoyoEscolarSolBean, ApoyoEscolarSolServicio.Enum_Con_ApoyoEscolarSol.estatusReg);
		if (!estatusSoli.equals(ingresosOperacionesBean.estatusAutorizado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Solicitud de Apoyo Escolar no Esta Autorizada");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {
							// ----- Se da de alta la poliza y detalle de la poliza contable
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							mensajeBean = apoyoEscolarSolDAO.pagoApoyoEscolar(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Se hace el alta de los dos movimientos de caja

							//Movimiento de Entrada
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntradaPagoApoyoEsc);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntradaPagoApoyoEsc);
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Movimiento de Salida: Efectivo o Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequePagoApoyoEscolar);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);
							} else {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalidaPagoApoyoEsc);

								//Reimpresion ticket
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());
							}

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// movimiento de Salida por Cambio
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);

							// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descApoyoEscolar);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							// Ticket pagoApoyoEscolar
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en proceso de Pago de Apoyo Escolar", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	//XX.XX Ajustes Sobrantes
	public MensajeTransaccionBean ajusteSobrantePro(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(ingresosOperacionesBean.getUsuarioAut());
		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);
		String passEnvio = SeguridadRecursosServicio.encriptaPass(ingresosOperacionesBean.getUsuarioAut(), ingresosOperacionesBean.getContraseniaAut()); // manda de pantalla
		if (!contrasenia.equals(passEnvio)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (ingresosOperacionesBean.getUsuarioAut().equals(usuarioLog)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}

		else {

			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try {

							// ----- Se da de alta la poliza y detalle de la poliza contable
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							mensajeBean = paramFaltaSobraDAO.ajusteSobrante(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntAjusteSobrante);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntAjusteSobrante);
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalAjusteSobrante);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// movimiento de Salida por Cambio
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());
							}
							// validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descAjusteSobrante);
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							//Ticket ajusteSobrantePro
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Ajuste por Sobrante", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	// Ajuste Faltante
	public MensajeTransaccionBean ajusteFaltantePro(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(ingresosOperacionesBean.getUsuarioAut());
		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);
		String passEnvio = SeguridadRecursosServicio.encriptaPass(ingresosOperacionesBean.getUsuarioAut(), ingresosOperacionesBean.getContraseniaAut()); // envia de pantalla
		if (!contrasenia.equals(passEnvio)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (ingresosOperacionesBean.getUsuarioAut().equals(usuarioLog)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {

			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";

						try {
							// ----- Se da de alta la poliza y detalle de la poliza contable
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							mensajeBean = paramFaltaSobraDAO.ajusteFaltante(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hace el alta de los dos movimientos de caja,uno de entrada y otro de salida
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntAjusteFaltante);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

							//Reimpresion ticket
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntAjusteFaltante);
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalAjusteFaltante);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// movimiento de Salida por Cambio
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							for (int i = 0; i < billetesMonedas.size(); i++) {
								ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descAjusteFaltante);
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							//Ticket ajusteFaltantePro
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Ajuste por Sobrante", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * El Cajero Recibe el Pago de la Anualidad de la Tarjeta de Debito
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean cobroAnualTarjeta(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		TarjetaDebitoBean tarjetaDebitoBean = new TarjetaDebitoBean();
		tarjetaDebitoBean.setTarjetaDebID(ingresosOperacionesBean.getTarjetaDebID());
		tarjetaDebitoBean.setCuentaAhoID(ingresosOperacionesBean.getNumCuentaTar());
		tarjetaDebitoBean = tarjetaDebitoDAO.consultaPagoAnual(TarjetaDebitoServicio.Enum_Con_tarjetaDebito.consultaCobroAnualTarDeb, tarjetaDebitoBean);
		// formato que esperamos recibir
		String formatofecha = "yyyy-MM-dd";
		SimpleDateFormat formatter = new SimpleDateFormat(formatofecha);

		try {
			// damos formato Date a los String con SimpleDateFormat pattern
			String proximoPago = tarjetaDebitoBean.getFechaProximoPag();
			String fechaActual = ingresosOperacionesBean.getFechSistema();

			Date fechaProximoPago = formatter.parse(proximoPago);
			Date fechaSistema = formatter.parse(fechaActual);

			// comparamos las fechas
			if (fechaProximoPago.compareTo(fechaSistema) > 0) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("La Fecha de Pago de Comision Anual es: " + tarjetaDebitoBean.getFechaProximoPag());
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			} else {
				transaccionDAO.generaNumeroTransaccion(origenVent);
				int contador = 0;
				while (contador <= 3) {
					contador++;
					polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
						break;
					}
				}
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					mensaje = (MensajeTransaccionBean) transactionTemplate.execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = "";

							try {
								// ----- Se Realiza la Operacion, se da de alta la poliza y detalle de la poliza contable
								numeroPoliza = ingresosOperacionesBean.getPolizaID();
								mensajeBean = tarjetaDebitoDAO.pagoAnuliadadTarjeta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								//
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								// se hace el alta de los dos movimientos de caja,uno de entrada y otro de salida
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntCobroAnualTarj);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								//Reimpresion ticket
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntCobroAnualTarj);
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
								ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getTarjetaDebID());
								ingresosOperacionesBean.setCuentaIDDeposito(ingresosOperacionesBean.getNumCuentaTar());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalCobroAnualTarj);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());

								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov()); //Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								// movimiento de Salida por Cambio
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); //Reimpresion ticket

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								// se hacen los movimientos por denominacion
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								// validamos que la operacion de la Caja
								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								//Se hace la insercion a la tabla de reimpresion de tickets
								ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagoTarDebAnual);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
								ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());

								//Ticket cobroAnualTarjeta
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Corbo anualidad Tarjeta de Debito", e);

							}
							return mensajeBean;
						}
					});
					if(mensaje.getNumero() != 0){
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
						polizaDAO.bajaPoliza(bajaPolizaBean);
					}

				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}

			}
		} catch (ParseException e) {
			// execution will come here if the String that is given
			// does not match the expected format.
			e.printStackTrace();
		}
		return mensaje;
	}

	public MensajeTransaccionBean pagoServiciosLinea(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		final int cancelacionCobroSL = 1;
		final int confirmacionCobroSL = 2;
		final String codigoExitoBroker = "000000";
		final String formaPagoEfectivo = "E";

		//Errores genericos del Proveedor de Servicios.
		final String[] STR_ERROR = {"010000","Error"};
		final String[] STR_ERROR_VALIDACIONES = {"020000","ERROR AL REALIZAR LAS VALIDACIONES"};
		final String[] STR_ERROR_DAO = {"030000","ERROR EN CAPA DAO"};
		final String[] STR_ERROR_SERVICIO = {"040000","ERROR EN CAPA SERVICIO"};
		final String[] STR_ERROR_CONTROLADOR = {"050000","ERROR EN CAPA CONTROLADOR"};

		//Genero el numero de Transaccion
		transaccionDAO.generaNumeroTransaccion(origenVent);
		final long numeroTransaccion = parametrosAuditoriaBean.getNumeroTransaccion();
		int contador = 0;
		while (contador <= 3) {
			contador++;
			//Genera la PolizaID y la asigna al bean de IngresoOperaciones
			polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				break;
			}
		}
		loggerVent.info("polizaID:" + ingresosOperacionesBean.getPolizaID() + " numeroTransaccion:" + numeroTransaccion);

		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
			//Realizamos el alta del Cobro
			mensaje = pslCobroSLDAO.altaCobroServicioEnLinea(ingresosOperacionesBean, numeroTransaccion);
			if (mensaje.getNumero() != 0) {
				loggerVent.error(mensaje.getNumero() + " - " + mensaje.getDescripcion());
				return mensaje;
			}

			ingresosOperacionesBean.setCobroID(mensaje.getConsecutivoInt());
			final BaseBeanResponse wsBeanResponse = new BaseBeanResponse();
			wsBeanResponse.setCodigoRespuesta(codigoExitoBroker);
			wsBeanResponse.setMensajeRespuesta(Constantes.STRING_VACIO);

			//Realizamos los movimientos de Caja, Movimientos contables y Pago de Servicios con el Proveedor
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					String numeroPoliza = "";
					try {
						/************************************************************/
						// Movimientos Operativos y Contables
						mensajeBean = pagoServiciosLinea(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion());
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						/************************************************************/
						// Operacion de Entrada en Caja
						if(formaPagoEfectivo.equals(ingresosOperacionesBean.getFormaPagoPSL())) {
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo); //Reimpresion ticket
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntPagServLinea);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada()); // Total en Efectivo
						}
						else {
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_AbonoCuenta); //Reimpresion ticket
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.cargoCtaPagServLinea);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalPagarPSL()); // Total del producto
						}

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						/************************************************************/
						// Operacion de Salida en Caja
						if(formaPagoEfectivo.equals(ingresosOperacionesBean.getFormaPagoPSL())) {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalPagServLineaEfe);
						}
						else {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalPagServLineaCCH);
						}
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalPagarPSL());
						ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getTotalPagarPSL()); //Reimpresion ticket

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						/************************************************************/
						// Operacion de Salida por Cambio(Si lo Hay)
						if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida()); //Monto cambio recibido por el usuario

							ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion ticket
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}

						/************************************************************/
						// se hacen los movimientos por denominacion
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
						IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
						if (billetesMonedas.size() > 0) {
							for (int i = 0; i < billetesMonedas.size(); i++) {
								ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

						/************************************************************/
						//validamos que la operacion de la Caja
						loggerVent.info("validaOperacionCaja");
						mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							loggerVent.error(mensajeBean.getNumero() + " - " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}

						/************************************************************/
						//Realizamos el Pago del Servicio con el Proveedor de Servicios en Linea (Broker).
						BaseBeanResponse baseBeanResponse = pslCobroSLDAO.pagoServicioEnLinea(ingresosOperacionesBean, numeroTransaccion);
						if (!codigoExitoBroker.equals(baseBeanResponse.getCodigoRespuesta())) {
							wsBeanResponse.setCodigoRespuesta(baseBeanResponse.getCodigoRespuesta());
							wsBeanResponse.setMensajeRespuesta(baseBeanResponse.getMensajeRespuesta());
							wsBeanResponse.setTransaccion(baseBeanResponse.getTransaccion());

							String mensajeError = baseBeanResponse.getMensajeRespuesta();
							//En caso de un codigo de error generico por el proveedor mostramos un mensaje por defecto
							if(baseBeanResponse.getCodigoRespuesta().equals(STR_ERROR[0]) ||
									baseBeanResponse.getCodigoRespuesta().equals(STR_ERROR_VALIDACIONES[0]) ||
									baseBeanResponse.getCodigoRespuesta().equals(STR_ERROR_DAO[0]) ||
									baseBeanResponse.getCodigoRespuesta().equals(STR_ERROR_SERVICIO[0]) ||
									baseBeanResponse.getCodigoRespuesta().equals(STR_ERROR_CONTROLADOR[0])) {
								mensajeError = "Error al realizar el pago de Servicio con el Proveedor.";
							}

							loggerVent.error("Error al realizar el pago de Servicio con el Proveedor:" + baseBeanResponse.getCodigoRespuesta() + " - " + baseBeanResponse.getMensajeRespuesta());
							throw new Exception(mensajeError);
						}

						//Registramos la respuesta del Proveedor de Servicios en Linea (Broker).
						pslCobroSLDAO.altaRespuestaWSBrokerServicios(ingresosOperacionesBean, baseBeanResponse, numeroTransaccion);


						/************************************************************/
						//Reimpresion ticket
						ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntPagServLinea);
						ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); //Monto pagado por el usuario
						//Se hace la insercion a la tabla de reimpresion de tickets
						ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagoServicioLinea);
						ingresosOperacionesBean.setIVATicket(ingresosOperacionesBean.getIvaComisiInstitucion());
						ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaPago()); //Reimpresion ticket
						ingresosOperacionesBean.setReferenciaPago(Constantes.STRING_VACIO);
						//Ticket pagoServicios
						mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							loggerVent.error(mensajeBean.getNumero() + " - " + mensajeBean.getDescripcion());
							throw new Exception(mensajeBean.getDescripcion());
						}



						/************************************************************/
						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de Servicios", e);

					}
					return mensajeBean;
				}
			});


			//Ocurrio un error.
			if(mensaje.getNumero() != 0) {
				//Marcamos la poliza como Baja
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
				MensajeTransaccionBean respuestaBajaPoliza = polizaDAO.bajaPoliza(bajaPolizaBean);
				if(respuestaBajaPoliza.getNumero() == 0) {
					ingresosOperacionesBean.setPolizaID(Constantes.STRING_CERO);
				}

				//Marcamos el Cobro como cancelado
				pslCobroSLDAO.bajaCobroServicioEnLinea(ingresosOperacionesBean, numeroTransaccion);

				//Solo en caso de error registramos la respuesta del Proveedor de Servicios en Linea (Broker).
				if(!codigoExitoBroker.equals(wsBeanResponse.getCodigoRespuesta())) {
					pslCobroSLDAO.altaRespuestaWSBrokerServicios(ingresosOperacionesBean, wsBeanResponse, numeroTransaccion);
				}
			}
			//Proceso exitoso.
			else {
				//Confirmamos el Cobro como exitoso.
				pslCobroSLDAO.confirmacionCobroServicioEnLinea(ingresosOperacionesBean, numeroTransaccion);
			}

		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}

	public MensajeTransaccionBean pagoServiciosLinea(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					final String origenPago = "V"; // Origen del pago en ventanilla
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call PSLCONTACOBROSLPRO(?,?,   ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,   ?,?,?,?,   ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_PolizaID",Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setInt("Par_MonedaID",Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setInt("Par_ProductoID",Utileria.convierteEntero(ingresosOperacionesBean.getProductoID()));
							sentenciaStore.setInt("Par_ServicioID",Utileria.convierteEntero(ingresosOperacionesBean.getServicioIDPSL()));
							sentenciaStore.setString("Par_ClasificacionServ", ingresosOperacionesBean.getClasificacionServPSL());
							sentenciaStore.setString("Par_TipoUsuario", ingresosOperacionesBean.getTipoUsuario());
							sentenciaStore.setString("Par_NumeroTarjeta", ingresosOperacionesBean.getNumeroTarjetaPSL());
							sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(ingresosOperacionesBean.getClienteIDPSL()));
							sentenciaStore.setDouble("Par_CuentaAhoID",Utileria.convierteDoble(ingresosOperacionesBean.getCuentaAhorroPSL()));
							sentenciaStore.setString("Par_Producto", ingresosOperacionesBean.getNombreProductoPSL());
							sentenciaStore.setString("Par_FormaPago", ingresosOperacionesBean.getFormaPagoPSL());
							sentenciaStore.setDouble("Par_Precio",Utileria.convierteDoble(ingresosOperacionesBean.getPrecio()));
							sentenciaStore.setString("Par_Telefono", ingresosOperacionesBean.getTelefonoPSL());
							sentenciaStore.setString("Par_Referencia", ingresosOperacionesBean.getReferenciaPSL());
							sentenciaStore.setDouble("Par_ComisiProveedor",Utileria.convierteDoble(ingresosOperacionesBean.getComisiProveedor()));
							sentenciaStore.setDouble("Par_ComisiInstitucion",Utileria.convierteDoble(ingresosOperacionesBean.getComisiInstitucion()));
							sentenciaStore.setDouble("Par_IVAComision",Utileria.convierteDoble(ingresosOperacionesBean.getIvaComisiInstitucion()));
							sentenciaStore.setDouble("Par_TotalComisiones",Utileria.convierteDoble(ingresosOperacionesBean.getTotalComisiones()));
							sentenciaStore.setDouble("Par_TotalPagar",Utileria.convierteDoble(ingresosOperacionesBean.getTotalPagarPSL()));
							sentenciaStore.setString("Par_FechaHora", ingresosOperacionesBean.getFechaHoraPSL());
							sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID",Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_CajeroID",parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setString("Par_Canal",ingresosOperacionesBean.getCanalPSL());


							//Parametros de salida
							sentenciaStore.setInt("Par_NumPro", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setDescripcion(Utileria.generaLocale(resultadosStore.getString("ErrMen"), parametrosSesionBean.getNomCortoInstitucion()));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en alta de Pago de remesas", e);

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	// metodo para ejecutar una salida de Efectivo o cheque segun Haberes del socio.
	public MensajeTransaccionBean haberesExMenor(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String estatus = "";
		ClienteExMenorBean clienteExMenorBean = new ClienteExMenorBean();
		clienteExMenorBean.setClienteID(ingresosOperacionesBean.getClienteID());
		estatus = clienteExMenorDAO.consultaEstatusHaberesMenor(clienteExMenorBean, ClienteExMenorServicio.Enum_Con_ExMenor.principal);

		if (estatus.equals(ingresosOperacionesBean.estatusRetirado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto ya Fue Retirado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						ClienteExMenorBean clienteExMenor = new ClienteExMenorBean();

						String numeroPoliza = "";
						try {
							//Se hace el Cargo a la Cuenta Concentradora
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							clienteExMenor.setCajaID(ingresosOperacionesBean.getCajaID());
							clienteExMenor.setSucursalID(ingresosOperacionesBean.getSucursalID());
							clienteExMenor.setClienteID(ingresosOperacionesBean.getClienteID());
							clienteExMenor.setFechaRetiro(ingresosOperacionesBean.getFecha());
							clienteExMenor.setTipoOperacion(ingresosOperacionesBean.getTipoOperacion());
							clienteExMenor.setTipoIdentidad(ingresosOperacionesBean.getTipoIdentifiCliente());
							clienteExMenor.setFolioIdentificacion(ingresosOperacionesBean.getFolioIdentifiCliente());
							clienteExMenor.setSaldoAhorro(ingresosOperacionesBean.getMonto());
							clienteExMenor.setPolizaID(numeroPoliza);
							clienteExMenor.setConceptoCon(ingresosOperacionesBean.getConceptoCon());
							clienteExMenor.setDescripcion(ingresosOperacionesBean.getDescripcionMov());

							mensajeBean = clienteExMenorDAO.retiroHaberesExMenor(clienteExMenor, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
							//Movimiento de Entrada

							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getClienteID());
							ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getMonto());

							//Reimpresion ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getMonto());
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntHaberesExMenor);

							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntHaberesExMenor);
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Movimiento de Salida: Efectivo o Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCheqExMenor);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);
							} else {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalHaberesExMenor);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//********* se dan de alta movimientos de entrada de efectivo por cambio si los hubieran, siempre y cuando NO sea un Cheque la Salida
							if (!ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								if (Double.parseDouble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
									//Movimiento de Entrada de Efectivo por Cambio
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}

							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getInstrumento());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setCantidadMov(ingresosOperacionesBean.getMonto());
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							// Validamos la transacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.descPagoHaberesMenor);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							//Ticket haberesExMenor
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error Reclamo de Haberes del ExMenor", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	//	::::::::::::::::::::::::::::::::::::::REVERSAS::::::::::::::::::::::::::::::::::::::...
	// Lista las operaciones realizadas en caja
	public List listaCajasMovs(int tipoLista,IngresosOperacionesBean ingresosOperacionesBean) {
		List listaCajasMovs = null;

		try{
			String query = "call CAJASMOVSLIS(?,?,?,?,?, ?,?,?,?,?,   ?,?);";
			Object[] parametros = {
									ingresosOperacionesBean.getSucursal(),
									ingresosOperacionesBean.getCajaID(),
									ingresosOperacionesBean.getFecha(),
									ingresosOperacionesBean.getTipoOperacion(),
									//IngresosOperacionesBean.opeCajaEntCobroseguroVida,

									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCajasMovs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASMOVSLIS(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					IngresosOperacionesBean ingresosOperaciones = new IngresosOperacionesBean();
					ingresosOperaciones.setNumeroMov(resultSet.getString("Transaccion"));
					ingresosOperaciones.setMontoEnFirme(resultSet.getString("MontoEnFirme"));
					ingresosOperaciones.setReferenciaMov(resultSet.getString("Instrumento"));
					ingresosOperaciones.setNombreCliente(resultSet.getString("Cliente"));

					return ingresosOperaciones;
				}

			});

			listaCajasMovs = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Movimientos de Cajas", e);


		}
		return listaCajasMovs;
	}

	// consulta los movimientos realializados en caja
	public IngresosOperacionesBean consultaTransaccionCajaMovs(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		IngresosOperacionesBean consultaBean = null;

		try{
			String query = "call CAJASMOVSCON(?,?,?,?,?, ?,?,?,?,?,   ?,?,?,?, ?);";
			Object[] parametros = { ingresosOperacionesBean.getNumeroMov(),
									ingresosOperacionesBean.getSucursal(),
									ingresosOperacionesBean.getCajaID(),
									ingresosOperacionesBean.getFecha(),
									ingresosOperacionesBean.getTipoOperacion(),
									Constantes.ENTERO_CERO,
									Constantes.STRING_VACIO,
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaTransaccionCajaMovs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASMOVSCON(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					IngresosOperacionesBean ingresosOperaciones = new IngresosOperacionesBean();
					ingresosOperaciones.setNumeroMov(resultSet.getString("Transaccion"));
					ingresosOperaciones.setReferenciaMov(resultSet.getString("Referencia"));
					ingresosOperaciones.setInstrumento(resultSet.getString("Instrumento"));
					ingresosOperaciones.setMontoEnFirme(resultSet.getString("MontoEnFirme"));
					ingresosOperaciones.setCajaID(resultSet.getString("CajaID"));
					ingresosOperaciones.setEsEfectivo(resultSet.getString("Var_esEfectivo"));

					return ingresosOperaciones;
				}
			});
			consultaBean= matches.size() > 0 ? (IngresosOperacionesBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Movimiento de Cajas", e);

		}
		return consultaBean;
	}

	public IngresosOperacionesBean consultaGarantiaAdicional(IngresosOperacionesBean ingresosOperacionesBean, int tipoConsulta) {
		IngresosOperacionesBean consultaBean = null;

		try{
			String query = "call CAJASMOVSCON(?,?,?,?,?, ?,?,?,?,?,   ?,?,?, ?, ?);";
			Object[] parametros = { ingresosOperacionesBean.getNumeroMov(),
									ingresosOperacionesBean.getSucursal(),
									ingresosOperacionesBean.getCajaID(),
									ingresosOperacionesBean.getFecha(),
									ingresosOperacionesBean.getTipoOperacion(),
									ingresosOperacionesBean.getInstrumento(),
									ingresosOperacionesBean.getReferenciaMov(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"consultaTransaccionCajaMovs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CAJASMOVSCON(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					IngresosOperacionesBean ingresosOperaciones = new IngresosOperacionesBean();
					ingresosOperaciones.setNumeroMov(resultSet.getString("Transaccion"));
					ingresosOperaciones.setReferenciaMov(resultSet.getString("Referencia"));
					ingresosOperaciones.setInstrumento(resultSet.getString("Instrumento"));
					ingresosOperaciones.setMontoEnFirme(resultSet.getString("MontoEnFirme"));
					return ingresosOperaciones;
				}
			});
			consultaBean= matches.size() > 0 ? (IngresosOperacionesBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Consulta de Movimiento de Cajas", e);

		}
		return consultaBean;
	}
	//--------------------------REVERSAS DE OPERACIONES-----------------------------------
	/**
	 * Método para realizar la Operacion de Reversa de Cargo a Cuenta
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la Informacion para realizar la operacion de Reversa
	 * @param reversasOperBean : Bean ReversasOperBean con la Información para realizar la Operacion de Reversa
	 * @param billetesMonedas : Lista de Denominaciones
	 * @return
	 */
	public MensajeTransaccionBean reversaCargoACuenta(final IngresosOperacionesBean ingresosOperacionesBean, final ReversasOperBean reversasOperBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = null;
		try {
			long numeroTransaccion = 0;
			mensaje = new MensajeTransaccionBean();
			String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
			String contrasenia = "";
			UsuarioBean usuarioBean = new UsuarioBean();
			usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());

			contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);

			String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()); // manda de pantalla

			if (!contrasenia.equals(passEnvio)) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}

			if (reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			} else {
				transaccionDAO.generaNumeroTransaccion(origenVent);

				int contador = 0;
				while (contador <= 3) {
					contador++;
					polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
						break;
					}
				}
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = "";
							try {

								ingresosOperacionesBean.setAltaEnPoliza(ingresosOperacionesBean.altaEnPolizaNo);
								/*damos de alta la reversa en la tabla de REVERSASOPER*/
								reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
								reversasOperBean.setEfectivo(ingresosOperacionesBean.getTotalEntrada());
								reversasOperBean.setCambio((Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) - Utileria.convierteDoble(reversasOperBean.getMonto()) + ""));

								mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								numeroPoliza = ingresosOperacionesBean.getPolizaID();
								/*Operacion de Entrada en Caja*/
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCargoCtaReversa);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								/*Operacion de Salida en Caja*/
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCargoCtaReversa);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								/*Operacion de Salida por Cambio(Si lo Hay)*/
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								/*se hacen los movimientos por denominacion*/
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());
								}
								/*validamos que la operacion de la Caja*/
								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Reversa Realizada Exitosamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de Cargo a Cuenta", e);
							}
							return mensajeBean;
						}
					});
					if (mensaje.getNumero() != 0) {
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
						polizaDAO.bajaPoliza(bajaPolizaBean);
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar Reversa Cargo a Cuenta.", ex);
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar Reversa Cargo a Cuenta.");
			}
		}
		return mensaje;
	}
	/**
	 * Método para realizar la Operación de Reversa de Abono a la Cuenta
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la Información de la Operación
	 * @param reversasOperBean : Bean con la Informacion de la Operación
	 * @param billetesMonedas : Lista de Denominaciones
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean reversaaltaAbonoACuenta(final IngresosOperacionesBean ingresosOperacionesBean, final ReversasOperBean reversasOperBean, final List billetesMonedas) {

		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());

		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);

		String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()); // manda de pantalla

		if (!contrasenia.equals(passEnvio)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}

		else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = ingresosOperacionesBean.getPolizaID();
						ingresosOperacionesBean.setAltaEnPoliza(ingresosOperacionesBean.altaEnPolizaNo);
						BloqueoSaldoBean bloqueoSaldoBean = new BloqueoSaldoBean();
						BloqueoSaldoBean bloqueoSaldoConsulta = new BloqueoSaldoBean();
						try {
							//damos de alta la reversa en la tabla de REVERSASOPER
							reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
							reversasOperBean.setEfectivo(ingresosOperacionesBean.getTotalSalida());
							reversasOperBean.setCambio(ingresosOperacionesBean.getTotalEntrada());
							mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Consulta si Bloquea el Saldo
							bloqueoSaldoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
							bloqueoSaldoBean.setReferencia(reversasOperBean.getTransaccionID()); // Número de Transaccion a reversar
							bloqueoSaldoConsulta = bloqueoSaldoDAO.consultaDesDevGarLiquida(bloqueoSaldoBean, BloqueoSaldoServicio.Enum_Con_TipoBloq.conBloqueoAutoTipoCta);

							// Se desbloquea el Saldo bloqueado
							if (bloqueoSaldoConsulta != null) {
								bloqueoSaldoBean.setBloqueoID(bloqueoSaldoConsulta.getBloqueoID());
								bloqueoSaldoBean.setTiposBloqID(BloqueoSaldoBean.TIPO_REVERSABLOQAUTOTIPOCTA);// Tipo de descloqueo 14 TIPOSBLOQUEOS
								bloqueoSaldoBean.setNatMovimiento(BloqueoSaldoBean.NAT_DESBLOQUEO);
								bloqueoSaldoBean.setFechaMov(ingresosOperacionesBean.getFecha());
								bloqueoSaldoBean.setFecha(ingresosOperacionesBean.getFecha());

								bloqueoSaldoBean.setDescripcion(BloqueoSaldoBean.DESCRI_DESBLOQREVDEPACTA);

								mensajeBean = bloqueoSaldoDAO.desbloqueoAutomaticoPro(bloqueoSaldoBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							// se hace el Cargo a cuenta
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Operacion de Entrada en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntEfCtaReversa);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Operacion de Salida en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalEfCtaReversa);

							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//********* se dan de alta movimientos de entrada de efectivo por cambio si los hubieran
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());
							}
							//validamos que la operacion de la Caja

							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Reversa Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de Abono a Cuenta", e);
						}
						return mensajeBean;
					}
				});
				if (mensaje.getNumero() != 0) {
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}

	/**
	 * Método de Proceso de Reversa de Garantía Liquida
	 * @param ingresosOperacionesBean
	 * @param bloqueoSaldoBean
	 * @param billetesMonedas
	 * @param reversasOperBean
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean reversaDepositoGarantiaLiquida(final IngresosOperacionesBean ingresosOperacionesBean, final BloqueoSaldoBean bloqueoSaldoBean, final List billetesMonedas, final ReversasOperBean reversasOperBean) {
		MensajeTransaccionBean mensaje = null;
		try {
			long numeroTransaccion = 0;
			mensaje = new MensajeTransaccionBean();

			String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
			String contrasenia = "";
			UsuarioBean usuarioBean = new UsuarioBean();
			usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());

			contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);

			String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()); // manda de pantalla

			if (!contrasenia.equals(passEnvio)) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}
			if (reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			}

			else {
				transaccionDAO.generaNumeroTransaccion(origenVent);
				int contador = 0;
				while (contador <= 3) {
					contador++;
					polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
						break;
					}
				}
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
							String depositoEfectivo = "DE";
							String cargoCuenta = "CC";
							try {
								//damos de alta la reversa en la tabla de REVERSASOPER
								reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
								mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
								// Reversa
								mensajeBean = reversaGarantiaLiquida(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								// Operacion de Entrada en Caja
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntGarLiqReversa);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								if ((ingresosOperacionesBean.getFormaPagoGL()).equals(depositoEfectivo)) { // si el deposito de GL fue en efectivo
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDepGarLiqReversa);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
									if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
										ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
										ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
										mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
									// se hacen los movimientos por denominacion
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
									ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
									ingresosOperacionesBean.setPolizaID(numeroPoliza);
									IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
									if (billetesMonedas.size() > 0) {
										for (int i = 0; i < billetesMonedas.size(); i++) {
											ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
											mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
											if (mensajeBean.getNumero() != 0) {
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									} else {
										mensajeBean.setNumero(999);
										mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
										mensajeBean.setNombreControl("numeroTransaccion");
										mensajeBean.setConsecutivoString("0");
										CadenaLog = "";
										CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
										loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

										throw new Exception(mensajeBean.getDescripcion());
									}

									// Se setea de nuevo los beans para el detalle de póliza
									ingresosOperacionesBean.setPolizaID(numeroPoliza);
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
									ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
									ingresosOperacionesBean.setEsDepODev(IngresosOperacionesBean.EsDevolucion);
									ingresosOperacionesBean.setTipoBloq(IngresosOperacionesBean.BloqGar);
									ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.reversaDesMovBloqGaranLiq);

									// se manda a llamar el store que agregará los detalles
									mensajeBean = agregaDetallesGL(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

									//validamos que la operacion de la Caja

									mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

								} else {
									// Deposito de GL con Cargo a Cuenta
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDepGLCargoCtaReversa); // 84 salida por reversa de Deposito de GL con CArgo A cuenta
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

									// Se setea de nuevo los beans para el detalle de póliza
									ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaSi);
									ingresosOperacionesBean.setNatConta(IngresosOperacionesBean.cargoCta);
									ingresosOperacionesBean.setEsDepODev(IngresosOperacionesBean.EsDevolucion);
									ingresosOperacionesBean.setTipoBloq(IngresosOperacionesBean.BloqGar);
									ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.reversaDesMovBloqGaranLiq);

									// se manda a llamar el store que agregará los detalles
									mensajeBean = agregaDetallesGL(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
									//validamos que la operacion de la Caja
									mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}

								}

								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Reversa Realizada Exitosamente.");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion(e.getMessage());
								}
								mensajeBean.setConsecutivoInt("0");
								mensajeBean.setNombreControl("");
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de deposito de garantia liquida", e);

							}
							return mensajeBean;
						}
					});
					if(mensaje.getNumero() != 0){
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
						polizaDAO.bajaPoliza(bajaPolizaBean);
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar la operación de Alta Cargo Cuenta.", ex);
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la operación de Alta Cargo Cuenta.");
			}
		}
		return mensaje;
	}
	/**
	 * METODO PARA LA REVERSA DEL COBRO DEL SEGURO DE VIDA
	 * @param ingresosOperacionesBean
	 * @param reversasOperBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean reversaCobroSeguroVida(final IngresosOperacionesBean ingresosOperacionesBean, final ReversasOperBean reversasOperBean, final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());

		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);

		String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()); // manda de pantalla

		if (!contrasenia.equals(passEnvio)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}

		else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion());
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = ingresosOperacionesBean.getPolizaID();
						try {
							//damos de alta la reversa en la tabla de REVERSASOPER
							reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
							mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Operacion de Salida en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaSalCobroSegVidaReversa);
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Operacion de Entrada en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaEntCobroSegVidaReversa);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Operacion de Entrada por Cambio (Si lo Hay)
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							//Se realizan los movimientos contables,se actualiza estatus de seguro y genera poliza
							mensajeBean = cobroSeguroVidaProReversa(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID()); // registra en instrumento el numero de caja
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());
							}
							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Reversa Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de Corbo de Seguro de Vida", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * reversa pago del seguro de vida por Siniestro
	 * @param ingresosOperacionesBean
	 * @param reversasOperBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean reversaPagoSeguroVida(final IngresosOperacionesBean ingresosOperacionesBean, final ReversasOperBean reversasOperBean, final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());

		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);

		String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()); // manda de pantalla

		if (!contrasenia.equals(passEnvio)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que Autoriza");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = ingresosOperacionesBean.getPolizaID();
						try {
							//damos de alta la reversa en la tabla de REVERSASOPER
							reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
							mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// 	Operacion de Entrada  en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntAplicSVReversa);
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//Operacion de Salida en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalAplicSVReversa);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//Operacion de Salida por Cambio (Si lo Hay)
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalEfCta);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se realizan los movimientos contables, se actualiza el estatus del seguro y se obtiene la poliza
							mensajeBean = reversaAplicaSeguroVida(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());
							}
							//validamos que la operacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Reversa Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa pago de seguro de vida", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}

	/**
	 * Reversa al Proceso de Desembolso
	 * @param ingresosOperacionesBean
	 * @param reversasOperBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean reversaDesembolsoCredito(final IngresosOperacionesBean ingresosOperacionesBean, final ReversasOperBean reversasOperBean, final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());

		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);

		String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()); // manda de pantalla

		if (!contrasenia.equals(passEnvio)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		} else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = ingresosOperacionesBean.getPolizaID();
						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnPolizaNo);
						try {
							//damos de alta la reversa en la tabla de REVERSASOPER
							reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
							mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// se hace el Cargo a cuenta
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// Operacion de Entrada en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntDesCreReversa);
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							}
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Operacion de Salida en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDesCreReversa);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//Operacion Salida de Cambio (Si lo Hay)
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalEfCta);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
								CreditosBean creditos = new CreditosBean();
								creditos.setCreditoID(ingresosOperacionesBean.getReferenciaMov());
								creditos.setMontoRetDes(ingresosOperacionesBean.getCantidadMov());

								mensajeBean = creditosDAO.actualizarMontosDesembolsados(creditos, CreditosServicio.Enum_Act_Creditos.actMontosDesemReversa, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());
							}
							//validamos que la operacion de la Caja

							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Reversa Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la Reversa del Desembolso del Credito", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * Reversa comision por apertura de Credito
	 * @param ingresosOperacionesBean
	 * @param reversasOperBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean reversaComisionAperturaCredito(final IngresosOperacionesBean ingresosOperacionesBean, final ReversasOperBean reversasOperBean, final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());

		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);

		String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()); // manda de pantalla

		if (!contrasenia.equals(passEnvio)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No Coincide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No puede ser el mismo que  Autoriza");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}

		else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = ingresosOperacionesBean.getPolizaID();
						try {
							//damos de alta la reversa en la tabla de REVERSASOPER
							reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
							mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Reversa de la Comision
							mensajeBean = revComisionAperCred(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							// Se realiza el cargo a Cuenta y obtenemos el numero de poliza
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Operacion de Entrada en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCACReversa);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Operacion de Salida en Caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCACReversa);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							// realizamos un movimiento por cambio si hubiese
							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							// se hacen los movimientos por denominacion
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());
							}
							//validamos que la operacion de la Caja

							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Reversa Realizada Exitosamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en reversa Comision por apertura de credito", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * Método para dar de alta las Reversas de Operaciones de Ventanilla
	 * @param reversasOperBean : Bean con la Información de la Operación a Dar Reversa
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaReversasOper(final ReversasOperBean reversasOperBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call REVERSASOPERALT("
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?,?,		"
									+ "?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_TransaccionID", Utileria.convierteEntero(reversasOperBean.getTransaccionID()));
							sentenciaStore.setString("Par_Motivo", reversasOperBean.getMotivo());
							sentenciaStore.setString("Par_DescripcionOper", reversasOperBean.getDescripcionOper());
							sentenciaStore.setInt("Par_TipoOperacion", Utileria.convierteEntero(reversasOperBean.getTipoOperacion()));
							sentenciaStore.setString("Par_Referencia", reversasOperBean.getReferencia());

							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(reversasOperBean.getMonto()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(reversasOperBean.getCajaID()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(reversasOperBean.getSucursalID()));

							sentenciaStore.setString("Par_Fecha", String.valueOf(parametrosSesionBean.getFechaSucursal()));
							sentenciaStore.setString("Par_ClaveUsuarioAut", reversasOperBean.getClaveUsuarioAut());
							sentenciaStore.setString("Par_ContraseniaAut", reversasOperBean.getContraseniaAut());
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(reversasOperBean.getUsuarioAutID()));
							sentenciaStore.setDouble("Par_Cambio", Utileria.convierteDoble(reversasOperBean.getCambio()));
							sentenciaStore.setDouble("Par_Efectivo", Utileria.convierteDoble(reversasOperBean.getEfectivo()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de Transacciones", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de Transacciones", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para dar la Reversa del Deposito de Garantia Liquida
	 * @param ingresosOperacionesBean
	 * @param numTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean reversaGarantiaLiquida(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call REVDEPGARANTIALIQ(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_NumeroMov", numTransaccion);
							sentenciaStore.setDate("Par_Fecha", parametrosSesionBean.getFechaSucursal());//OperacionesFechas.conversionStrDate(ingresosOperacionesBean.getFecha()));
							sentenciaStore.setDate("Par_FechaAplicacion", parametrosSesionBean.getFechaAplicacion());//OperacionesFechas.conversionStrDate(ingresosOperacionesBean.getFecha()));

							sentenciaStore.setString("Par_NatMovimiento", ingresosOperacionesBean.getNatMovimiento());
							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setString("Par_DescripcionMov", ingresosOperacionesBean.getDescripcionMov());
							sentenciaStore.setString("Par_ReferenciaMov", ingresosOperacionesBean.getReferenciaMov());
							sentenciaStore.setString("Par_TipoMovAhoID", ingresosOperacionesBean.getTipoMov());

							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setInt("Par_SucCliente", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.getAltaEnPoliza());
							sentenciaStore.setInt("Par_ConceptoCon", Utileria.convierteEntero(ingresosOperacionesBean.getConceptoCon()));
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_AltaPoliza", ingresosOperacionesBean.getAltaDetPoliza());
							sentenciaStore.setInt("Par_ConceptoAho", Utileria.convierteEntero(ingresosOperacionesBean.getConceptoAho()));
							sentenciaStore.setString("Par_NatConta", ingresosOperacionesBean.getNatConta());
							sentenciaStore.setInt("Par_TranGarantia", Utileria.convierteEntero(ingresosOperacionesBean.getTransaccionOperacionID()));
							sentenciaStore.setString("Par_FormaPagoGL", ingresosOperacionesBean.getFormaPagoGL());

							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);
							sentenciaStore.setInt("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de Pago de Garantia Liquida", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en Reversa de Pago de Garantia Liquida", e);
					}

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Realiza el Proceso de Cobro de Seguro de Vida
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la información de la Operación de Ventanilla
	 * @param numeroTransaccion : Número de Transacción
	 * @param origenVentanilla : Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean cobroSeguroVidaProReversa(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call COBROSEGVIDAPROREV(?,?,?,?,?  ,?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_SeguroVidaID", Utileria.convierteEntero(ingresosOperacionesBean.getSeguroVidaID()));
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setInt("Par_ProdCreID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));
							sentenciaStore.setDouble("Par_MontoPago", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para realizar la Reversa de la Aplicación de Seguro de Vida
	 * @param ingresosOperacionesBean
	 * @param numeroTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean reversaAplicaSeguroVida(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call REVAPLICSEGVIDA(?,?,?,?,?  ,?,?,?,?,?,   ?,?,?,?,?,  ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SeguroVidaID", Utileria.convierteEntero(ingresosOperacionesBean.getSeguroVidaID()));
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setInt("Par_ProdCreID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));
							sentenciaStore.setDouble("Par_MontoPago", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Consecutivo", Constantes.ENTERO_CERO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en aplica segurode vida", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en aplica segurode vida", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Reversa Comision por apertura de Credito
	 * @param ingresosOperacionesBean
	 * @param numTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean revComisionAperCred(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call REVCOMAPERCREDPRO(?,?,?,?,?, ?,?,?,?,?, ?,?, ?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setInt("Par_ProdCreID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));

							sentenciaStore.setDouble("Par_MontoComAp", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setString("Par_ForCobroComAper", ingresosOperacionesBean.getFormaCobroComApCre());
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);

							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de comision por apertura", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de comision por apertura", e);
					}

				}
				return mensajeBean;
			}
		});
		return mensaje;

	}
	/**
	 * Valida operacion en Caja, verifica si hay descuadre
	 * @param ingresosOperacionesBean : Bean con la informacion de la Operacion
	 * @param numTransaccion : Numero de Transaccion
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean validaOperacionCaja(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call OPERACIONCAJAVAL(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?, ?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setLong("Par_Transaccion", numTransaccion);
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setDouble("Par_MontoTotalEntrada", Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()));
							sentenciaStore.setDouble("Par_MontoTotalSalida", Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida()));
							sentenciaStore.setDouble("Par_MontoOperacion", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_TipoOperacion", Utileria.convierteEntero(ingresosOperacionesBean.getOpcionCajaID()));
							sentenciaStore.setString("Par_DescripcionMov", ingresosOperacionesBean.getDescripcionMov());
							sentenciaStore.setString("Par_Denominaciones", ingresosOperacionesBean.getDenominaciones());
							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));

							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la Validacion de la Caja", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la Validacion de la Caja", e);
					}

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	//Agrega detalles en Garantia Liquida
	/**
	 * Método para agregar Detalle de Garantia Liquida
	 * @param ingresosOperacionesBean
	 * @param numTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean agregaDetallesGL(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CONTAGARLIQPRO(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setDate("Par_FechaAplicacion", parametrosSesionBean.getFechaAplicacion());//OperacionesFechas.conversionStrDate(ingresosOperacionesBean.getFecha()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setString("Par_AltaEnPol", ingresosOperacionesBean.getAltaEnPoliza());
							sentenciaStore.setInt("Par_ConceptoCon", Utileria.convierteEntero(ingresosOperacionesBean.getConceptoCon()));
							sentenciaStore.setString("Par_EsDepGL", ingresosOperacionesBean.getEsDepODev());
							sentenciaStore.setInt("Par_TipoBloq", Utileria.convierteEntero(ingresosOperacionesBean.getTipoBloq()));
							sentenciaStore.setString("Par_DescripcionMov", ingresosOperacionesBean.getDescripcionMov());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.VARCHAR);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);
							sentenciaStore.setInt("Par_Empresa", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al agregar detalle en poliza de Garantía Líquida", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error al agregar detalle en poliza de Garantía Líquida", e);
					}

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Salida o Emision de Cheque, por Operaciones en Caja:
	 * Ejemplo: Cargo a Cuenta con Salida de Cheque de la propia Institucion
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la Informacion de la Operacion
	 * @param numeroTransaccion : Numero de la Transaccion
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean salidaDeCheque(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call CHEQUESREGEMISIONPRO(?,?,?,?,?,  ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(ingresosOperacionesBean.getBancoEmisor()));
							sentenciaStore.setString("Par_CuentaInstitucion", ingresosOperacionesBean.getCuentaBancos());
							sentenciaStore.setInt("Par_NumeroCheque", Utileria.convierteEntero(ingresosOperacionesBean.getNumeroCheque()));
							sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setInt("Par_SucursalID", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(ingresosOperacionesBean.getUsuario()));
							sentenciaStore.setString("Par_Concepto", ingresosOperacionesBean.getDescripcionMov());
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setString("Par_Beneficiario", ingresosOperacionesBean.getNombreBeneficiario());
							sentenciaStore.setString("Par_Referencia", ingresosOperacionesBean.getReferenciaMov());
							sentenciaStore.setString("Par_AltaEncPoliza", ingresosOperacionesBean.altaEnPolizaNo);
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_TipoChequera", ingresosOperacionesBean.getTipoChequera());

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getInt("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}
							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Registro del Cheque", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en el Registro del Cheque", e);
					}

					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * metodo pago cancelacion Socio
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean pagoCancelacionSocio(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		IngresosOperacionesBean ingresosOperaciones = null;
		ClientesCancelaBean clientesCancelaBean = new ClientesCancelaBean();
		clientesCancelaBean.setClienteCancelaID(ingresosOperacionesBean.getClienteCancelaID());
		clientesCancelaBean.setCliCancelaEntregaID(ingresosOperacionesBean.getCliCancelaEntregaID());

		double decimalCero = Double.parseDouble("0.0");
		String cadena_Vacia = "";
		clientesCancelaBean = clientesCancelaDAO.consultaDatosCancelacionSocio(clientesCancelaBean, ClientesCancelaServicio.Enum_Con_ClientesCancela.pagoCancelacionSoc);
		double cantidadRecibirBd = Double.parseDouble(clientesCancelaBean.getCantidadRecibir());
		if (!clientesCancelaBean.getEstatus().equals(ingresosOperaciones.estatusAutorizado)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Solicitud de Cancelacion no esta Autorizada");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (cantidadRecibirBd == decimalCero) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("No existe un Monto Pendiente por Entregar");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		if (clientesCancelaBean.getAreaCancela().equals(cadena_Vacia)) {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Area de la Solicitud de Cancelacion no esta Definida");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}

		else {
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while (contador <= 3) {
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					break;
				}
			}
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						ClientesCancelaBean clientesCancela = new ClientesCancelaBean();
						String numeroPoliza = "";
						try {
							// se hace el Cargo a cuenta
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							clientesCancela.setAltaEncPoliza(Constantes.STRING_NO);
							clientesCancela.setCliCancelaEntregaID(ingresosOperacionesBean.getCliCancelaEntregaID());
							clientesCancela.setClienteCancelaID(ingresosOperacionesBean.getClienteCancelaID());

							//Reimpresion ticket
							clientesCancela.setNombreCliente(ingresosOperacionesBean.getNombreBeneficiario());
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

							clientesCancela.setPolizaID(numeroPoliza);
							mensajeBean = clientesCancelaDAO.pagoCancelacionSocio(clientesCancela, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida

							//Movimiento de Entrada
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeEntradaPagoCancelSocio);
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeEntradaPagoCancelSocio); //Reimpresion ticket
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Movimiento de Salida: Efectivo o Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajaChequePagoCancelSocio);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);
							} else {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeSalidaPagoCancelSocio);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							}

							if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());//Reimpresion ticket
							}
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
							//********* se dan de alta movimientos de entrada de efectivo por cambio si los hubieran, siempre y cuando NO sea un Cheque la Salida
							if (!ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada());
									//Movimiento de Entrada de Efectivo por Cambio
									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
							if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
								ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getCuentaAhoID());
								mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());
								}
							}

							// Validamos la transacion de la Caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							//Se hace la insercion a la tabla de reimpresion de tickets
							ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.desPagoCancelSocio);
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							//Reimpresion pagoCancelacionSocio
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}

							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
						} catch (Exception e) {
							if (mensajeBean.getNumero() == 0) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en pago de cancelacion de socio", e);

						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero() != 0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			} else {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}
		return mensaje;
	}
	/**
	 * Método para ejecutar una salida de Efectivo o cheque segun Anticipos o Devoluciones.
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean anticiposGastos(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion(origenVent);
		int contador = 0;
		while (contador <= 3) {
			contador++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					CatalogoGastosAntBean catalogoGastosAnt = new CatalogoGastosAntBean();

					String numeroPoliza = "";
					try {
						numeroPoliza = ingresosOperacionesBean.getPolizaID();
						catalogoGastosAnt.setSucursalID(ingresosOperacionesBean.getSucursalID());
						catalogoGastosAnt.setCajaID(ingresosOperacionesBean.getCajaID());
						catalogoGastosAnt.setMonto(ingresosOperacionesBean.getMonto());
						catalogoGastosAnt.setNaturaleza(ingresosOperacionesBean.getEsDepODev());
						catalogoGastosAnt.setEsCheque(ingresosOperacionesBean.getFormaPago());
						catalogoGastosAnt.setFecha(ingresosOperacionesBean.getFecha());
						catalogoGastosAnt.setTipoAntGastoID(ingresosOperacionesBean.getTipoOperacion());
						catalogoGastosAnt.setEmpleadoID(ingresosOperacionesBean.getEmpleadoID());
						catalogoGastosAnt.setInstrumento(ingresosOperacionesBean.getInstrumento());
						catalogoGastosAnt.setMonedaID(ingresosOperacionesBean.getMonedaID());
						catalogoGastosAnt.setConceptoCon(ingresosOperacionesBean.getConceptoCon());
						catalogoGastosAnt.setDescripcion(ingresosOperacionesBean.getDescripcionMov());
						catalogoGastosAnt.setPolizaID(ingresosOperacionesBean.getPolizaID());
						mensajeBean = catalogoGastosAntDAO.anticiposGastosProceso(catalogoGastosAnt, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
						//Movimiento de Entrada
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getMonto());
						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntGastos);

						if (ingresosOperacionesBean.getEmpleadoID() != "") {
							ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getEmpleadoID());
						} else {
							ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getCajaID());
						}

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//Movimiento de Salida: Efectivo o Cheque
						if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalChequeGastos);

							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque); //Reimpresion ticket
						} else {
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalGastos);

							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);//Reimpresion ticket
						}
						if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalSalida());//Reimpresion ticket
						}

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//********* se dan de alta movimientos de entrada de efectivo por cambio si los hubieran, siempre y cuando NO sea un Cheque la Salida
						if (!ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
							if (Double.parseDouble(ingresosOperacionesBean.getTotalEntrada()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());

								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket

								//Movimiento de Entrada de Efectivo por Cambio
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						}

						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getInstrumento());
						ingresosOperacionesBean.setPolizaID(numeroPoliza);

						// Se hace el proceso de Registro de la Emision del Cheque, si la Salida fue por Cheque
						if (ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
							ingresosOperacionesBean.setCantidadMov(ingresosOperacionesBean.getMonto());
							mensajeBean = salidaDeCheque(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if (mensajeBean.getNumero() != 0) {
								throw new Exception(mensajeBean.getDescripcion());
							}
						} else {// se hacen los movimientos por denominacion si la Salida fue en Efectivo
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							if (billetesMonedas.size() > 0) {
								for (int i = 0; i < billetesMonedas.size(); i++) {
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							} else {
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

								throw new Exception(mensajeBean.getDescripcion());
							}
						}

						// Validamos la transacion de la Caja
						mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//Se hace la insercion a la tabla de reimpresion de tickets
						ingresosOperacionesBean.setDescripcionMov(IngresosOperacionesBean.DesAnticipoGastos);
						ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntGastos);
						ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getMonto());
						if (Utileria.convierteDoble(ingresosOperacionesBean.getTotalEfectivo()) == 0) {
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getMonto());
						}
						ingresosOperacionesBean.setReferenciaTicket(catalogoGastosAnt.getTipoAntGastoID());
						mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error alta de movimientos de anticipos", e);

					}
					return mensajeBean;
				}
			});
			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);
			}
		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}
	/**
	 * Método para ejecutar Entrada de Efectivo segun Anticipos o Devoluciones.
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean anticiposGastosDev(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		final String numeroOperacionOrig = ingresosOperacionesBean.getTipoOperacion();
		transaccionDAO.generaNumeroTransaccion(origenVent);
		int contador = 0;
		while (contador <= 3) {
			contador++;
			polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
			if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
				break;
			}
		}
		if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					CatalogoGastosAntBean catalogoGastosAnt = new CatalogoGastosAntBean();

					String numeroPoliza = "";
					try {
						numeroPoliza = ingresosOperacionesBean.getPolizaID();
						catalogoGastosAnt.setSucursalID(ingresosOperacionesBean.getSucursalID());
						catalogoGastosAnt.setCajaID(ingresosOperacionesBean.getCajaID());
						catalogoGastosAnt.setMonto(ingresosOperacionesBean.getMonto());
						catalogoGastosAnt.setNaturaleza(ingresosOperacionesBean.getEsDepODev());
						catalogoGastosAnt.setEsCheque(ingresosOperacionesBean.getFormaPago());
						catalogoGastosAnt.setFecha(ingresosOperacionesBean.getFecha());
						catalogoGastosAnt.setTipoAntGastoID(ingresosOperacionesBean.getTipoOperacion());
						catalogoGastosAnt.setEmpleadoID(ingresosOperacionesBean.getEmpleadoID());
						catalogoGastosAnt.setInstrumento(ingresosOperacionesBean.getInstrumento());
						catalogoGastosAnt.setMonedaID(ingresosOperacionesBean.getMonedaID());
						catalogoGastosAnt.setConceptoCon(ingresosOperacionesBean.getConceptoCon());
						catalogoGastosAnt.setDescripcion(ingresosOperacionesBean.getDescripcionMov());
						catalogoGastosAnt.setPolizaID(ingresosOperacionesBean.getPolizaID());
						mensajeBean = catalogoGastosAntDAO.anticiposGastosProceso(catalogoGastosAnt, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);

						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						// se hace el alta de los dos movimientos de caja, uno de entrada y otro de salida
						//Movimiento de Entrada
						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntDevolucion);

						//Reimpresion ticket
						ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getMonto());
						ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntDevolucion);

						if (ingresosOperacionesBean.getEmpleadoID() != "") {
							ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getEmpleadoID());
						} else {
							ingresosOperacionesBean.setReferenciaMov(ingresosOperacionesBean.getCajaID());
						}

						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//Movimientos de Salida

						ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getMonto());
						ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalDevolucion);
						mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//********* se dan de alta movimientos de salida de efectivo por cambio si los hubieran
						if (!ingresosOperacionesBean.getFormaPago().equalsIgnoreCase(IngresosOperacionesBean.formaPago_Cheque)) {
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada()); //Reimpresion ticket
							if (Double.parseDouble(ingresosOperacionesBean.getTotalSalida()) > 0) {
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());

								//Reimpresion ticket
								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);

								//Movimiento de Salida de Efectivo por Cambio
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Cheque);
						}

						ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getInstrumento());
						ingresosOperacionesBean.setPolizaID(numeroPoliza);

						// se hacen los movimientos por denominacion de la Entrada en Efectivo
						IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
						ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
						if (billetesMonedas.size() > 0) {
							for (int i = 0; i < billetesMonedas.size(); i++) {
								ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
								mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
						} else {
							mensajeBean.setNumero(999);
							mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString("0");
							CadenaLog = "";
							CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

							throw new Exception(mensajeBean.getDescripcion());
						}

						// Validamos la transacion de la Caja
						mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						//Se hace la insercion a la tabla de reimpresion de tickets
						ingresosOperacionesBean.setDescripcionMov("GASTOS Y ANTICIPOS DEVOLUCIONES");
						ingresosOperacionesBean.setReferenciaTicket(numeroOperacionOrig);
						//TICKET anticiposGastosDev
						mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
						if (mensajeBean.getNumero() != 0) {
							throw new Exception(mensajeBean.getDescripcion());
						}

						mensajeBean.setNumero(0);
						mensajeBean.setDescripcion("Operación Realizada Exitosamente.");
						mensajeBean.setNombreControl("numeroTransaccion");
						mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()) + "," + numeroPoliza);
					} catch (Exception e) {
						if (mensajeBean.getNumero() == 0) {
							mensajeBean.setNumero(999);
						}
						mensajeBean.setDescripcion(e.getMessage());
						transaction.setRollbackOnly();
						e.printStackTrace();
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error alta de movimientos de anticipos", e);

					}
					return mensajeBean;
				}
			});
			if(mensaje.getNumero() != 0){
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
				polizaDAO.bajaPoliza(bajaPolizaBean);
			}
		} else {
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
		}
		return mensaje;
	}
	/**
	 * Método para dar de alta la Reimpresion de Tickets de la Ventanilla
	 * @param ingresosOperacionesBean : Bean {@link IngresosOperacionesBean} con la Información para dar de alta la Reimpresion de los tickets
	 * @param creditoBean : Bean {@link CreditosBean} con la informacion para guardar en la Reimpresion del Ticket
	 * @param numTransaccion : Número de Transaccion
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return {@link MensajeTransaccionBean}
	 */
	public MensajeTransaccionBean reimpresionTicket(final IngresosOperacionesBean ingresosOperacionesBean, final CreditosBean creditoBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {

				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call REIMPRESIONTICKETALT" + "(?,?,?,?,?,     " + "?,?,?,?,?,     "
																		+ "?,?,?,?,?,     " + "?,?,?,?,?,     "
																		+ "?,?,?,?,?,     " + "?,?,?,?,?,     "
																		+ "?,?,?,?,?,     " + "?,?,?,?,?,     "
																		+ "?,?,?,?,?,     " + "?,?,?,?,?,     "
																		+ "?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_TransaccionID", numTransaccion);
							sentenciaStore.setInt("Par_TipoOperacion", Utileria.convierteEntero(ingresosOperacionesBean.getTipoOperaReimpre()));
							sentenciaStore.setInt("Par_CajaID", Utileria.convierteEntero(ingresosOperacionesBean.getCajaID()));
							sentenciaStore.setInt("Par_Sucursal", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setInt("Par_UsuarioID", parametrosAuditoriaBean.getUsuario());

							sentenciaStore.setInt("Par_OpcionCajaID", Utileria.convierteEntero(ingresosOperacionesBean.getOpcionCajaID()));
							sentenciaStore.setString("Par_Descripcion", ingresosOperacionesBean.getDescripcionMov());
							sentenciaStore.setString("Par_Referencia", ingresosOperacionesBean.getReferenciaTicket());
							sentenciaStore.setDouble("Par_MontoOpera", Utileria.convierteDoble(ingresosOperacionesBean.getTotalOperacion()));
							sentenciaStore.setDouble("Par_Efectivo", Utileria.convierteDoble(ingresosOperacionesBean.getTotalEfectivo()));

							sentenciaStore.setDouble("Par_Cambio", Utileria.convierteDoble(ingresosOperacionesBean.getTotalCambio()));
							sentenciaStore.setString("Par_NombrePersona", ingresosOperacionesBean.getNombreCliente());
							sentenciaStore.setString("Par_NombreRecibe", ingresosOperacionesBean.getNombreRecibePago());
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_ProspectoID", Utileria.convierteEntero(ingresosOperacionesBean.getProspectoID()));

							sentenciaStore.setInt("Par_EmpleadoID", Utileria.convierteEntero(ingresosOperacionesBean.getEmpleadoID()));
							sentenciaStore.setString("Par_CtaIDRetiro", ingresosOperacionesBean.getCuentaIDRetiro());
							sentenciaStore.setLong("Par_CtaIDDeposito", Utileria.convierteLong(ingresosOperacionesBean.getCuentaIDDeposito()));
							sentenciaStore.setString("Par_FormaPagoCobro", ingresosOperacionesBean.getFormaPagoCobro());
							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));

							sentenciaStore.setDouble("Par_Comision", Utileria.convierteDoble(ingresosOperacionesBean.getComision()));
							sentenciaStore.setDouble("Par_IVA", Utileria.convierteDoble(ingresosOperacionesBean.getIVATicket()));
							sentenciaStore.setInt("Par_GarantAdicional", Utileria.convierteEntero(ingresosOperacionesBean.getGarantiaLiqAdi()));
							sentenciaStore.setInt("Par_InstitucionID", Utileria.convierteEntero(ingresosOperacionesBean.getBancoEmisor()));
							sentenciaStore.setString("Par_NumCtaInstit", ingresosOperacionesBean.getCuentaCargoAbono());

							sentenciaStore.setLong("Par_NumCheque", Utileria.convierteLong(ingresosOperacionesBean.getNumeroCheque()));
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_Telefono", ingresosOperacionesBean.getTelefonoCliente());
							sentenciaStore.setString("Par_Identificacion", ingresosOperacionesBean.getTipoIdentifiCliente());
							sentenciaStore.setString("Par_FolioIdentif", ingresosOperacionesBean.getFolioIdentifiCliente());

							sentenciaStore.setString("Par_FolioPago", ingresosOperacionesBean.getReferenciaPago());
							sentenciaStore.setDouble("Par_MontoServicio", Utileria.convierteDoble(ingresosOperacionesBean.getMonto()));
							sentenciaStore.setDouble("Par_IVAServicio", Utileria.convierteDoble(ingresosOperacionesBean.getIVAMonto()));
							sentenciaStore.setInt("Par_CatalogoServID", Utileria.convierteEntero(ingresosOperacionesBean.getCatalogoServID()));
							sentenciaStore.setInt("Par_ChequeSBCID", Utileria.convierteEntero(ingresosOperacionesBean.getChequeSBCID()));

							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setDouble("Par_MontoPendPagoAportSocial", Utileria.convierteDoble(ingresosOperacionesBean.getMontoPendientePagoAS()));
							sentenciaStore.setDouble("Par_MontoPagAportSocial", Utileria.convierteDoble(ingresosOperacionesBean.getMontoPagadoAS()));
							sentenciaStore.setString("Par_CobraSeguroCuota", ingresosOperacionesBean.getCobraSeguroCuota());
							sentenciaStore.setDouble("Par_MontoSeguroCuota", Utileria.convierteDoble(ingresosOperacionesBean.getMontoSeguroCuota()));

							sentenciaStore.setDouble("Par_IVASeguroCuota", Utileria.convierteDoble(ingresosOperacionesBean.getiVASeguroCuota()));
							sentenciaStore.setLong("Par_ArrendaID", Utileria.convierteLong(ingresosOperacionesBean.getArrendaID()));
							sentenciaStore.setInt("Par_AccesorioID", Utileria.convierteEntero(ingresosOperacionesBean.getAccesoriosID()));

							sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en reimpresion de ticket", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en reimpresion de ticket", e);
					}

				}
				return mensajeBean;
			}
		});
		return mensaje;
	}
	/**
	 * Método para validar los Depositos a Cuentas
	 * @param cuentaAhoBean : CuentasAhoBean Bean con la Informacion de la Cuenta
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean depCuentasValVentanilla(final CuentasAhoBean cuentaAhoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call DEPCUENTASVAL(?,?,?,?, ?,?,?, ?,?,?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_CuentaAhoID", cuentaAhoBean.getCuentaAhoID());
							sentenciaStore.setDouble("Par_MontoMov", Utileria.convierteDoble(cuentaAhoBean.getMontoMovimiento()));
							sentenciaStore.setString("Par_Fecha", Utileria.convierteFecha(cuentaAhoBean.getFechaMovimento()));
							sentenciaStore.setInt("Par_TipoVal", 1);

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();

								mensajeTransaccion.setNumero(resultadosStore.getInt(1));
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Error en Validacion de Medios de Acceso de la Cuenta.");
							}

							return mensajeTransaccion;
						}
					});
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Error en Validacion de Medios de Acceso de la Cuenta.");
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la ejecución del SP", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para realizar el proceso de corbro de accesorios y demás movimientos.
	 * @param ingresosOperacionesBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean accesoriosCredito(final IngresosOperacionesBean ingresosOperacionesBean,final List billetesMonedas){
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		if(ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)){
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Monto está Vacío.");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}else{
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while(contador<=3){
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(),origenVent);
				if(Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID())>0){
					break;
				}
			}
			if(Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID())>0){
				mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = "";
						try{
							numeroPoliza = ingresosOperacionesBean.getPolizaID();
							ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);
							ingresosOperacionesBean.setPolizaID(numeroPoliza);

							// Sección para la Reimpresion de ticket
							ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());
							ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());
							ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
							ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajSalCobroAccesCre);
							ingresosOperacionesBean.setCuentaIDRetiro(ingresosOperacionesBean.getCuentaAhoID());
							// Realiza el abono a cuenta para el pago
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(),origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Método donde se manda a llamar el SP para el cobro de accesorio correspondiente
							mensajeBean = cobroAccesoriosCredito(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(),origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para el alta de movimientos en caja por entradas
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntCobroAccesCre);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para el alta de movimientos en caja para el monto a cobrar
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCobroAccesCre);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para el alta de movimientos en caso de existir salidas
							if(Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida())>0){
								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
								ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida()); // Reimpresion ticket
								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if(mensajeBean.getNumero()!=0){
									throw new Exception(mensajeBean.getDescripcion());
								}
							}
							// Sección para los movimientos de denominaciones
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if(billetesMonedas.size()>0){
								for(int i=0; i<billetesMonedas.size();i++){
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}else{
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("Operación No Realizada. Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BilletesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja: " + ingresosOperacionesBean.getOpcionCajaID() + " Monto: " + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + CadenaLog);
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para validar la operacion en caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para la impresión de Ticket
							ingresosOperacionesBean.setReferenciaTicket(ingresosOperacionesBean.getReferenciaMov());
							ingresosOperacionesBean.setDescripcionMov("COBRO ACCESORIO DE CREDITO");
							mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección Final mensaje de Éxito
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Operación Realizada Exitosamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						}catch(Exception e){
							if(mensajeBean.getNumero()==0){
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de accesorios de credito.");
						}
						return mensajeBean;
					}
				});
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Poliza se encuentra Vacío.");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}

		return mensaje;
	}

	/**
	 * Método para realizar el cobro de accesorios nivel base de datos.
	 * @param ingresosOperacionesBean
	 * @param numTransaccion
	 * @param origenVentanilla
	 * @return
	 */
	public MensajeTransaccionBean cobroAccesoriosCredito(final IngresosOperacionesBean ingresosOperacionesBean,final long numTransaccion, final boolean origenVentanilla){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException{
							String query = "CALL COBROACCESORIOSCREPRO(?,?,?,?,?, "
																	+ "?,?,?,?,?, "
																	+ "?,?,?,?,?, "
																	+ "?,?,?,?,?, "
																	+ "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setInt("Par_AccesorioID", Utileria.convierteEntero(ingresosOperacionesBean.getAccesoriosID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setInt("Par_ProductoCreditoID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));
							sentenciaStore.setDouble("Par_MontoAccesorio", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));
							sentenciaStore.setDouble("Par_IvaAccesorio", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));

							sentenciaStore.setString("Par_ForCobroAccesorio",ingresosOperacionesBean.formaPagoAccesorio);
							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_OrigenPago", Constantes.ORIGEN_PAGO_VENTANILLA);

							sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);

							if(origenVentanilla){
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + sentenciaStore.toString());
							}else{
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					},new CallableStatementCallback(){
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadoStore = callableStatement.getResultSet();

									resultadoStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadoStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadoStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}

								return mensajeTransaccion;
							}
					});

					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Follo. Procedimiento no Regreso Nigun Resultado.");
					}else if (mensajeBean.getNumero() != 0) {
						throw new Exception();
					}
				}catch(Exception e){
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if(origenVentanilla){
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de accesorio de crédito",e);
					}else{
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en cobro de accesorio de crédito",e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para realizar la reversa de cobro de accesorios de crédito
	 * @param ingresosOperacionesBean
	 * @param reversasOperBean
	 * @param billetesMonedas
	 * @return
	 */
	public MensajeTransaccionBean reversaAccesoriosCredito(final IngresosOperacionesBean ingresosOperacionesBean,final ReversasOperBean reversasOperBean,final List billetesMonedas) {
		long numeroTransaccion = 0;
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		// Sección verificarción de usuario de autorización para la operación de reserva.
		String usuarioLog = ingresosOperacionesBean.getUsuarioLogueado();
		String contrasenia = "";
		UsuarioBean usuarioBean = new UsuarioBean();
		usuarioBean.setUsuario(reversasOperBean.getClaveUsuarioAut());
		contrasenia = usuarioDAO.consultaPassUsuario(usuarioBean, UsuarioServicio.Enum_Con_Usuario.clave);
		String passEnvio = SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut());
		if(!contrasenia.equals(passEnvio)){
			mensaje.setNumero(999);
			mensaje.setDescripcion("La Contraseña No coicide con el Usuario Indicado");
			mensaje.setNombreControl("numeroTransacción");
			mensaje.setConsecutivoString("0");
			return mensaje;
		}
		//Sección de Operaciones Reversa
		if(reversasOperBean.getClaveUsuarioAut().equals(usuarioLog)){
			mensaje.setNumero(999);
			mensaje.setDescripcion("El Usuario que Realiza la Transacción No pude ser el mismo que Autorisa");
			mensaje.setNombreControl("numeroTransaccion");
			mensaje.setConsecutivoInt("0");
			return mensaje;
		}else{
			transaccionDAO.generaNumeroTransaccion(origenVent);
			int contador = 0;
			while(contador<=3){
				contador++;
				polizaDAO.generaPolizaID(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(),origenVent);
				if(Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID())>0){
					break;
				}
			}
			if(Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID())>0){
				mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction){
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						String numeroPoliza = ingresosOperacionesBean.getPolizaID();
						try{
							// Sección para el alta de la reversa.
							reversasOperBean.setContraseniaAut(SeguridadRecursosServicio.encriptaPass(reversasOperBean.getClaveUsuarioAut(), reversasOperBean.getContraseniaAut()));
							mensajeBean = altaReversasOper(reversasOperBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para aplicar la Reversa de Pago del Accesorios
							mensajeBean = revAccesorioCredito(ingresosOperacionesBean,parametrosAuditoriaBean.getNumeroTransaccion(),origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para las operaciones conla cuenta
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							mensajeBean = cargoAbonoCuenta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Seccion para agregar operaciones de entrada en caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntRevCobroAcces);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para agregar operaciones de salida en caja
							ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalRevCobroAcces);
							ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
							mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Seccion para agregar operaciones de cambio si esque hubiese
							ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
							ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
							ingresosOperacionesBean.setPolizaID(numeroPoliza);
							IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
							if(billetesMonedas.size()>0){
								for(int i=0;i<billetesMonedas.size();i++){
									ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
									mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}else{
								mensajeBean.setNumero(999);
								mensajeBean.setDescripcion("Operación No Realizada, Favor de Intentarlo Nuevamente");
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString("0");
								CadenaLog = "";
								CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BilletesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja: " + ingresosOperacionesBean.getOpcionCajaID() + " Monto: " + ingresosOperacionesBean.getCantidadMov());
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + CadenaLog);
								throw new Exception(mensajeBean.getDescripcion());
							}
							// Sección para validar la ejecución correcta de las operaciones en caja
							mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
							if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
							mensajeBean.setNumero(0);
							mensajeBean.setDescripcion("Reversa Realizada Exitosamente");
							mensajeBean.setNombreControl("numeroTransaccion");
							mensajeBean.setConsecutivoInt(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
						}catch(Exception e){
							if(mensajeBean.getNumero()==0){
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en reversa Cobro de Accesorios por Crédito.",e);
						}
						return mensajeBean;
					}
				});
				if(mensaje.getNumero()!=0){
					PolizaBean bajaPolizaBean = new PolizaBean();
					bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
					bajaPolizaBean.setNumCheque(String.valueOf(Constantes.ENTERO_CERO));
					bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
					polizaDAO.bajaPoliza(bajaPolizaBean);
				}
			}else{
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Número de Póliza se encuentra vacío");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
			}
		}

		return mensaje;
	}

	public MensajeTransaccionBean revAccesorioCredito(final IngresosOperacionesBean ingresosOperacionesBean, final long numeroTransaccion,final boolean origenVentanilla){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction){
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try{
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL REVACCESORIOSCREDPRO('?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?,?,?,?,?,"
									+ "?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(ingresosOperacionesBean.getCreditoID()));
							sentenciaStore.setInt("Par_AccesorioID", Utileria.convierteEntero(ingresosOperacionesBean.getAccesoriosID()));
							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));

							sentenciaStore.setInt("Par_ProdCreID", Utileria.convierteEntero(ingresosOperacionesBean.getProductoCreditoID()));
							sentenciaStore.setInt("Par_SucursalCliente", Utileria.convierteEntero(ingresosOperacionesBean.getSucursalID()));
							sentenciaStore.setString("Par_ClasifCred",ingresosOperacionesBean.getClasificacionServPSL());// varificar esta clacificacion
							sentenciaStore.setInt("Par_SubClasifCred", Constantes.ENTERO_CERO); // varificar esta constante
							sentenciaStore.setString("Par_PagaIVA", ingresosOperacionesBean.getiVAComision());

							sentenciaStore.setInt("Par_Poliza", Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()));
							sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numeroTransaccion);

							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}
							return sentenciaStore;
						}
					},new CallableStatementCallback(){
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException{
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadoStore = callableStatement.getResultSet();

									resultadoStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)));
									mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadoStore.getString(3));
									mensajeTransaccion.setConsecutivoInt(resultadoStore.getString(4));
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regresa ningun Resultado.");
								}
								return mensajeTransaccion;
							}
					});
				}catch(Exception e){
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en reversa de cobro de accesorio", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en reversa de cobro de accesorio", e);
					}
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/**
	 * Método para realizar la Operación de deposito par activacion de Cuenta
	 * @param ingresosOperacionesBean : Bean IngresosOperacionesBean con la Información de la Operación
	 * @param billetesMonedas : Lista de Denominaciones
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean altaDepositoActivaCta(final IngresosOperacionesBean ingresosOperacionesBean, final List billetesMonedas) {
		MensajeTransaccionBean mensaje = null;
		try {
			mensaje = new MensajeTransaccionBean();

			CuentasAhoBean cuentaAhoBean = new CuentasAhoBean();
			cuentaAhoBean.setCuentaAhoID(ingresosOperacionesBean.getCuentaAhoID());
			cuentaAhoBean.setMontoMovimiento(ingresosOperacionesBean.getCantidadMov());
			cuentaAhoBean.setFechaMovimento(ingresosOperacionesBean.getFecha());

			if (ingresosOperacionesBean.getCantidadMov().equals(IngresosOperacionesBean.enteroCero)) {
				mensaje.setNumero(999);
				mensaje.setDescripcion("El Monto esta Vacío");
				mensaje.setNombreControl("numeroTransaccion");
				mensaje.setConsecutivoString("0");
				return mensaje;
			} else {
				transaccionDAO.generaNumeroTransaccion(origenVent);
				int contador = 0;
				while (contador <= 3) {
					contador++;
					polizaDAO.generaPolizaID(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
					if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
						break;
					}
				}

				if (Utileria.convierteEntero(ingresosOperacionesBean.getPolizaID()) > 0) {
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							String numeroPoliza = "";
							try {
								numeroPoliza = ingresosOperacionesBean.getPolizaID();
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								ingresosOperacionesBean.setAltaEnPoliza(Constantes.STRING_NO);

								mensajeBean = depositoActivaCta(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "- Respuesta Deposito Activacion: "+ mensajeBean.getNumero()+'-'  + mensajeBean.getDescripcion());
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajEntEfeDepActCta);

								//Reimpresion de ticket
								ingresosOperacionesBean.setTipoOperaReimpre(IngresosOperacionesBean.opeCajEntEfeDepActCta);
								ingresosOperacionesBean.setFormaPagoCobro(IngresosOperacionesBean.formaPago_Efectivo);
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalEntrada());
								ingresosOperacionesBean.setTotalEfectivo(ingresosOperacionesBean.getTotalEntrada());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalEfeDepActCta);

								// Reimpresion de ticket
								ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getCantidadMov());
								ingresosOperacionesBean.setTotalOperacion(ingresosOperacionesBean.getCantidadMov());

								mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								if ((Utileria.convierteDoble(ingresosOperacionesBean.getTotalSalida())) > 0) {

									ingresosOperacionesBean.setTipoOperacion(IngresosOperacionesBean.opeCajSalCambio);
									ingresosOperacionesBean.setMontoEnFirme(ingresosOperacionesBean.getTotalSalida());
									// Reimpresion de ticket
									ingresosOperacionesBean.setTotalCambio(ingresosOperacionesBean.getTotalSalida());

									mensajeBean = altaMovsCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
									if (mensajeBean.getNumero() != 0) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}

								// se hacen los movimientos por denominacion
								ingresosOperacionesBean.setAltaEnPoliza(IngresosOperacionesBean.altaEnDetPolizaNo);
								ingresosOperacionesBean.setInstrumento(ingresosOperacionesBean.getCajaID());
								ingresosOperacionesBean.setPolizaID(numeroPoliza);
								IngresosOperacionesBean ingOpeBilletesMonBean = new IngresosOperacionesBean();
								if (billetesMonedas.size() > 0) {
									for (int i = 0; i < billetesMonedas.size(); i++) {
										ingOpeBilletesMonBean = (IngresosOperacionesBean) billetesMonedas.get(i);
										mensajeBean = altaDenominacionMovimientos(ingresosOperacionesBean, ingOpeBilletesMonBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
										if (mensajeBean.getNumero() != 0) {
											throw new Exception(mensajeBean.getDescripcion());
										}
									}
								} else {
									mensajeBean.setNumero(999);
									mensajeBean.setDescripcion("La Operación No Realizada, Favor de Intentarlo Nuevamente");
									mensajeBean.setNombreControl("numeroTransaccion");
									mensajeBean.setConsecutivoString("0");
									CadenaLog = "";
									CadenaLog = ("Caja: " + ingresosOperacionesBean.getCajaID() + " Sucursal:" + ingresosOperacionesBean.getSucursalID() + " BillestesMonedas: " + billetesMonedas.size() + " Numero de Transaccion: " + parametrosAuditoriaBean.getNumeroTransaccion() + " Opcion Caja:  " + ingresosOperacionesBean.getOpcionCajaID() + " Monto:" + ingresosOperacionesBean.getCantidadMov());
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + CadenaLog);

									throw new Exception(mensajeBean.getDescripcion());

								}

								//Se hace la insercion a la tabla de reimpresion de tickets
								ingresosOperacionesBean.setCuentaIDDeposito(ingresosOperacionesBean.getCuentaAhoID());
								ingresosOperacionesBean.setCuentaIDRetiro(Constantes.STRING_CERO);
								mensajeBean = reimpresionTicket(ingresosOperacionesBean, null, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								// Validamos la transacion de la Caja
								mensajeBean = validaOperacionCaja(ingresosOperacionesBean, parametrosAuditoriaBean.getNumeroTransaccion(), origenVent);
								if (mensajeBean.getNumero() != 0) {
									throw new Exception(mensajeBean.getDescripcion());
								}

								mensajeBean.setNumero(0);
								mensajeBean.setDescripcion("Deposito para Activación Realizado Exitosamente." + saltoLinea );
								mensajeBean.setNombreControl("numeroTransaccion");
								mensajeBean.setConsecutivoString(String.valueOf(parametrosAuditoriaBean.getNumeroTransaccion()));
							} catch (Exception e) {
								if (mensajeBean.getNumero() == 0) {
									mensajeBean.setNumero(999);
								}
								mensajeBean.setDescripcion(e.getMessage());
								transaction.setRollbackOnly();
								e.printStackTrace();
								loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "error en Deposito para Activacion de Cuenta. ", e);

							}
							return mensajeBean;
						}
					});
					if(mensaje.getNumero() != 0){
						PolizaBean bajaPolizaBean = new PolizaBean();
						bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
						bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
						bajaPolizaBean.setPolizaID(ingresosOperacionesBean.getPolizaID());
						polizaDAO.bajaPoliza(bajaPolizaBean);
					}
				} else {
					mensaje.setNumero(999);
					mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
					mensaje.setNombreControl("numeroTransaccion");
					mensaje.setConsecutivoString("0");
				}
			}
		} catch (Exception ex) {
			loggerVent.info("Error al realizar la Operación de Deposito para Activacion de Cuenta.", ex);
			ex.printStackTrace();
			if (mensaje == null) {
				mensaje = new MensajeTransaccionBean();
				mensaje.setNumero(999);
				mensaje.setDescripcion("Error al realizar la Operación de Deposito para Activacion de Cuenta.");
			}
		}
		return mensaje;
	}

	public MensajeTransaccionBean depositoActivaCta(final IngresosOperacionesBean ingresosOperacionesBean, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call DEPOSITOACTIVACTAAHOPRO(" +
									"?,?,?,?,?," +
									"?,?,?,?," +
									"?,?,?," +
									"?,?,?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setLong("Par_CuentaAhoID", Utileria.convierteLong(ingresosOperacionesBean.getCuentaAhoID()));
							sentenciaStore.setInt("Par_ClienteID", Utileria.convierteEntero(ingresosOperacionesBean.getClienteID()));
							sentenciaStore.setDate("Par_FechaAplicacion", parametrosSesionBean.getFechaAplicacion());
							sentenciaStore.setString("Par_NatMovimiento", ingresosOperacionesBean.getNatMovimiento());
							sentenciaStore.setDouble("Par_CantidadMov", Utileria.convierteDoble(ingresosOperacionesBean.getCantidadMov()));

							sentenciaStore.setString("Par_DescripcionMov", ingresosOperacionesBean.getDescripcionMov());
							sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(ingresosOperacionesBean.getMonedaID()));
							sentenciaStore.setInt("Par_ConceptoAhoID", Utileria.convierteEntero(ingresosOperacionesBean.getConceptoAho()));
							sentenciaStore.setLong("Par_PolizaID", Utileria.convierteLong(ingresosOperacionesBean.getPolizaID()));

							sentenciaStore.setString("Par_Salida", Constantes.salidaSI);
							sentenciaStore.setInt("Par_NumErr", Constantes.ENTERO_CERO);
							sentenciaStore.setString("Par_ErrMen", Constantes.STRING_VACIO);

							sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", parametrosAuditoriaBean.getNombrePrograma());
							sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", numTransaccion);
							if (origenVentanilla) {
								loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							} else {
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
							}

							return sentenciaStore;
						}
					}, new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if (callableStatement.execute()) {
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
								mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
								mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
								mensajeTransaccion.setConsecutivoInt(resultadosStore.getString(4));
							} else {
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
							}

							return mensajeTransaccion;
						}
					});

					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					} else if (mensajeBean.getNumero() != 0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + " error en deposito para activacion de cuenta", e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + " error en deposito para activacion de cuenta", e);
					}
				}
				return mensajeBean;

			}
		});
		return mensaje;
	}

	//--------------------------getter y setter-----------------
	public void setBloqueoSaldoDAO(BloqueoSaldoDAO bloqueoSaldoDAO) {
		this.bloqueoSaldoDAO = bloqueoSaldoDAO;
	}

	public void setCreditosDAO(CreditosDAO creditosDAO) {
		this.creditosDAO = creditosDAO;
	}

	public void setSeguroVidaDAO(SeguroVidaDAO seguroVidaDAO) {
		this.seguroVidaDAO = seguroVidaDAO;
	}

	public ServiFunEntregadoDAO getServiFunEntregadoDAO() {
		return serviFunEntregadoDAO;
	}

	public void setServiFunEntregadoDAO(ServiFunEntregadoDAO serviFunEntregadoDAO) {
		this.serviFunEntregadoDAO = serviFunEntregadoDAO;
	}
	public ApoyoEscolarSolDAO getApoyoEscolarSolDAO() {
		return apoyoEscolarSolDAO;
	}

	public void setApoyoEscolarSolDAO(ApoyoEscolarSolDAO apoyoEscolarSolDAO) {
		this.apoyoEscolarSolDAO = apoyoEscolarSolDAO;
	}

	public ParamFaltaSobraDAO getParamFaltaSobraDAO() {
		return paramFaltaSobraDAO;
	}

	public void setParamFaltaSobraDAO(ParamFaltaSobraDAO paramFaltaSobraDAO) {
		this.paramFaltaSobraDAO = paramFaltaSobraDAO;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}

	public TarjetaDebitoDAO getTarjetaDebitoDAO() {
		return tarjetaDebitoDAO;
	}

	public void setTarjetaDebitoDAO(TarjetaDebitoDAO tarjetaDebitoDAO) {
		this.tarjetaDebitoDAO = tarjetaDebitoDAO;
	}

	public ClientesCancelaDAO getClientesCancelaDAO() {
		return clientesCancelaDAO;
	}

	public void setClientesCancelaDAO(ClientesCancelaDAO clientesCancelaDAO) {
		this.clientesCancelaDAO = clientesCancelaDAO;
	}

	public CatalogoGastosAntDAO getCatalogoGastosAntDAO() {
		return catalogoGastosAntDAO;
	}

	public void setCatalogoGastosAntDAO(CatalogoGastosAntDAO catalogoGastosAntDAO) {
		this.catalogoGastosAntDAO = catalogoGastosAntDAO;
	}

	public ClienteExMenorDAO getClienteExMenorDAO() {
		return clienteExMenorDAO;
	}

	public void setClienteExMenorDAO(ClienteExMenorDAO clienteExMenorDAO) {
		this.clienteExMenorDAO = clienteExMenorDAO;
	}

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}

	public ServiFunFoliosDAO getServiFunFoliosDAO() {
		return serviFunFoliosDAO;
	}

	public void setServiFunFoliosDAO(ServiFunFoliosDAO serviFunFoliosDAO) {
		this.serviFunFoliosDAO = serviFunFoliosDAO;
	}

	public AmortizacionCreditoDAO getAmortizacionCreditoDAO() {
		return amortizacionCreditoDAO;
	}

	public void setAmortizacionCreditoDAO(
			AmortizacionCreditoDAO amortizacionCreditoDAO) {
		this.amortizacionCreditoDAO = amortizacionCreditoDAO;
	}

	public CastigosCarteraDAO getCastigosCarteraDAO() {
		return castigosCarteraDAO;
	}

	public void setCastigosCarteraDAO(CastigosCarteraDAO castigosCarteraDAO) {
		this.castigosCarteraDAO = castigosCarteraDAO;
	}

	public CreditoDevGLDAO getCreditoDevGLDAO() {
		return creditoDevGLDAO;
	}

	public void setCreditoDevGLDAO(CreditoDevGLDAO creditoDevGLDAO) {
		this.creditoDevGLDAO = creditoDevGLDAO;
	}

	public UsuarioDAO getUsuarioDAO() {
		return usuarioDAO;
	}

	public void setUsuarioDAO(UsuarioDAO usuarioDAO) {
		this.usuarioDAO = usuarioDAO;
	}

	public CuentasAhoDAO getCuentasAhoDAO() {
		return cuentasAhoDAO;
	}

	public void setCuentasAhoDAO(CuentasAhoDAO cuentasAhoDAO) {
		this.cuentasAhoDAO = cuentasAhoDAO;
	}
	public ArrendamientosDAO getArrendamientosDAO() {
		return arrendamientosDAO;
	}
	public void setArrendamientosDAO(ArrendamientosDAO arrendamientosDAO) {
		this.arrendamientosDAO = arrendamientosDAO;
	}

	public PSLCobroSLDAO getPslCobroSLDAO() {
		return pslCobroSLDAO;
	}
	public void setPslCobroSLDAO(PSLCobroSLDAO pslCobroSLDAO) {
		this.pslCobroSLDAO = pslCobroSLDAO;
	}

	public ComisionesSaldoPromedioDAO getComisionesSaldoPromedioDAO() {
		return comisionesSaldoPromedioDAO;
	}

	public void setComisionesSaldoPromedioDAO(ComisionesSaldoPromedioDAO comisionesSaldoPromedioDAO) {
		this.comisionesSaldoPromedioDAO = comisionesSaldoPromedioDAO;
	}
}
