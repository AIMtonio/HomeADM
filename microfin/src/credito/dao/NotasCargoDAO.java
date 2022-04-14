package credito.dao;

import general.dao.BaseDAO;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Arrays;

import herramientas.Constantes;
import herramientas.Utileria;
import soporte.bean.ParamGeneralesBean;
import soporte.dao.ParamGeneralesDAO;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import credito.bean.NotasCargoBean;
import credito.bean.NotasCargoRepBean;
import general.bean.MensajeTransaccionBean;
import general.bean.ParametrosSesionBean;

public class NotasCargoDAO extends BaseDAO {

	ParametrosSesionBean parametrosSesionBean;
	public NotasCargoDAO() {
		super();
	}

	public List listaNotasCargo(final NotasCargoBean notasCargoBean, int tipoLista){
		List ListaResultado=null;

		try{
		String query = "call NOTASCARGOREP(?,?,?,?,?,  ?,?,?,?,?, ?,?)";

		Object[] parametros ={
							Utileria.convierteFecha(notasCargoBean.getFechaInicio()),
							Utileria.convierteFecha(notasCargoBean.getFechaFin()),
							Utileria.convierteEntero(notasCargoBean.getProductoCreditoID()),
							Utileria.convierteEntero(notasCargoBean.getInstitucionNominaID()),
							Utileria.convierteEntero(notasCargoBean.getConvenioNominaID()),

				    		parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							parametrosAuditoriaBean.getNombrePrograma(),
							parametrosAuditoriaBean.getSucursal(),
							Constantes.ENTERO_CERO};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOTASCRAGOREP(  " + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				NotasCargoRepBean notasCargoRepBean= new NotasCargoRepBean();

				notasCargoRepBean.setProductoCredito(resultSet.getString("ProductoCredito"));
				notasCargoRepBean.setInstitucionNomina(resultSet.getString("InstitucionNomina"));
				notasCargoRepBean.setConvenioNomina(resultSet.getString("ConvenioNomina"));
				notasCargoRepBean.setClienteID(resultSet.getString("ClienteID"));
				notasCargoRepBean.setNombreCliente(resultSet.getString("NombreCliente"));
				notasCargoRepBean.setCreditoID(resultSet.getString("CreditoID"));
				notasCargoRepBean.setAmortizacionID(resultSet.getString("AmortizacionID"));
				notasCargoRepBean.setReferencia(resultSet.getString("Referencia"));
				notasCargoRepBean.setFechaRegistro(resultSet.getString("FechaRegistro"));
				notasCargoRepBean.setTipoNotaCargo(resultSet.getString("TipoNotaCargo"));
				notasCargoRepBean.setMonto(resultSet.getString("Monto"));
				notasCargoRepBean.setIva(resultSet.getString("IVA"));
				notasCargoRepBean.setMotivo(resultSet.getString("Motivo"));
				notasCargoRepBean.setAmPagoNoReconoID(resultSet.getString("AmPagoNoReconoID"));
				notasCargoRepBean.setReferenciaNoRecono(resultSet.getString("ReferenciaNoRecono"));
				notasCargoRepBean.setCapital(resultSet.getString("Capital"));
				notasCargoRepBean.setInteres(resultSet.getString("Interes"));
				notasCargoRepBean.setIvaInteres(resultSet.getString("IVAInteres"));
				notasCargoRepBean.setMoratorio(resultSet.getString("Moratorio"));
				notasCargoRepBean.setIvaMoratorio(resultSet.getString("IVAMoratorio"));
				notasCargoRepBean.setOtrasComisiones(resultSet.getString("OtrasComisiones"));
				notasCargoRepBean.setIvaOtrasComisiones(resultSet.getString("IVAOtrasComisiones"));
				notasCargoRepBean.setTotalPago(resultSet.getString("TotalPago"));
				notasCargoRepBean.setEstatus(resultSet.getString("Estatus"));

				return notasCargoRepBean;
			}
		});
		ListaResultado= matches;
		}catch(Exception e){
			 e.printStackTrace();
			 loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en consulta de reprte de Notas Cargo", e);
		}
		return ListaResultado;
	}

	public MensajeTransaccionBean altaNotasPagosNoReconocidos(final NotasCargoBean notasCargoBean, final ArrayList<NotasCargoBean> listaDetalleGrid) {
		MensajeTransaccionBean mensajeResultado = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensajeResultado = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
				new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						NotasCargoBean iterBean = null;
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {

							if (listaDetalleGrid.isEmpty()) {
								throw new Exception("La lista de notas de cargo de pagos no reconocidos est&aacute; vac&iacute;a");
							}

							// Alta notas de cargo
							if (!listaDetalleGrid.isEmpty()) {
								for(int registro = 0; registro < listaDetalleGrid.size(); registro++) {
									iterBean = (NotasCargoBean) listaDetalleGrid.get(registro);
									NotasCargoBean altaBean = new NotasCargoBean();
									altaBean.setCreditoID(iterBean.getCreditoID());
									altaBean.setAmortizacionID(iterBean.getAmortizacionID());
									altaBean.setTipoNotaCargoID(notasCargoBean.getTipoNotaCargoID());
									altaBean.setMonto(notasCargoBean.getMonto());
									altaBean.setMotivo(notasCargoBean.getMotivo());
									altaBean.setCapital(iterBean.getCapital());
									altaBean.setInteresOrd(iterBean.getInteresOrd());
									altaBean.setIvaInteres(iterBean.getIvaInteres());
									altaBean.setMoratorio(iterBean.getMoratorio());
									altaBean.setIvaMoratorio(iterBean.getIvaMoratorio());
									altaBean.setOtrasComisiones(iterBean.getOtrasComisiones());
									altaBean.setIvaComisiones(iterBean.getIvaComisiones());
									altaBean.setTranPagoCredito(iterBean.getTranPagoCredito());
									altaBean.setAmortizacionPago(iterBean.getAmortizacionPago());
									mensajeBean = altaNotaCargoPagoNoReconocido(altaBean);
									if(mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							}

							if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(Constantes.CODIGO_SIN_ERROR);
								mensajeBean.setDescripcion("Notas de Cargo de Pagos no Reconocidos dadas de alta exitosamente");
								mensajeBean.setNombreControl("creditoID");
							}
						} catch (Exception e) {
							if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
								mensajeBean.setNumero(999);
							}
							mensajeBean.setDescripcion(e.getMessage());
							transaction.setRollbackOnly();
							e.printStackTrace();
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en alta de la lista de notas de cargo", e);
						}
						return mensajeBean;
					}
				});
		return mensajeResultado;
	}

	public MensajeTransaccionBean altaNotaCargoPagoNoReconocido(final NotasCargoBean notasCargoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL REGISTRONOTASCARGOPRO (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(notasCargoBean.getCreditoID()));
									sentenciaStore.setInt("Par_AmortizacionID", Utileria.convierteEntero(notasCargoBean.getAmortizacionID()));
									sentenciaStore.setInt("Par_TipoNotaCargoID", Utileria.convierteEntero(notasCargoBean.getTipoNotaCargoID()));
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(notasCargoBean.getMonto()));
									sentenciaStore.setDouble("Par_IVA", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_Motivo", notasCargoBean.getMotivo());
									sentenciaStore.setDouble("Par_Capital", Utileria.convierteDoble(notasCargoBean.getCapital()));
									sentenciaStore.setDouble("Par_Interes", Utileria.convierteDoble(notasCargoBean.getInteresOrd()));
									sentenciaStore.setDouble("Par_IVAInteres", Utileria.convierteDoble(notasCargoBean.getIvaInteres()));
									sentenciaStore.setDouble("Par_Moratorio", Utileria.convierteDoble(notasCargoBean.getMoratorio()));

									sentenciaStore.setDouble("Par_IVAMoratorio", Utileria.convierteDoble(notasCargoBean.getIvaMoratorio()));
									sentenciaStore.setDouble("Par_OtrasComisiones", Utileria.convierteDoble(notasCargoBean.getOtrasComisiones()));
									sentenciaStore.setDouble("Par_IVAComisiones", Utileria.convierteDoble(notasCargoBean.getIvaComisiones()));
									sentenciaStore.setLong("Par_TranPagoCredito", Utileria.convierteLong(notasCargoBean.getTranPagoCredito()));
									sentenciaStore.setInt("Par_AmortizacionPago", Utileria.convierteEntero(notasCargoBean.getAmortizacionPago()));

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "NotasCargoDAO.altaNotaCargoPagoNoReconocido");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NotasCargoDAO.altaNotaCargoPagoNoReconocido");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " NotasCargoDAO.altaNotaCargoPagoNoReconocido");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al dar de alta la nota de cargo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean altaNotaCargoIndividual(final NotasCargoBean notasCargoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Stored Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "CALL REGISTRONOTASCARGOPRO (?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?,	?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setLong("Par_CreditoID", Utileria.convierteLong(notasCargoBean.getCreditoID()));
									sentenciaStore.setInt("Par_AmortizacionID", Utileria.convierteEntero(notasCargoBean.getAmortizacionID()));
									sentenciaStore.setInt("Par_TipoNotaCargoID", Utileria.convierteEntero(notasCargoBean.getTipoNotaCargoID()));
									sentenciaStore.setDouble("Par_Monto", Utileria.convierteDoble(notasCargoBean.getMonto()));
									sentenciaStore.setDouble("Par_IVA", Utileria.convierteDoble(notasCargoBean.getIva()));

									sentenciaStore.setString("Par_Motivo", notasCargoBean.getMotivo());
									sentenciaStore.setDouble("Par_Capital", Constantes.ENTERO_CERO);
									sentenciaStore.setDouble("Par_Interes", Constantes.ENTERO_CERO);
									sentenciaStore.setDouble("Par_IVAInteres", Constantes.ENTERO_CERO);
									sentenciaStore.setDouble("Par_Moratorio", Constantes.ENTERO_CERO);

									sentenciaStore.setDouble("Par_IVAMoratorio", Constantes.ENTERO_CERO);
									sentenciaStore.setDouble("Par_OtrasComisiones", Constantes.ENTERO_CERO);
									sentenciaStore.setDouble("Par_IVAComisiones", Constantes.ENTERO_CERO);
									sentenciaStore.setLong("Par_TranPagoCredito", Constantes.ENTERO_CERO);
									sentenciaStore.setInt("Par_AmortizacionPago", Constantes.ENTERO_CERO);

									sentenciaStore.setString("Par_Salida", Constantes.STRING_SI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID", "NotasCargoDAO.altaNotaCargoIndividual");
									sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + sentenciaStore.toString());
									return sentenciaStore;
								}
							}, new CallableStatementCallback<Object>() {
								public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
								DataAccessException {
									MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
									if (callableStatement.execute()) {
										ResultSet resultadosStore = callableStatement.getResultSet();

										resultadosStore.next();
										mensajeTransaccion.setNumero(resultadosStore.getInt("NumErr"));
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
										mensajeTransaccion.setConsecutivoInt(resultadosStore.getString("consecutivo"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
									} else {
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " NotasCargoDAO.altaNotaCargoIndividual");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoInt(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
									}
									return mensajeTransaccion;
								}
							}
							);
					if (mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " NotasCargoDAO.altaNotaCargoIndividual");
					} else if (mensajeBean.getNumero() != Constantes.CODIGO_SIN_ERROR) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+" Error al dar de alta la nota de cargo" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == Constantes.CODIGO_SIN_ERROR) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public List<?> listaGrid(int tipoLista, NotasCargoBean notasCargoBean) {
		List<?> lista= null;
		try {
			String query = "CALL NOTASCARGOLIS (?,?,?,?,?,	?,?,?,?);";
			Object[] parametros = {
					notasCargoBean.getCreditoID(),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NotasCargoDAO.listaGrid",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOTASCARGOLIS (" + Arrays.toString(parametros) +")");
			List<?> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NotasCargoBean resultado = new NotasCargoBean();
					resultado.setAmortizacionID(resultSet.getString("AmortizacionID"));
					resultado.setFechaExigible(resultSet.getString("FechaExigible"));
					resultado.setCapital(resultSet.getString("Capital"));
					resultado.setInteresOrd(resultSet.getString("InteresOrd"));
					resultado.setIvaInteres(resultSet.getString("IvaInteres"));
					resultado.setMoratorio(resultSet.getString("Moratorio"));
					resultado.setIvaMoratorio(resultSet.getString("IvaMoratorio"));
					resultado.setOtrasComisiones(resultSet.getString("OtrasComsiones"));
					resultado.setIvaComisiones(resultSet.getString("IvaComisiones"));
					resultado.setNotasCargo(resultSet.getString("NotasCargo"));
					resultado.setIvaNotasCargo(resultSet.getString("IvaNotasCargo"));
					resultado.setTotalPago(resultSet.getString("TotalPago"));
					resultado.setTranPagoCredito(resultSet.getString("Transaccion"));
					resultado.setTieneNotas(resultSet.getString("TieneNotas"));

					return resultado;
				}
			});
			lista = matches;
		} catch(Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en lista de notas de cargo", e);
		}
		return lista;
	}

	public NotasCargoBean consultaAmortizacion(NotasCargoBean notasCargoBean, int tipoConsulta) {
		NotasCargoBean registro = null;
		try {
			String query = "CALL NOTASCARGOCON (?,?,?,?,?,	?,?,?,?,?);";
			Object[] parametros = {
					notasCargoBean.getAmortizacionID(),
					notasCargoBean.getCreditoID(),

					tipoConsulta,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"NotasCargoDAO.consultaAmortizacion",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + " - " + "CALL NOTASCARGOCON (" + Arrays.toString(parametros) +")");
			List<?> matches = ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NotasCargoBean resultado = new NotasCargoBean();
					resultado.setAmortizacionID(resultSet.getString("AmortizacionID"));
					resultado.setEstatus(resultSet.getString("Estatus"));
					resultado.setNotaCargoID(resultSet.getString("NotaCargoID"));
					return resultado;
				}
			});
			registro = matches.size() > 0 ? (NotasCargoBean) matches.get(0) : null;
		} catch(Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + " - " + "Error en consulta de la amortizacion", e);
		}
		return registro;
	}

	public ParametrosSesionBean getParametrosSesionBean() {
		return parametrosSesionBean;
	}

	public void setParametrosSesionBean(ParametrosSesionBean parametrosSesionBean) {
		this.parametrosSesionBean = parametrosSesionBean;
	}
}