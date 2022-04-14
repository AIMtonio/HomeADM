package cuentas.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.OperacionesFechas;
import herramientas.Utileria;

import java.sql.CallableStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.sql.Connection;
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

import cuentas.bean.TiposPlanAhorroBean;


public class TiposPlanAhorroDAO extends BaseDAO{

	public TiposPlanAhorroDAO() {
		super();
	}

	public MensajeTransaccionBean alta(final TiposPlanAhorroBean planAhorro) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean)((TransactionTemplate) conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean)((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {

							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL TIPOSPLANAHORROALT(" +
												"?,?,?,?,?," +
												"?,?,?,?,?," +
												"?,?,?,?,?," +
												"?,?,?,?,?," +
												"?,?)";

								CallableStatement sentenciaStore = arg0.prepareCall(query);
								try {
									sentenciaStore.setString("Par_Nombre",planAhorro.getNombre());
									sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(planAhorro.getFechaInicio()));
									sentenciaStore.setDate("Par_FechaVencimiento",OperacionesFechas.conversionStrDate(planAhorro.getFechaVencimiento()));
									sentenciaStore.setDate("Par_FechaLiberacion",OperacionesFechas.conversionStrDate(planAhorro.getFechaLiberacion()));
									sentenciaStore.setDouble("Par_DepositoBase",Utileria.convierteDoble(planAhorro.getDepositoBase()));

									sentenciaStore.setInt("Par_MaxDep",Utileria.convierteEntero(planAhorro.getMaxDep()));
									sentenciaStore.setInt("Par_Serie",Utileria.convierteEntero(planAhorro.getSerie()));
									sentenciaStore.setString("Par_Prefijo",planAhorro.getPrefijo());
									sentenciaStore.setString("Par_LeyendaBloqueo",planAhorro.getLeyendaBloqueo());
									sentenciaStore.setString("Par_LeyendaTicket",planAhorro.getLeyendaTicket());

									sentenciaStore.setString("Par_TiposCuentas",planAhorro.getTiposCuentas());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_DiasDesbloqueo",Utileria.convierteEntero(planAhorro.getDiasDesbloqueo()));

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TiposPlanAhorroDAO");

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
								} catch (Exception e) {
									e.printStackTrace();
									loggerSAFI.info(sentenciaStore.toString());
									return null;
								}
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()) {
									ResultSet resultadoStore = callableStatement.getResultSet();

									resultadoStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadoStore.getString(3));
									mensajeTransaccion.setConsecutivoString(resultadoStore.getString(4));
								}else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado");
								}
								return mensajeTransaccion;
							}
						}
					);

					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo: El procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setCampoGenerico(e.getMessage());
					transaction.setRollbackOnly();
					loggerSAFI.error("Error en alta de Plan de Ahorro.");
				}
				return mensajeBean;
			}
		});

		return mensaje;
	}

	public MensajeTransaccionBean modifica(final TiposPlanAhorroBean planAhorro) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();

		mensaje = (MensajeTransaccionBean)((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
								String query = "CALL TIPOSPLANAHORROMOD(" +
											"?,?,?,?,?," +
											"?,?,?,?,?," +
											"?,?,?,?,?," +
											"?,?,?,?,?," +
											"?,?,?)";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_PlanID",Utileria.convierteEntero(planAhorro.getPlanID()));
									sentenciaStore.setString("Par_Nombre",planAhorro.getNombre());
									sentenciaStore.setDate("Par_FechaInicio",OperacionesFechas.conversionStrDate(planAhorro.getFechaInicio()));
									sentenciaStore.setDate("Par_FechaVencimiento",OperacionesFechas.conversionStrDate(planAhorro.getFechaVencimiento()));
									sentenciaStore.setDate("Par_FechaLiberacion",OperacionesFechas.conversionStrDate(planAhorro.getFechaLiberacion()));

									sentenciaStore.setDouble("Par_DepositoBase",Utileria.convierteDoble(planAhorro.getDepositoBase()));
									sentenciaStore.setInt("Par_MaxDep",Utileria.convierteEntero(planAhorro.getMaxDep()));
									sentenciaStore.setString("Par_Prefijo",planAhorro.getPrefijo());
									sentenciaStore.setInt("Par_Serie",Utileria.convierteEntero(planAhorro.getSerie()));
									sentenciaStore.setString("Par_LeyendaBloqueo",planAhorro.getLeyendaBloqueo());

									sentenciaStore.setString("Par_LeyendaTicket",planAhorro.getLeyendaTicket());
									sentenciaStore.setString("Par_TiposCuentas",planAhorro.getTiposCuentas());
									sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
									sentenciaStore.registerOutParameter("Par_NumErr",Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									sentenciaStore.setInt("Par_DiasDesbloqueo",Utileria.convierteEntero(planAhorro.getDiasDesbloqueo()));

									sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
									sentenciaStore.setInt("Aud_Usuario",parametrosAuditoriaBean.getUsuario());
									sentenciaStore.setDate("Aud_FechaActual",parametrosAuditoriaBean.getFecha());
									sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
									sentenciaStore.setString("Aud_ProgramaID","TiposPlanAhorroDAO");

									sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
									sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

									loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
									return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()) {
									ResultSet resultadoStore = callableStatement.getResultSet();

									resultadoStore.next();
									mensajeTransaccion.setNumero(Integer.valueOf(resultadoStore.getString(1)).intValue());
									mensajeTransaccion.setDescripcion(resultadoStore.getString(2));
									mensajeTransaccion.setNombreControl(resultadoStore.getString(3));
								}else {
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado");
								}
								return mensajeTransaccion;
							}
						}
					);
					System.out.println("Despues de mensajeBean \n");
					if(mensajeBean == null) {
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo: El procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0) {
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					if(mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setCampoGenerico(e.getMessage());
					transaction.setRollbackOnly();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error al modificar Plan de Ahorro.");
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	public TiposPlanAhorroBean consultaPrincipal(TiposPlanAhorroBean planAhorro,int tipoConsulta) {
		TiposPlanAhorroBean planAhorroConsulta = new TiposPlanAhorroBean();
		try {
			String query = "CALL TIPOSPLANAHORROCON(?,?, ?,?,?,?,?,?,?)";

			Object[] parametros= {
									Utileria.convierteEntero(planAhorro.getPlanID()),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"TiposPlanAhorroDAO.consultaPrincipal",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL TIPOSPLANAHORROCON("+Arrays.toString(parametros)+")");

			List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros, new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException{
					TiposPlanAhorroBean planAhorro = new TiposPlanAhorroBean();

					planAhorro.setPlanID(String.valueOf(resultSet.getInt("PlanID")));
					planAhorro.setNombre(resultSet.getString("Nombre"));
					planAhorro.setFechaInicio(String.valueOf(resultSet.getDate("FechaInicio")));
					planAhorro.setFechaVencimiento(String.valueOf(resultSet.getDate("FechaVencimiento")));
					planAhorro.setFechaLiberacion(String.valueOf(resultSet.getDate("FechaLiberacion")));

					planAhorro.setDepositoBase(String.valueOf(resultSet.getDouble("DepositoBase")));
					planAhorro.setMaxDep(String.valueOf(resultSet.getInt("MaxDep")));
					planAhorro.setPrefijo(resultSet.getString("Prefijo"));
					planAhorro.setSerie(String.valueOf(resultSet.getInt("Serie")));
					planAhorro.setLeyendaBloqueo(resultSet.getString("LeyendaBloqueo"));

					planAhorro.setLeyendaTicket(resultSet.getString("LeyendaTicket"));
					planAhorro.setTiposCuentas(resultSet.getString("TiposCuentas"));
					planAhorro.setDiasDesbloqueo(resultSet.getString("DiasDesbloqueo"));
					return planAhorro;
				}
			});

			return matches.size() > 0 ? (TiposPlanAhorroBean) matches.get(0) : null;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+" error en consulta principal Tipos Plan Ahorro",e);
		}
		return planAhorroConsulta;
	}

	public List listaPlanAhorro(TiposPlanAhorroBean planAhorro, int tipoLista) {
		String query = "CALL TIPOSPLANAHORROLIS(?,?, ?,?,?,?,?,?,?)";
		Object[] parametros = {
								planAhorro.getPlanID(),
								tipoLista,

								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposCreditosDAO.listaPlanesAhorro",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
							};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL TIPOSPLANAHORROLIS("+Arrays.toString(parametros)+")");

		List matches = ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query, parametros, new RowMapper() {
			public Object mapRow(ResultSet resultSet,int rowNum)throws SQLException{
				TiposPlanAhorroBean planAhorroLista= new TiposPlanAhorroBean();

				planAhorroLista.setPlanID(String.valueOf(resultSet.getInt("PlanID")));
				planAhorroLista.setNombre(resultSet.getString("Nombre"));

				return planAhorroLista;
			}
		});

		return matches;
	}
}
