package fira.dao;

import fira.bean.TiposLineasAgroBean;
import fira.servicio.TiposLineasAgroServicio.Enum_Con_TiposLineasAgro;
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

public class TiposLineasAgroDAO extends BaseDAO {

	public TiposLineasAgroDAO(){
		super();
	}

	// Alta de Tipos de Líneas Credito
	public MensajeTransaccionBean altaTiposLineasAgro(final TiposLineasAgroBean tiposLineasAgroBean) {
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
								String query = "CALL TIPOSLINEASAGROALT(?,?,?,?,?," +
																	   "?,?," +
																	   "?,?,?," +
																	   "?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setString("Par_NombreTipoLinea", tiposLineasAgroBean.getNombre());
								sentenciaStore.setString("Par_EsRevolvente", tiposLineasAgroBean.getEsRevolvente());
								sentenciaStore.setDouble("Par_MontoLimite", Utileria.convierteDoble(tiposLineasAgroBean.getMontoLimite()));
								sentenciaStore.setInt("Par_PlazoLimite", Utileria.convierteEntero(tiposLineasAgroBean.getPlazoLimite()));
								sentenciaStore.setString("Par_ManejaComAdmon", tiposLineasAgroBean.getManejaComAdmon());

								sentenciaStore.setString("Par_ManejaComGaran", tiposLineasAgroBean.getManejaComGaran());
								sentenciaStore.setString("Par_ProductosCredito", tiposLineasAgroBean.getProductosCredito());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
								}else{
									mensajeTransaccion.setNumero(999);
									mensajeTransaccion.setDescripcion("Fallo. El Procedimiento no Regreso Ningun Resultado.");
								}
								return mensajeTransaccion;
							}
						}
						);
					if(mensajeBean == null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en el Alta de Tipos de Líneas de Crédito Agro ", exception);
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
	}//Fin Alta de Tipos de Lineas Credito

	// Modificación de Tipo de Líneas Credito
	public MensajeTransaccionBean modificaTiposLineasAgro(final TiposLineasAgroBean tiposLineasAgroBean) {
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
								String query = "CALL TIPOSLINEASAGROMOD(?,?,?,?,?,"
																	  +"?,"
																	  +"?,?,?,"
																	  +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_TipoLineaAgroID", Utileria.convierteEntero(tiposLineasAgroBean.getTipoLineaAgroID()));
								sentenciaStore.setString("Par_NombreTipoLinea",tiposLineasAgroBean.getNombre());
								sentenciaStore.setString("Par_ManejaComAdmon",tiposLineasAgroBean.getManejaComAdmon());
								sentenciaStore.setString("Par_ManejaComGaran",tiposLineasAgroBean.getManejaComGaran());
								sentenciaStore.setString("Par_ProductosCredito",tiposLineasAgroBean.getProductosCredito());

								sentenciaStore.setString("Par_Estatus", tiposLineasAgroBean.getEstatus());

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
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
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la Modificación de Tipos de Líneas de Crédito Agro ", exception);
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
	}// Fin Baja de Tipos de Lineas Credito

	// Baja de Tipo de Líneas Credito
	public MensajeTransaccionBean bajaTiposLineasAgro(final TiposLineasAgroBean tiposLineasAgroBean, final int tipoActualizacion) {
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
								String query = "CALL TIPOSLINEASAGROACT(?,,?"
																	  +"?,?,?,"
																	  +"?,?,?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);

								sentenciaStore.setInt("Par_TipoLineaAgroID", Utileria.convierteEntero(tiposLineasAgroBean.getTipoLineaAgroID()));
								sentenciaStore.setInt("Par_NumActualizacion", tipoActualizacion);

								sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
								sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
								sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

								sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
								sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
								sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
								sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
								sentenciaStore.setString("Aud_ProgramaID",parametrosAuditoriaBean.getNombrePrograma());
								sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
								sentenciaStore.setLong("Aud_NumTransaccion",parametrosAuditoriaBean.getNumeroTransaccion());

						    	loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+sentenciaStore.toString());
								return sentenciaStore;

							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException, DataAccessException {
								MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									if((Integer.valueOf(resultadosStore.getString(1)).intValue())==0){
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}else{
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString(1)).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString(2));
										mensajeTransaccion.setNombreControl(resultadosStore.getString(3));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString(4));
									}
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
						throw new Exception("Fallo. El Procedimiento no Regreso Ningun Resultado.");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception exception) {
					exception.printStackTrace();
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"Error en la baja del Tipo de Lénea de Crédito Agro ", exception);
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
	}// Fin Baja de Tipos de Lineas Credito

	// Consulta Principal
	public TiposLineasAgroBean consultaPrincipal(final TiposLineasAgroBean tiposLineasAgroBean, final int tipoConsulta) {

		TiposLineasAgroBean tiposLineasAgro = null;
		//Query con el Store Procedure
		try{
			String query = "CALL TIPOSLINEASAGROCON(?,?,"
										    	  +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Utileria.convierteEntero(tiposLineasAgroBean.getTipoLineaAgroID()),
				tipoConsulta,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposLineasAgroDAO.consultaPrincipal",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL TIPOSLINEASAGROCON(" + Arrays.toString(parametros) +")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposLineasAgroBean tipoLinea = new TiposLineasAgroBean();
					switch(tipoConsulta){
						case Enum_Con_TiposLineasAgro.principal:
							tipoLinea.setTipoLineaAgroID(resultSet.getString("TipoLineaAgroID"));
							tipoLinea.setNombre(resultSet.getString("Nombre"));
							tipoLinea.setFechaRegistro(resultSet.getString("FechaRegistro"));
							tipoLinea.setEstatus(resultSet.getString("Estatus"));
							tipoLinea.setEsRevolvente(resultSet.getString("EsRevolvente"));

							tipoLinea.setMontoLimite(resultSet.getString("MontoLimite"));
							tipoLinea.setPlazoLimite(resultSet.getString("PlazoLimite"));
							tipoLinea.setManejaComAdmon(resultSet.getString("ManejaComAdmon"));
							tipoLinea.setManejaComGaran(resultSet.getString("ManejaComGaran"));
							tipoLinea.setProductosCredito(resultSet.getString("ProductosCredito"));

							tipoLinea.setFechaBaja(resultSet.getString("FechaBaja"));
							tipoLinea.setFechaReactivacion(resultSet.getString("FechaReactivacion"));
							tipoLinea.setUsuarioRegistro(resultSet.getString("UsuarioRegistro"));
							tipoLinea.setUsuarioBaja(resultSet.getString("UsuarioBaja"));
						break;
						case Enum_Con_TiposLineasAgro.manejaLinea:
							tipoLinea.setTipoLineaAgroID(resultSet.getString("TipoLineaAgroID"));
						break;
					}
					return tipoLinea;
				}
			});

			tiposLineasAgro = matches.size() > 0 ? (TiposLineasAgroBean) matches.get(0) : null;

		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal de Tipos de Líneas Crédito Agro ", exception);
			tiposLineasAgro = null;
		}

		return tiposLineasAgro;
	}

	// Lista Principal
	public List<TiposLineasAgroBean> listaPrincipal(final TiposLineasAgroBean tiposLineasAgroBean, final int tipoLista) {

		List<TiposLineasAgroBean> listaTiposLineasAgroBean = null;
		//Query con el Store Procedure
		try{
			String query = "CALL TIPOSLINEASAGROLIS(?,?,"
												  +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				tiposLineasAgroBean.getNombre(),
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposLineasAgroDAO.listaAlmacenes",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL TIPOSLINEASAGROLIS(" + Arrays.toString(parametros) + ")");
			List<TiposLineasAgroBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposLineasAgroBean tiposLineas = new TiposLineasAgroBean();
					tiposLineas.setTipoLineaAgroID(String.valueOf(resultSet.getInt("TipoLineaAgroID")));
					tiposLineas.setNombre(resultSet.getString("Nombre"));
					return tiposLineas;
				}
			});

			listaTiposLineasAgroBean = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en Lista principal de Tipos de Líneas Crédito Agro ", exception);
			listaTiposLineasAgroBean = null;
		}

		return listaTiposLineasAgroBean;
	}

	// Lista Combo
	public List<TiposLineasAgroBean> listaCombo(final TiposLineasAgroBean tiposLineasAgroBean, final int tipoLista) {

		List<TiposLineasAgroBean> listaTiposLineasAgroBean = null;
		//Query con el Store Procedure
		try{
			String query = "CALL TIPOSLINEASAGROLIS(?,?,"
												  +"?,?,?,?,?,?,?);";
			Object[] parametros = {
				Constantes.STRING_VACIO,
				tipoLista,

				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				Constantes.FECHA_VACIA,
				Constantes.STRING_VACIO,
				"TiposLineasAgroDAO.listaCombo",
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+" - "+"CALL TIPOSLINEASAGROLIS(" + Arrays.toString(parametros) + ")");
			List<TiposLineasAgroBean> matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					TiposLineasAgroBean tiposLineas = new TiposLineasAgroBean();
					tiposLineas.setTipoLineaAgroID(String.valueOf(resultSet.getInt(1)));
					tiposLineas.setNombre(resultSet.getString(2));
					return tiposLineas;
				}
			});

			listaTiposLineasAgroBean = matches;
		}catch(Exception exception){
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en Lista combo de Tipos de Líneas Crédito Agro ", exception);
			listaTiposLineasAgroBean = null;
		}

		return listaTiposLineasAgroBean;
	}
}