package contabilidad.dao;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.CuentasContablesBean;
import credito.beanWS.request.ConsultaDetallePagosRequest;
import credito.beanWS.response.ConsultaDetallePagosResponse;

import javax.sql.DataSource;

public class CuentasContablesDAO extends BaseDAO{
	public CuentasContablesDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final CuentasContablesBean cuentasContablesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL CUENTASCONTABLESALT(?,?,?,?,?," +
																	  	"?,?,?,?,?," +
																		"?,?," +
																		"?,?,?," +
																		"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_CuentaCompleta", cuentasContablesBean.getCuentaCompleta());
								sentenciaStore.setString("Par_CuentaMayor", cuentasContablesBean.getCuentaMayor());
								sentenciaStore.setString("Par_Descripcion", cuentasContablesBean.getDescripcion());
								sentenciaStore.setString("Par_DescriCorta", cuentasContablesBean.getDescriCorta());
								sentenciaStore.setString("Par_Naturaleza", cuentasContablesBean.getNaturaleza());

								sentenciaStore.setString("Par_Grupo", cuentasContablesBean.getGrupo());
								sentenciaStore.setString("Par_TipoCuenta", cuentasContablesBean.getTipoCuenta());
								sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(cuentasContablesBean.getMonedaID()));
								sentenciaStore.setString("Par_Restringida", cuentasContablesBean.getRestringida());
								sentenciaStore.setString("Par_CodigoAgrupador", cuentasContablesBean.getCodigoAgrupador());

								sentenciaStore.setInt("Par_Nivel", Utileria.convierteEntero(cuentasContablesBean.getNivel()));
								sentenciaStore.setDate("Par_FechaCreacionCta", OperacionesFechas.conversionStrDate(cuentasContablesBean.getFechaCreacionCta()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "CuentasContablesDAO.alta");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentasContablesDAO.alta");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CuentasContablesDAO.alta");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en alta de cuenta contables: " + exception);
					exception.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean modifica(final CuentasContablesBean cuentasContablesBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL CUENTASCONTABLESMOD(?,?,?,?,?," +
																	  	"?,?,?,?,?," +
																		"?,?," +
																		"?,?,?," +
																		"?,?,?,?,?,?,?);";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_CuentaCompleta", cuentasContablesBean.getCuentaCompleta());
								sentenciaStore.setString("Par_CuentaMayor", cuentasContablesBean.getCuentaMayor());
								sentenciaStore.setString("Par_Descripcion", cuentasContablesBean.getDescripcion());
								sentenciaStore.setString("Par_DescriCorta", cuentasContablesBean.getDescriCorta());
								sentenciaStore.setString("Par_Naturaleza", cuentasContablesBean.getNaturaleza());

								sentenciaStore.setString("Par_Grupo", cuentasContablesBean.getGrupo());
								sentenciaStore.setString("Par_TipoCuenta", cuentasContablesBean.getTipoCuenta());
								sentenciaStore.setInt("Par_MonedaID", Utileria.convierteEntero(cuentasContablesBean.getMonedaID()));
								sentenciaStore.setString("Par_Restringida", cuentasContablesBean.getRestringida());
								sentenciaStore.setString("Par_CodigoAgrupador", cuentasContablesBean.getCodigoAgrupador());

								sentenciaStore.setInt("Par_Nivel", Utileria.convierteEntero(cuentasContablesBean.getNivel()));
								sentenciaStore.setDate("Par_FechaCreacionCta", OperacionesFechas.conversionStrDate(cuentasContablesBean.getFechaCreacionCta()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP", parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "CuentasContablesDAO.modifica");
								sentenciaStore.setInt("Aud_Sucursal", parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+ sentenciaStore.toString());
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
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .CuentasContablesDAO.modifica");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								}

								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .CuentasContablesDAO.modifica");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en modificación de cuentas contables: " + exception);
					exception.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(exception.getMessage());
					transaction.setRollbackOnly();
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public MensajeTransaccionBean baja(final CuentasContablesBean cuentasContables){
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					String query = "call CUENTASCONTABLESBAJ(?, ?,?,?,?,?,?,?);";
					Object[] parametros = {
							cuentasContables.getCuentaCompleta(),

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"CuentasContablesDAO.baja",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()};
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESBAJ(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
						public Object mapRow(ResultSet resultSet, int rowNum)
								throws SQLException {
							MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
							mensaje.setNumero(Integer.valueOf(resultSet.getString(1)).intValue());
							mensaje.setDescripcion(resultSet.getString(2));
							mensaje.setNombreControl(resultSet.getString(3));
							return mensaje;
						}
					});
					return matches.size() > 0 ? (MensajeTransaccionBean) matches.get(0) : null;
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en baja de cuentas contables", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public CuentasContablesBean consultaPrincipal(CuentasContablesBean cuentasContables, int tipoConsulta){
		CuentasContablesBean cuentasContablesCon = new CuentasContablesBean();
		try{

			String query = "call CUENTASCONTABLESCON(?,? ,?,?,?,?,?,?,?,?);";
			Object[] parametros = {
					cuentasContables.getCuentaCompleta(),
					tipoConsulta,
					Constantes.STRING_VACIO,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"CuentasContablesDAO.consultaPrincipal",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO };
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasContablesBean cuentasContables = new CuentasContablesBean();
					cuentasContables.setCuentaCompleta(resultSet.getString(1));
					cuentasContables.setCuentaMayor(resultSet.getString(2));
					cuentasContables.setDescripcion(resultSet.getString(3));
					cuentasContables.setDescriCorta(resultSet.getString(4));
					cuentasContables.setNaturaleza(resultSet.getString(5));
					cuentasContables.setGrupo(resultSet.getString(6));
					cuentasContables.setTipoCuenta(resultSet.getString(7));
					cuentasContables.setMonedaID(resultSet.getString(8));
					cuentasContables.setRestringida(resultSet.getString(9));
					cuentasContables.setCodigoAgrupador(resultSet.getString("CodigoAgrupador"));
					cuentasContables.setNivel(resultSet.getString("Nivel"));
					cuentasContables.setFechaCreacionCta(resultSet.getString("FechaCreacionCta"));


					return cuentasContables;
				}
			});
			cuentasContablesCon= matches.size() > 0 ? (CuentasContablesBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de cuentas contables", e);
		}
		return cuentasContablesCon;
	}

	public CuentasContablesBean consultaForanea(CuentasContablesBean cuentasContables, int tipoConsulta){
		String query = "call CUENTASCONTABLESCON(?,? ,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				cuentasContables.getCuentaCompleta(),
				tipoConsulta,
				Constantes.STRING_VACIO,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasContablesDAO.consultaForanea",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContables = new CuentasContablesBean();
				cuentasContables.setCuentaCompleta(resultSet.getString(1));
				cuentasContables.setDescripcion(resultSet.getString(2));
				cuentasContables.setGrupo(resultSet.getString(3));
				return cuentasContables;
			}
		});
		return matches.size() > 0 ? (CuentasContablesBean) matches.get(0) : null;
	}

	public CuentasContablesBean consultaNumCtas(CuentasContablesBean cuentasContables, int tipoConsulta){
		String query = "call CUENTASCONTABLESCON(?,? ,?,?,?,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				tipoConsulta,
				cuentasContables.getFechaCreacionCta(),

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"CuentasContablesDAO.consultaNumCtas",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESCON(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContables = new CuentasContablesBean();
				cuentasContables.setNumCtas(resultSet.getString(1));
				cuentasContables.setRfc(resultSet.getString(2));
				return cuentasContables;
			}
		});
		return matches.size() > 0 ? (CuentasContablesBean) matches.get(0) : null;
	}


	public List consultaDetallePagosWS(ConsultaDetallePagosRequest detallePagos, int tipoConsulta){
		final ConsultaDetallePagosResponse mensajeBean = new ConsultaDetallePagosResponse();
		String query = "call AMORTICREDITOWSCON(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(detallePagos.getClienteID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"AmortizacionCreditoDAO.consultaDetallePagosWS",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call AMORTICREDITOWSCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ConsultaDetallePagosResponse consultaDetalle = new ConsultaDetallePagosResponse();
				consultaDetalle.setInfoDetallePagos(resultSet.getString(1)
						+"&;&"+resultSet.getString(2)+"&;&"+resultSet.getString(3)+"&;&"+resultSet.getString(4));
				consultaDetalle.setCodigoRespuesta(resultSet.getString(5));
				consultaDetalle.setMensajeRespuesta(resultSet.getString(6));

					return consultaDetalle;
				}


		});
		return matches;

	}






	public List listaPrincipal(CuentasContablesBean cuentasContablesBean, int tipoLista){
		String query = "call CUENTASCONTABLESLIS(?,?,?,?,?  ,?,?,?,?,?);";
		Object[] parametros = {
				cuentasContablesBean.getDescripcion(),
				tipoLista,
				Constantes.FECHA_VACIA,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();
				cuentasContablesBean.setCuentaCompleta(resultSet.getString(1));
				cuentasContablesBean.setCuentaMayor(resultSet.getString(2));
				cuentasContablesBean.setDescripcion(resultSet.getString(3));
				return cuentasContablesBean;

			}
		});
		return matches;
	}

	public List listaEncabezado(CuentasContablesBean cuentasContablesBean, int tipoLista){
		String query = "call CUENTASCONTABLESLIS(?,?,?,?,?   ,?,?,?,?,?);";
		Object[] parametros = {
				cuentasContablesBean.getDescripcion(),
				tipoLista,
				Constantes.FECHA_VACIA,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();
				cuentasContablesBean.setCuentaCompleta(resultSet.getString(1));
				cuentasContablesBean.setCuentaMayor(resultSet.getString(2));
				cuentasContablesBean.setDescripcion(resultSet.getString(3));
				return cuentasContablesBean;

			}
		});
		return matches;
	}

	public List listaDetalle(CuentasContablesBean cuentasContablesBean, int tipoLista){
		String query = "call CUENTASCONTABLESLIS(?,?,?,?,?  ,?,?,?,?,?);";
		Object[] parametros = {
				cuentasContablesBean.getDescripcion(),
				tipoLista,
				Constantes.FECHA_VACIA,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();
				cuentasContablesBean.setCuentaCompleta(resultSet.getString(1));
				cuentasContablesBean.setCuentaMayor(resultSet.getString(2));
				cuentasContablesBean.setDescripcion(resultSet.getString(3));
				return cuentasContablesBean;

			}
		});
		return matches;
	}

	public List listaXml( CuentasContablesBean cuentasContablesBean,int tipoLista){
		String query = "call CUENTASCONTABLESLIS(?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = {
				Constantes.STRING_VACIO,
				tipoLista,
				cuentasContablesBean.getFechaCreacionCta(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.listaPrincipal",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESLIS(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();
				cuentasContablesBean.setCodigoAgrupador(resultSet.getString(1));
				cuentasContablesBean.setCuentaCompleta(resultSet.getString(2));
				cuentasContablesBean.setDescripcion(resultSet.getString(3));
				cuentasContablesBean.setNivel(resultSet.getString(4));
				cuentasContablesBean.setNaturaleza(resultSet.getString(5));
				return cuentasContablesBean;

			}
		});
		return matches;
	}

	public List listaRegulatorio( CuentasContablesBean cuentasContablesBean,int tipoLista){
		List listaCuentasContables = null ;
		try{
			String query = "call CUENTASCONTABLESLIS(?,?,?,?,? ,?,?,?,?,?);";
			Object[] parametros = {
					cuentasContablesBean.getDescripcion(),
					tipoLista,
					Constantes.FECHA_VACIA,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"CuentasContablesDAO.listaPrincipal",
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();
					cuentasContablesBean.setCuentaCompleta(resultSet.getString("CuentaCompleta"));
					cuentasContablesBean.setDescripcion(resultSet.getString("Descripcion"));
					return cuentasContablesBean;

				}
			});
			listaCuentasContables = matches;
		}catch (Exception e) {
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en la lista Cuentas Contables Regulatorio " + e);
			e.printStackTrace();
	    }
	    return listaCuentasContables;
	}


	public List <CuentasContablesBean> consultaMaestroContableRep(
			CuentasContablesBean cuentasContables) {

		String query = "call CUENTASCONTABLESREP(?,?,?,?,? ,?,?,?,?);";
		Object[] parametros = {
				cuentasContables.getTipoCuenta(),
				cuentasContables.getMonedaID(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.consultaMaestroContableRep",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call CUENTASCONTABLESREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();

				cuentasContablesBean.setCuentaCompleta(resultSet.getString(1));
				cuentasContablesBean.setDescripcion(resultSet.getString(2));
				cuentasContablesBean.setTipoCuenta(resultSet.getString(5));
				cuentasContablesBean.setDescriCorta(resultSet.getString(6));
				cuentasContablesBean.setRestringida(resultSet.getString(7));

				return cuentasContablesBean;

			}
		});
		return matches;
	}


	public List <CuentasContablesBean> consultaPeriodosRep(
			CuentasContablesBean cuentasContables) {

		String query = "call TIMBRADOPERIDOSREP(?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cuentasContables.getPeriodo()),
				cuentasContables.getProductoCreditoID(),
				cuentasContables.getClienteID(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.consultaPeriodosRep",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIMBRADOPERIDOSREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();

				cuentasContablesBean.setPeriodo(resultSet.getString("Periodo"));
				cuentasContablesBean.setClienteID(resultSet.getString("ClienteID"));
				cuentasContablesBean.setNombreCliente(resultSet.getString("NombreCliente"));
				cuentasContablesBean.setUUID(resultSet.getString("UUID"));
				cuentasContablesBean.setRFCEmisor(resultSet.getString("RFCEmisor"));
				cuentasContablesBean.setRFCReceptor(resultSet.getString("RFCReceptor"));
				cuentasContablesBean.setTotalTimbrado(resultSet.getString("CFDITotal"));
				cuentasContablesBean.setProducto(resultSet.getString("Producto"));

				return cuentasContablesBean;

			}
		});
		return matches;
	}

	public List <CuentasContablesBean> consultaEstadosCuentaRep(
			CuentasContablesBean cuentasContables) {

		String query = "call EDOCTASTATUSTIMREP(?,?,?,?,? ,?,?,?,?,?);";
		Object[] parametros = {
				Utileria.convierteEntero(cuentasContables.getPeriodo()),
				cuentasContables.getClienteID(),
				cuentasContables.getEstatus(),

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"CuentasContablesDAO.consultaEstadosCuentaRep",
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call EDOCTASTATUSTIMREP(" + Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				CuentasContablesBean cuentasContablesBean = new CuentasContablesBean();

				cuentasContablesBean.setPeriodo(resultSet.getString("Periodo"));
				cuentasContablesBean.setClienteID(resultSet.getString("ClienteID"));
				cuentasContablesBean.setNombreCliente(resultSet.getString("NombreCliente"));
				cuentasContablesBean.setEstatus(resultSet.getString("Estatus"));

				return cuentasContablesBean;

			}
		});
		return matches;
	}

}
