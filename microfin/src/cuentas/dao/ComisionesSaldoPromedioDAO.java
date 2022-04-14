package cuentas.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import contabilidad.bean.PolizaBean;
import contabilidad.dao.PolizaDAO;
import cuentas.bean.ComisionesSaldoPromedioBean;
import cuentas.servicio.ComisionesSaldoPromedioServicio.Enum_Tra_ComisionesPendientes;
import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class ComisionesSaldoPromedioDAO extends BaseDAO {
	PolizaDAO				polizaDAO				= null;

	public ComisionesSaldoPromedioDAO() {
		super();
	}

	// LISTA DE TIPOS DE CONDONACION
	public List listaComboTipoCondonacion(final int tipoLista, final ComisionesSaldoPromedioBean comisones){
		List lista = null;
		try{
			String query = "call TIPOSCONDONACIONLIS(?,?,?,?,?,		"+
													 "?,?,?,?)";
			Object[] parametros = {
				comisones.getDescripcion(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ComisionesSaldoPromedioDAO.listaComisiones",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSCONDONACIONLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ComisionesSaldoPromedioBean comisionesSaldoPromedio = new ComisionesSaldoPromedioBean();

					comisionesSaldoPromedio.setTipoCondonacionID(resultSet.getString("TipoCondonacionID"));
					comisionesSaldoPromedio.setDescripcion(resultSet.getString("Descripcion"));

					return comisionesSaldoPromedio;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista del catalogo de tipos de condonaciones  ComisionesSaldoPromedioDAO.listaComboTipoCondonacion", e);
		}
		return lista;

	}


	// LISTA LOS TIPOS DE REVERSAS
	public List listaComboTipoReversa(final int tipoLista, final ComisionesSaldoPromedioBean comisones){
		List lista = null;
		try{
			String query = "call TIPOSREVERSALIS(?,?,?,?,?,		"+
												"?,?,?,?)";
			Object[] parametros = {
				comisones.getDescripcion(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ComisionesSaldoPromedioDAO.listaComisiones",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOSREVERSALIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ComisionesSaldoPromedioBean comisionesSaldoPromedio = new ComisionesSaldoPromedioBean();

					comisionesSaldoPromedio.setTipoReversaID(resultSet.getString("TipoReversaID"));
					comisionesSaldoPromedio.setDescripcion(resultSet.getString("Descripcion"));

					return comisionesSaldoPromedio;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista del catalogo de tipos de reversa  ComisionesSaldoPromedioDAO.listaComboTipoReversa", e);
		}
		return lista;

	}


	// LISTA DE COMISIONES PENDIENTES DE COBRO
	public List listaComisionesPendientes(final int tipoLista, final ComisionesSaldoPromedioBean comisones){
		List lista = null;
		try{
			String query = "call COMSALDOPROMEDIOLIS(?,?,?,?,?,		"+
													"?,?,?,?,?)";
			Object[] parametros = {
				Utileria.convierteEntero(comisones.getClienteID()),
				Utileria.convierteLong(comisones.getCuentaAhoID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ComisionesSaldoPromedioDAO.listaComisiones",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMSALDOPROMEDIOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ComisionesSaldoPromedioBean comisionesSaldoPromedio = new ComisionesSaldoPromedioBean();

					comisionesSaldoPromedio.setComisionID(resultSet.getString("ComisionID"));
					comisionesSaldoPromedio.setFechaCorte(resultSet.getString("FechaCorte"));
					comisionesSaldoPromedio.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					comisionesSaldoPromedio.setComSaldoPromOri(resultSet.getString("ComSaldoPromOri"));
					comisionesSaldoPromedio.setIVAComSalPromOri(resultSet.getString("IVAComSalPromOri"));
					comisionesSaldoPromedio.setComSaldoPromAct(resultSet.getString("ComSaldoPromAct"));

					comisionesSaldoPromedio.setIVAComSalPromAct(resultSet.getString("IVAComSalPromAct"));
					comisionesSaldoPromedio.setComSaldoPromCob(resultSet.getString("ComSaldoPromCob"));
					comisionesSaldoPromedio.setIVAComSalPromCob(resultSet.getString("IVAComSalPromCob"));
					comisionesSaldoPromedio.setComSaldoPromCond(resultSet.getString("ComSaldoPromCond"));
					comisionesSaldoPromedio.setIVAComSalPromCond(resultSet.getString("IVAComSalPromCond"));

					comisionesSaldoPromedio.setEstatus(resultSet.getString("Estatus"));
					comisionesSaldoPromedio.setOrigenComision(resultSet.getString("OrigenComision"));
					comisionesSaldoPromedio.setClienteID(resultSet.getString("ClienteID"));
					comisionesSaldoPromedio.setDesEstatus(resultSet.getString("DesEstatus"));
					comisionesSaldoPromedio.setTipoComision(resultSet.getString("TipoComision"));
					comisionesSaldoPromedio.setTotalSaldoCom(resultSet.getString("TotalSaldoCom"));
					comisionesSaldoPromedio.setDescripcion(resultSet.getString("Descripcion"));

					return comisionesSaldoPromedio;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de comisiones de saldo promedio ", e);
		}
		return lista;

	}


	// LISTA DE COMISIONES PAGADAS
	public List listaComisionesCobradas(final int tipoLista, final ComisionesSaldoPromedioBean comisones){
		List lista = null;
		try{
			String query = "call COMSALDOPROMEDIOLIS(?,?,?,?,?,		"+
													"?,?,?,?,?)";
			Object[] parametros = {
				Utileria.convierteEntero(comisones.getClienteID()),
				Utileria.convierteLong(comisones.getCuentaAhoID()),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"ComisionesSaldoPromedioDAO.listaComisiones",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMSALDOPROMEDIOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					ComisionesSaldoPromedioBean comisionesSaldoPromedio = new ComisionesSaldoPromedioBean();

					comisionesSaldoPromedio.setCobroID(resultSet.getString("CobroID"));
					comisionesSaldoPromedio.setComisionID(resultSet.getString("ComisionID"));
					comisionesSaldoPromedio.setCuentaAhoID(resultSet.getString("CuentaAhoID"));
					comisionesSaldoPromedio.setSaldoDispon(resultSet.getString("SaldoDispon"));
					comisionesSaldoPromedio.setFechaCobro(resultSet.getString("FechaCobro"));

					comisionesSaldoPromedio.setComSaldoPromPend(resultSet.getString("ComSaldoPromPend"));
					comisionesSaldoPromedio.setIVAComSalPromPend(resultSet.getString("IVAComSalPromPend"));
					comisionesSaldoPromedio.setComSaldoPromCob(resultSet.getString("ComSaldoPromCob"));
					comisionesSaldoPromedio.setIVAComSalPromCob(resultSet.getString("IVAComSalPromCob"));
					comisionesSaldoPromedio.setTotalCobrado(resultSet.getString("TotalCobrado"));

					comisionesSaldoPromedio.setOrigenCobro(resultSet.getString("OrigenCobro"));
					comisionesSaldoPromedio.setClienteID(resultSet.getString("ClienteID"));
					comisionesSaldoPromedio.setDesOrigen(resultSet.getString("DesOrigen"));
					comisionesSaldoPromedio.setTipoComision(resultSet.getString("TipoComision"));
					comisionesSaldoPromedio.setDescripcion(resultSet.getString("Descripcion"));

					return comisionesSaldoPromedio;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de comisiones de saldo promedio ", e);
		}
		return lista;

	}

	// CONSULTA DE COMISIONES PENDIENTES DE PAGO
	public ComisionesSaldoPromedioBean consultaComisionPendPago(ComisionesSaldoPromedioBean comisones, int tipoConsulta){
		String query = "call COMISIONESSALPROAHOCON(?,?,?,?,?,	"+
													"?,?,?,?,?	);";
		Object[] parametros = {
				Utileria.convierteEntero(comisones.getClienteID()),
				Utileria.convierteLong(comisones.getCuentaAhoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ComicionesPendientesCobDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMISIONESSALPROAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ComisionesSaldoPromedioBean comisionesPendienres = new ComisionesSaldoPromedioBean();
				comisionesPendienres.setComisionID(resultSet.getString("ComisionID"));
				comisionesPendienres.setClienteID(resultSet.getString("ClienteID"));
				comisionesPendienres.setCuentaAhoID(resultSet.getString("CuentaAhoID"));

				return comisionesPendienres;
			}
		});
		return matches.size() > 0 ? (ComisionesSaldoPromedioBean) matches.get(0) : null;
	}


	// CONSULTA DE COMISIONES PAGADAS
	public ComisionesSaldoPromedioBean consultaComisionPagada(ComisionesSaldoPromedioBean comisones, int tipoConsulta){
		String query = "call COMISIONESSALPROAHOCON(?,?,?,?,?,	"+
													"?,?,?,?,?	);";
		Object[] parametros = {
				Utileria.convierteEntero(comisones.getClienteID()),
				Utileria.convierteLong(comisones.getCuentaAhoID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"ComicionesPendientesCobDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
				};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call COMISIONESSALPROAHOCON(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				ComisionesSaldoPromedioBean comisionesPendienres = new ComisionesSaldoPromedioBean();
				comisionesPendienres.setCobroID(resultSet.getString("CobroID"));
				comisionesPendienres.setComisionID(resultSet.getString("ComisionID"));
				comisionesPendienres.setClienteID(resultSet.getString("ClienteID"));
				comisionesPendienres.setCuentaAhoID(resultSet.getString("CuentaAhoID"));

				return comisionesPendienres;
			}
		});
		return matches.size() > 0 ? (ComisionesSaldoPromedioBean) matches.get(0) : null;
	}

	public MensajeTransaccionBean condonaComSaldoPromedio(final ComisionesSaldoPromedioBean comisiones, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call COMSALDOPROMCONDONAPRO(?,?,?,?,?,		"+
																			"?,?,?,?,?,		"+
																			"?,?,?,?,?,		"+
																			"?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_ComisionID",Utileria.convierteEntero(comisiones.getComisionID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(comisiones.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(comisiones.getCuentaAhoID()));
								sentenciaStore.setDouble("Par_SaldoComPendiente",Utileria.convierteDoble(comisiones.getSaldoComPendiente()));
								sentenciaStore.setDouble("Par_IVAComision",Utileria.convierteDoble(comisiones.getIVAComisionPendiente()));

								sentenciaStore.setInt("Par_TipoCondonacion",Utileria.convierteEntero(comisiones.getTipoCondonacion()));
								sentenciaStore.setString("Par_MotivoProceso",comisiones.getMotivoProceso());
								sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(comisiones.getUsuarioAutoriza()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "CargosDAO.alta");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento COMSALDOPROMCONDONAPRO no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento COMSALDOPROMCONDONAPRO no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en COMSALDOPROMCONDONAPRO", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
					return mensajeBean;
				}
			});
			return mensaje;
		}


	public MensajeTransaccionBean reversaComisionSaldoProm(final ComisionesSaldoPromedioBean comisiones, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			@SuppressWarnings("unchecked")
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call COMSALDOPROMREVPRO(?,?,?,?,?,		"+
																	   "?,?,?,?,?,		"+
																	   "?,?,?,?,?,		"+
																	   "?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_CobroID",Utileria.convierteEntero(comisiones.getCobroID()));
								sentenciaStore.setInt("Par_ComisionID",Utileria.convierteEntero(comisiones.getComisionID()));
								sentenciaStore.setInt("Par_ClienteID",Utileria.convierteEntero(comisiones.getClienteID()));
								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(comisiones.getCuentaAhoID()));
								sentenciaStore.setDouble("Par_SaldoComCobrado",Utileria.convierteDoble(comisiones.getSaldoComPendiente()));

								sentenciaStore.setDouble("Par_IVAComCobrada",Utileria.convierteDoble(comisiones.getIVAComisionPendiente()));
								sentenciaStore.setInt("Par_TipoReversa",Utileria.convierteEntero(comisiones.getTipoReversa()));
								sentenciaStore.setString("Par_MotivoProceso",comisiones.getMotivoProceso());
								sentenciaStore.setInt("Par_UsuarioAutoriza",Utileria.convierteEntero(comisiones.getUsuarioAutoriza()));
								sentenciaStore.setInt("Par_PolizaID", Utileria.convierteEntero(comisiones.getPolizaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);
								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());

								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "CargosDAO.alta");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento COMSALDOPROMREVPRO no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento COMSALDOPROMREVPRO no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {

					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en COMSALDOPROMREVPRO", e);
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
				}
					return mensajeBean;
				}
			});
			return mensaje;
		}

	// CONDONACION DE SALDO PROMEDIO PENDIENTE DE PAGO
	public MensajeTransaccionBean procesaInfCondoncaionSaldoProm(final ComisionesSaldoPromedioBean comisiones, final List listaComiciones, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					ComisionesSaldoPromedioBean bean;

					if(listaComiciones.size()==0){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No existe información a procesar");
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en al procesar la informacion, lista vacia.");
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaComiciones.size(); i++){
						bean = (ComisionesSaldoPromedioBean)listaComiciones.get(i);
						mensajeBean = condonaComSaldoPromedio(bean, tipoActualizacion);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en procesar la informacion ComisionesSaldoPromedioDAO.procesaInfCondoncaionSaldoProm", e);
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}


	// REVERSA DE SALDO PROMEDIO
	public MensajeTransaccionBean procesaInfReversaSaldoProm(final ComisionesSaldoPromedioBean comisiones, final List listaComiciones, final int tipoActualizacion) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		final PolizaBean polizaBean=new PolizaBean();
		polizaBean.setConceptoID(comisiones.reversaCoision);
		polizaBean.setConcepto(comisiones.desRevComision);

		int	contador  = 0;
		while(contador <= PolizaBean.numIntentosGeneraPoliza){
			contador ++;
			polizaDAO.generaPolizaIDGenerico(polizaBean,parametrosAuditoriaBean.getNumeroTransaccion());
			if (Utileria.convierteEntero(polizaBean.getPolizaID()) > 0){
				break;
			}
		}
		if (Utileria.convierteEntero(polizaBean.getPolizaID()) >0){
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				String poliza = polizaBean.getPolizaID();
				try {
					ComisionesSaldoPromedioBean bean;
					comisiones.setPolizaID(poliza);
					if(listaComiciones.size()==0){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						mensajeBean.setDescripcion("No existe información a procesar");
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en al procesar la informacion, lista vacia.");
						throw new Exception(mensajeBean.getDescripcion());
					}

					for(int i=0; i<listaComiciones.size(); i++){
						bean = (ComisionesSaldoPromedioBean)listaComiciones.get(i);
						bean.setPolizaID(poliza);
						loggerSAFI.info("BEAN :\n"+Utileria.logJsonFormat(bean));
						mensajeBean = reversaComisionSaldoProm(bean, tipoActualizacion);
						if(mensajeBean.getNumero()!=0){
							throw new Exception(mensajeBean.getDescripcion());
						}
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero()==0){
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
					transaction.setRollbackOnly();
					e.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en procesar la informacion ComisionesSaldoPromedioDAO.procesaInfReversaSaldoProm", e);
				}
				return mensajeBean;
			}

		});
		/* Baja de Poliza en caso de que haya ocurrido un error */
		if (mensaje.getNumero() != 0) {
			try {
				PolizaBean bajaPolizaBean = new PolizaBean();
				bajaPolizaBean.setTipo(PolizaDAO.Enum_TipoBajaPoliza.bajaPolizaId);
				bajaPolizaBean.setNumTransaccion(String.valueOf(Constantes.ENTERO_CERO));
				bajaPolizaBean.setNumErrPol(mensaje.getNumero() + "");
				bajaPolizaBean.setErrMenPol(mensaje.getDescripcion());
				bajaPolizaBean.setDescProceso("ComisionesSaldoPromedioDAO");
				bajaPolizaBean.setPolizaID(comisiones.getPolizaID());
				MensajeTransaccionBean mensajeBaja = new MensajeTransaccionBean();
				mensajeBaja = polizaDAO.bajaPoliza(bajaPolizaBean);
				loggerSAFI.error("ComisionesSaldoPromedioDAO.procesaInfReversaSaldoProm:  Numero Error:" + mensajeBaja.getNumero() + " Mensaje: " + mensajeBaja.getDescripcion());
			} catch (Exception ex) {
				ex.printStackTrace();
			}
		}
		/* Fin Baja de la Poliza Contable*/
	}else{
		mensaje.setNumero(999);
		mensaje.setDescripcion("El Número de Póliza se encuentra Vacio");
		mensaje.setNombreControl("numeroTransaccion");
		mensaje.setConsecutivoString("0");
	}
	return mensaje;
	}

	/**
	 * Método para realizar el cobro de Comision por Saldo promedio al realizar Abono a la Cuenta
	 * @param comisiones : Bean ComisionesSaldoPromedioBean con la Información de la Comision
	 * @param numTransaccion : Número de Transaccion
	 * @param origenVentanilla :  Especifica si se imprime en el log de Ventanilla.log (Solo Operaciones de Ventanilla) o en el SAFI.log
	 * @return MensajeTransaccionBean
	 */
	public MensajeTransaccionBean cobraComSaldoPromedio(final ComisionesSaldoPromedioBean comisiones, final long numTransaccion, final boolean origenVentanilla) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();

		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "call COMSALDOPROMCOBPENDPRO(?,?,?,?,?,		"+
																			"?,?,?,?,?,		"+
																			"?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setLong("Par_CuentaAhoID",Utileria.convierteLong(comisiones.getCuentaAhoID()));
								sentenciaStore.setDouble("Par_MontoMov",Utileria.convierteDoble(comisiones.getMontoMovPago()));
								sentenciaStore.registerOutParameter("Par_MontoAplicado", Types.DECIMAL);
								sentenciaStore.setLong("Par_Poliza", Utileria.convierteLong(comisiones.getPolizaID()));

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen",Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID", "ComisionesSaldoPromedioDAO.cobro");
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",numTransaccion);

								if (origenVentanilla) {
									loggerVent.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								} else {
									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos() + "-" + sentenciaStore.toString());
								}

								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
									mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
									mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
									mensajeTransaccion.setCampoGenerico(resultadosStore.getString("CampoGenerico"));

								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR +  "Fallo. El Procedimiento COMSALDOPROMCOBPENDPRO.");
									mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
									mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
								}
								return mensajeTransaccion;
							}
						});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + "Fallo. El Procedimiento COMSALDOPROMCOBPENDPRO.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				}catch (Exception e) {
					if (origenVentanilla) {
						loggerVent.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en cobraComSaldoPromedio" + e);
					} else {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos() + "-" + "Error en cobraComSaldoPromedio" + e);
					}
					e.printStackTrace();

					if (mensajeBean.getNumero() == 0) {
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

	public PolizaDAO getPolizaDAO() {
		return polizaDAO;
	}

	public void setPolizaDAO(PolizaDAO polizaDAO) {
		this.polizaDAO = polizaDAO;
	}



}
