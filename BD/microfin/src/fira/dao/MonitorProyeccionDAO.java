package fira.dao;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;


import fira.bean.MonitorProyeccionBean;

public class MonitorProyeccionDAO extends BaseDAO {

	public MonitorProyeccionDAO(){
		super();
	}

	//Metodo de alta de proyeccion de indicadores
		public MensajeTransaccionBean grabaListaProyeccion( final List listaParametros,  final int tipoActualizacion , final int anioLista) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();

			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						MonitorProyeccionBean proyeccionBean;

							if(listaParametros.size()>0){
								for(int i=0; i < listaParametros.size(); i++){
									proyeccionBean = new MonitorProyeccionBean();
									proyeccionBean = (MonitorProyeccionBean) listaParametros.get(i);

									// alta de proyeccion
									mensajeBean= altaProyeccion(proyeccionBean, tipoActualizacion, anioLista);
									if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								}
							 }else{
								mensajeBean.setDescripcion("Lista de Proyección de Indicadores Vacía");
								throw new Exception(mensajeBean.getDescripcion());
							}

					} catch (Exception e) {
						e.printStackTrace();
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Alta de Proyección de Indicadores", e);
						if(mensajeBean.getNumero()==0){
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


		//Alta de proyeccion de indicadores
		public MensajeTransaccionBean altaProyeccion(final MonitorProyeccionBean proyeccionBean, final int tipoActualizacion, final int anioLista) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						// Query con el Store Procedure
						mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
										String query = "call PROYECCIONINDICAALT(" +
											"?,?,?,?,?,  ?,?,?,?,?," +
											"?,?,?,?,?,	?,?,?,?,?);";
										CallableStatement sentenciaStore = arg0.prepareCall(query);

										sentenciaStore.setLong("Par_ConsecutivoID",Utileria.convierteLong(proyeccionBean.getConsecutivoID()));
										sentenciaStore.setInt("Par_Anio",anioLista);
										sentenciaStore.setString("Par_Mes",proyeccionBean.getMes());
										sentenciaStore.setDouble("Par_SaldoTotal",Utileria.convierteDoble(proyeccionBean.getSaldoTotal()));
										sentenciaStore.setDouble("Par_SaldoFira",Utileria.convierteDoble(proyeccionBean.getSaldoFira()));
										sentenciaStore.setDouble("Par_GastosAdmin",Utileria.convierteDoble(proyeccionBean.getGastosAdmin()));
										sentenciaStore.setDouble("Par_CapitalConta",Utileria.convierteDoble(proyeccionBean.getCapitalConta()));
										sentenciaStore.setDouble("Par_UtilidadNeta",Utileria.convierteDoble(proyeccionBean.getUtilidadNeta()));
										sentenciaStore.setDouble("Par_ActivoTotal",Utileria.convierteDoble(proyeccionBean.getActivoTotal()));
										sentenciaStore.setDouble("Par_SaldoVencido",Utileria.convierteDoble(proyeccionBean.getSaldoVencido()));

										sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
										sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
										sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

										//Parametros de Auditoria
										sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
											mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProyeccionDAO.altaProyeccion");
											mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
											mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										}

										return mensajeTransaccion;
									}
								}
								);

							if(mensajeBean ==  null){
								mensajeBean = new MensajeTransaccionBean();
								mensajeBean.setNumero(999);
								throw new Exception(Constantes.MSG_ERROR + " .ProyeccionDAO.altaProyeccion");
							}else if(mensajeBean.getNumero()!=0){
								throw new Exception(mensajeBean.getDescripcion());
							}
						} catch (Exception e) {
							loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Proyección" + e);
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
		//Metodo de alta de proyeccion de indicadores
				public MensajeTransaccionBean modificaListaProyeccion( final List listaParametros,  final int tipoActualizacion , final int anioLista) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					transaccionDAO.generaNumeroTransaccion();

					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
								MonitorProyeccionBean proyeccionBean;

									if(listaParametros.size()>0){
										for(int i=0; i < listaParametros.size(); i++){
											proyeccionBean = new MonitorProyeccionBean();
											proyeccionBean = (MonitorProyeccionBean) listaParametros.get(i);

											// modifica proyeccion
											mensajeBean= modificaProyeccion(proyeccionBean, tipoActualizacion, anioLista);
											if(mensajeBean.getNumero()!=0){
												throw new Exception(mensajeBean.getDescripcion());
											}
										}
									 }else{
										mensajeBean.setDescripcion("Lista de Proyección de Indicadores Vacía");
										throw new Exception(mensajeBean.getDescripcion());
									}

							} catch (Exception e) {
								e.printStackTrace();
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificación de Proyección de Indicadores", e);
								if(mensajeBean.getNumero()==0){
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


				//Alta de proyeccion de indicadores
				public MensajeTransaccionBean modificaProyeccion(final MonitorProyeccionBean proyeccionBean, final int tipoActualizacion, final int anioLista) {
					MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
					mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
						public Object doInTransaction(TransactionStatus transaction) {
							MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
							try {
								// Query con el Store Procedure
								mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
									new CallableStatementCreator() {
										public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
												String query = "call PROYECCIONINDICAMOD(" +
													"?,?,?,?,?,  ?,?,?,?,?," +
													"?,?,?,?,?,	?,?,?,?,?);";
												CallableStatement sentenciaStore = arg0.prepareCall(query);

												sentenciaStore.setLong("Par_ConsecutivoID",Utileria.convierteLong(proyeccionBean.getConsecutivoID()));
												sentenciaStore.setInt("Par_Anio",anioLista);
												sentenciaStore.setString("Par_Mes",proyeccionBean.getMes());
												sentenciaStore.setDouble("Par_SaldoTotal",Utileria.convierteDoble(proyeccionBean.getSaldoTotal()));
												sentenciaStore.setDouble("Par_SaldoFira",Utileria.convierteDoble(proyeccionBean.getSaldoFira()));

												sentenciaStore.setDouble("Par_GastosAdmin",Utileria.convierteDoble(proyeccionBean.getGastosAdmin()));
												sentenciaStore.setDouble("Par_CapitalConta",Utileria.convierteDoble(proyeccionBean.getCapitalConta()));
												sentenciaStore.setDouble("Par_UtilidadNeta",Utileria.convierteDoble(proyeccionBean.getUtilidadNeta()));
												sentenciaStore.setDouble("Par_ActivoTotal",Utileria.convierteDoble(proyeccionBean.getActivoTotal()));
												sentenciaStore.setDouble("Par_SaldoVencido",Utileria.convierteDoble(proyeccionBean.getSaldoVencido()));

												sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
												sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
												sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

												//Parametros de Auditoria
												sentenciaStore.setInt("Par_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
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
													mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .ProyeccionDAO.modificaProyeccion");
													mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
													mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
												}

												return mensajeTransaccion;
											}
										}
										);

									if(mensajeBean ==  null){
										mensajeBean = new MensajeTransaccionBean();
										mensajeBean.setNumero(999);
										throw new Exception(Constantes.MSG_ERROR + " .ProyeccionDAO.modificaProyeccion");
									}else if(mensajeBean.getNumero()!=0){
										throw new Exception(mensajeBean.getDescripcion());
									}
								} catch (Exception e) {
									loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Modificación de Proyección" + e);
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


		//Lista para el grid con los posibles riesgos
		public List listaProyeccion(int anioLista, int tipoLista, MonitorProyeccionBean proyeccionBean){
			String query = "call PROYECCIONINDICALIS(?,?,	?,?,?, ?,?,?,?);";

			Object[] parametros = {
					tipoLista,
					anioLista,
					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					"MonitorProyeccionDAO.listaProyeccion",
					parametrosAuditoriaBean.getSucursal(),
					Constantes.ENTERO_CERO
			};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call PROYECCIONINDICALIS(  " + Arrays.toString(parametros) + ")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					MonitorProyeccionBean bean = new MonitorProyeccionBean();

					bean.setConsecutivoID(resultSet.getString("ConsecutivoID"));
					bean.setAnio(resultSet.getString("Anio"));
					bean.setMes(resultSet.getString("Mes"));
					bean.setSaldoTotal(resultSet.getString("SaldoTotal"));
					bean.setSaldoFira(resultSet.getString("SaldoFira"));
					bean.setGastosAdmin(resultSet.getString("GastosAdmin"));
					bean.setCapitalConta(resultSet.getString("CapitalConta"));
					bean.setUtilidadNeta(resultSet.getString("UtilidadNeta"));
					bean.setActivoTotal(resultSet.getString("ActivoTotal"));
					bean.setSaldoVencido(resultSet.getString("SaldoVencido"));
					bean.setFlag(resultSet.getString("Flag"));

					return bean;
				}
			});

			return matches;
		}

}
