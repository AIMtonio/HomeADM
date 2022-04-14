package seguimiento.dao;

import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;


import fondeador.bean.InstitutFondeoBean;
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

import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;

import seguimiento.bean.SegtoManualBean;
import seguimiento.bean.TiposGestoresBean;

public class SegtoManualDAO extends BaseDAO{
	public SegtoManualDAO(){
		super();
	}
	//-----alta de Instituciones de Fondeo
		public MensajeTransaccionBean alta(final SegtoManualBean segtoManualBean) {
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
									String query = "call SEGTOPROGRAMADOALT(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(segtoManualBean.getCreditoID()));
									sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(segtoManualBean.getGrupoID()));
									sentenciaStore.setString("Par_FechaProgramada",Utileria.convierteFecha(segtoManualBean.getFechaProgramada()));
									sentenciaStore.setString("Par_HoraProgramada",segtoManualBean.getHoraProgramada());
									sentenciaStore.setInt("Par_CategoriaID",Utileria.convierteEntero(segtoManualBean.getCategoriaID()));
									sentenciaStore.setInt("Par_PuestoResponsableID",Utileria.convierteEntero(segtoManualBean.getPuestoResponsableID()));
									sentenciaStore.setInt("Par_PuestoSupervisorID",Utileria.convierteEntero(segtoManualBean.getPuestoSupervisorID()));
									sentenciaStore.setString("Par_TipoGeneracion",segtoManualBean.getTipoGeneracion());
									sentenciaStore.setInt("Par_SecSegtoForzado",Utileria.convierteEntero(segtoManualBean.getSecSegtoForzado()));
									sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(segtoManualBean.getFechaRegistro()));
									sentenciaStore.setString("Par_Estatus",segtoManualBean.getEstatus());
									sentenciaStore.setString("Par_EsForzado",segtoManualBean.getEsForzado());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de seguimiento manual", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}



		/* Modificacion de Instituciones de Fondeo  */
		public MensajeTransaccionBean modifica(final SegtoManualBean segtoManualBean) {
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
									String query = "call SEGTOPROGRAMADOMOD(" +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?,?,?, ?,?,?,?,?," +
											"?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(segtoManualBean.getSegtoPrograID()));
									sentenciaStore.setLong("Par_CreditoID",Utileria.convierteLong(segtoManualBean.getCreditoID()));
									sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(segtoManualBean.getGrupoID()));
									sentenciaStore.setString("Par_FechaProgramada",Utileria.convierteFecha(segtoManualBean.getFechaProgramada()));
									sentenciaStore.setString("Par_HoraProgramada",segtoManualBean.getHoraProgramada());
									sentenciaStore.setInt("Par_CategoriaID",Utileria.convierteEntero(segtoManualBean.getCategoriaID()));
									sentenciaStore.setInt("Par_PuestoResponsableID",Utileria.convierteEntero(segtoManualBean.getPuestoResponsableID()));
									sentenciaStore.setInt("Par_PuestoSupervisorID",Utileria.convierteEntero(segtoManualBean.getPuestoSupervisorID()));
									sentenciaStore.setString("Par_TipoGeneracion",segtoManualBean.getTipoGeneracion());
									sentenciaStore.setInt("Par_SecSegtoForzado",Utileria.convierteEntero(segtoManualBean.getSecSegtoForzado()));
									sentenciaStore.setString("Par_FechaRegistro",Utileria.convierteFecha(segtoManualBean.getFechaRegistro()));
									sentenciaStore.setString("Par_Estatus",segtoManualBean.getEstatus());
									sentenciaStore.setString("Par_EsForzado",segtoManualBean.getEsForzado());

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);

									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de seguimiento manual", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}
		// Eliminar seguimiento
		public MensajeTransaccionBean elimina(final SegtoManualBean segtoManualBean, final int  tipoBaja) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {

						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
									String query = "call SEGTOPROGRAMADOBAJ(?,?,?,?,?, ?,?,?,?,?,?,?);";
									CallableStatement sentenciaStore = arg0.prepareCall(query);
									sentenciaStore.setInt("Par_SegtoPrograID",Utileria.convierteEntero(segtoManualBean.getSegtoPrograID()));
									sentenciaStore.setInt("Par_TipoBaja",tipoBaja);

									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion("Fallo el Proceso, no Regreso Ningún Resultado.");
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception("Fallo el Proceso, no Regreso Ningún Resultado.");
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
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"No se Pudo Eliminar el Seguimiento Programado", e);
					}
					return mensajeBean;
				}
			});
			return mensaje;
		}

		public SegtoManualBean consultaPrincipal(SegtoManualBean segtoManualBean,int tipoConsulta) {
			SegtoManualBean segtoManualConsulta = new SegtoManualBean();
			try{
				// Query con el Store Procedure
				String query = "call SEGTOPROGRAMADOCON(   ?,?,?,?,?,"
														+ "?,?,?,?,?,?,?);";

				Object[] parametros = {
						                segtoManualBean.getSegtoPrograID(),
						                segtoManualBean.getCreditoID(),
						                segtoManualBean.getGrupoID(),
										segtoManualBean.getPuestoResponsableID(),
										tipoConsulta,

										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO,
										Constantes.FECHA_VACIA,
										Constantes.STRING_VACIO,
										"SegtoManualDAO.consultaPrincipal",
										Constantes.ENTERO_CERO,
										Constantes.ENTERO_CERO };
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum)
							throws SQLException {
						SegtoManualBean segtoManualBean = new SegtoManualBean();
						segtoManualBean.setSegtoPrograID(String.valueOf(resultSet.getInt(1)));
						segtoManualBean.setCreditoID(String.valueOf(resultSet.getLong(2)));
						segtoManualBean.setGrupoID(String.valueOf(resultSet.getInt(3)));
						segtoManualBean.setFechaProgramada(String.valueOf(resultSet.getDate(4)));
						segtoManualBean.setHoraProgramada(resultSet.getString(5));
						segtoManualBean.setCategoriaID(String.valueOf(resultSet.getInt(6)));
						segtoManualBean.setPuestoResponsableID(String.valueOf(resultSet.getInt(7)));
						segtoManualBean.setPuestoSupervisorID(String.valueOf(resultSet.getInt(8)));
						segtoManualBean.setTipoGeneracion(resultSet.getString(9));
						segtoManualBean.setSecSegtoForzado(String.valueOf(resultSet.getInt(10)));
						segtoManualBean.setFechaRegistro(String.valueOf(resultSet.getDate(11)));
						segtoManualBean.setEstatus(resultSet.getString(12));
						segtoManualBean.setEsForzado(resultSet.getString(13));

						return segtoManualBean;

					}
				});

				segtoManualConsulta =  matches.size() > 0 ? (SegtoManualBean) matches.get(0) : null;
			}catch(Exception e){
				e.printStackTrace();
			}
			return segtoManualConsulta;
		}

	public SegtoManualBean consultaSolCred(SegtoManualBean segtoManualBean,
			int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call SEGTOPROGRAMADOCON(?,?,?,?,?,"
											 + "?,?,?,?,?,?,?);";

		Object[] parametros = {
                				Constantes.ENTERO_CERO,
								segtoManualBean.getCreditoID(),
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoManualDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SegtoManualBean segtoManualBean = new SegtoManualBean();
				segtoManualBean.setNombreCliente(resultSet.getString(1));
				segtoManualBean.setSolCred(String.valueOf(resultSet.getInt(2)));
				segtoManualBean.setProdCred(String.valueOf(resultSet.getInt(3)));
				segtoManualBean.setDescripcion(resultSet.getString(4));
				segtoManualBean.setMontoSoli(String.valueOf(resultSet.getFloat(5)));
				segtoManualBean.setMontoAutor(String.valueOf(resultSet.getFloat(6)));
				segtoManualBean.setFechaSol(String.valueOf(resultSet.getDate(7)));
				segtoManualBean.setFechaDesem(String.valueOf(resultSet.getDate(8)));
				segtoManualBean.setEstatusCred(resultSet.getString(9));
				segtoManualBean.setSaldoCapVig(String.valueOf(resultSet.getFloat(10)));
				segtoManualBean.setDiasFaltaPago(String.valueOf(resultSet.getInt(11)));
				segtoManualBean.setSaldoCapAtrasa(String.valueOf(resultSet.getFloat(12)));
				segtoManualBean.setSaldoCapVencido(String.valueOf(resultSet.getFloat(13)));
				segtoManualBean.setTelefonoCasa(resultSet.getString(14));
				segtoManualBean.setExtTelefonoPart(resultSet.getString(15));
				segtoManualBean.setTelefonoCelular(resultSet.getString(16));
				return segtoManualBean;
			}
		});

		return matches.size() > 0 ? (SegtoManualBean) matches.get(0) : null;
	}

	public SegtoManualBean consultaSolGrup(SegtoManualBean segtoManualBean,
			int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call SEGTOPROGRAMADOCON(   ?,?,?,?,?,"
												+ "?,?,?,?,?,?,?);";

		Object[] parametros = {
                				Constantes.ENTERO_CERO,
                				Constantes.ENTERO_CERO,
								segtoManualBean.getGrupoID(),
								Constantes.ENTERO_CERO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoManualDAO.consultaPrincipal",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SegtoManualBean segtoManualBean = new SegtoManualBean();
				segtoManualBean.setSolCred(String.valueOf(resultSet.getInt(1)));
				segtoManualBean.setProdCred(String.valueOf(resultSet.getInt(2)));
				segtoManualBean.setDescripcion(resultSet.getString(3));
				segtoManualBean.setMontoSoli(String.valueOf(resultSet.getFloat(4)));
				segtoManualBean.setMontoAutor(String.valueOf(resultSet.getFloat(5)));
				segtoManualBean.setFechaSol(String.valueOf(resultSet.getDate(6)));
				segtoManualBean.setFechaDesem(String.valueOf(resultSet.getDate(7)));
				segtoManualBean.setEstatusCred(resultSet.getString(8));
				segtoManualBean.setSaldoCapVig(String.valueOf(resultSet.getFloat(9)));
				segtoManualBean.setDiasFaltaPago(String.valueOf(resultSet.getInt(10)));
				segtoManualBean.setSaldoCapAtrasa(String.valueOf(resultSet.getFloat(11)));
				segtoManualBean.setSaldoCapVencido(String.valueOf(resultSet.getFloat(12)));
				segtoManualBean.setNombreCliente(resultSet.getString(13));
				segtoManualBean.setClienteIDPre(resultSet.getString(14));
				segtoManualBean.setTelefonoCasa(resultSet.getString(15));
				segtoManualBean.setExtTelefonoPart(resultSet.getString(16));
				segtoManualBean.setTelefonoCelular(resultSet.getString(17));
				return segtoManualBean;
			}
		});

		return matches.size() > 0 ? (SegtoManualBean) matches.get(0) : null;
	}

	public SegtoManualBean consultaAvales(SegtoManualBean segtoManualBean, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call SEGTOPROGRAMADOCON(   ?,?,?,?,?,"
												+ "?,?,?,?,?,?,?);";
		Object[] parametros = {
								Constantes.ENTERO_CERO,
								segtoManualBean.getCreditoID(),
                				Constantes.ENTERO_CERO,
                				Constantes.ENTERO_CERO,
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoManualDAO.consultaAvales",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SegtoManualBean segtoManualBean = new SegtoManualBean();
				segtoManualBean.setSolCred(resultSet.getString(1));
				segtoManualBean.setClienteIDPre(resultSet.getString(2));
				segtoManualBean.setProdCred(resultSet.getString(3));
				segtoManualBean.setNombreCliente(resultSet.getString(4));
				return segtoManualBean;
			}
		});

		return matches.size() > 0 ? (SegtoManualBean) matches.get(0) : null;
	}

	/* Consulta supervisor del Seguimiento*/
	public SegtoManualBean consultaSupervisor(SegtoManualBean segtoManualBean,
			int tipoConsulta) {
				// Query con el Store Procedure
		String query = "call SEGTOPROGRAMADOCON(   ?,?,?,?,?,"
												+ "?,?,?,?,?,?,?);";

		Object[] parametros = {
								segtoManualBean.getSegtoPrograID(),
								Constantes.ENTERO_CERO,
                				Constantes.ENTERO_CERO,
                				segtoManualBean.getPuestoResponsableID(),
								tipoConsulta,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"SegtoManualDAO.consultaAvales",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO };
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOCON(  " + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum)
					throws SQLException {
				SegtoManualBean segtoManualBean = new SegtoManualBean();
				segtoManualBean.setPuestoSupervisorID(resultSet.getString(1));
				return segtoManualBean;
			}
		});

		return matches.size() > 0 ? (SegtoManualBean) matches.get(0) : null;
	}

	public List ListaCalPrincipal(int tipoLista, SegtoManualBean segtoManualBean){
		List listaCalPrinc = null;
		try{
			String query = "call SEGTOPROGRAMADOLIS(" +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?);";

			Object[] parametros = {
									segtoManualBean.getPuestoResponsableID(),
									segtoManualBean.getFechaProgramada(),
									segtoManualBean.getNombreResponsable(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCajasMovs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SegtoManualBean segtoManualret = new SegtoManualBean();
					segtoManualret.setSegtoPrograID(resultSet.getString(1));
					segtoManualret.setHoraProgramada(resultSet.getString(2));
					segtoManualret.setDescripcion(resultSet.getString(3));
					segtoManualret.setEstatus(resultSet.getString(4));
					segtoManualret.setAlcance(resultSet.getString(5));

					return segtoManualret;
				}

			});

			listaCalPrinc = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Movimientos de Cajas", e);

		}
		return listaCalPrinc;
	}

	public List ListaForanea(int tipoLista, SegtoManualBean segtoManualBean){
		List listaCalPrinc = null;
		try{
			String query = "call SEGTOPROGRAMADOLIS(" +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?);";

			Object[] parametros = {
									segtoManualBean.getPuestoResponsableID(),
									OperacionesFechas.conversionStrDate(segtoManualBean.getFechaProgramada()),
									segtoManualBean.getNombreResponsable(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									OperacionesFechas.FEC_VACIA,
									Constantes.STRING_VACIO,
									"listaCajasMovs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					SegtoManualBean segtoManualret = new SegtoManualBean();
					segtoManualret.setSegtoPrograID(resultSet.getString("SegtoPrograID"));
					segtoManualret.setHoraProgramada(resultSet.getString("FechaProgramada"));
					segtoManualret.setDescripcion(resultSet.getString("DetalleActivi"));
					return segtoManualret;
				}
			});
			listaCalPrinc = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de SEGTOPROGRAMADOLIS", e);
			e.printStackTrace();
		}
		return listaCalPrinc;
	}

	public List ListaCalPorMes(int tipoLista, SegtoManualBean segtoManualBean){
		List listaCalPrinc = null;
		try{
			String query = "call SEGTOPROGRAMADOLIS(" +
					"?,?,?,?,?, ?,?,?,?,?," +
					"?);";

			Object[] parametros = {
									segtoManualBean.getPuestoResponsableID(),
									segtoManualBean.getFechaInicioSegto(),
									segtoManualBean.getNombreResponsable(),
									tipoLista,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									segtoManualBean.getFechaFinalSegto(),
									Constantes.STRING_VACIO,
									"listaCajasMovs",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call SEGTOPROGRAMADOLIS(" + Arrays.toString(parametros) +")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {

				public Object mapRow(ResultSet resultSet, int rowNum)
						throws SQLException {
					SegtoManualBean segtoManualret = new SegtoManualBean();
					segtoManualret.setSegtoPrograID(resultSet.getString(1));
					segtoManualret.setFechaProgramada(resultSet.getString(2));
					segtoManualret.setHoraProgramada(resultSet.getString(3));
					segtoManualret.setCategoriaID(resultSet.getString(4));
					return segtoManualret;
				}

			});

			listaCalPrinc = matches;
		}catch(Exception e){
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en lista de Movimientos de Cajas", e);

		}
		return listaCalPrinc;
	}


}
