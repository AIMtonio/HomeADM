package nomina.dao;

import org.springframework.transaction.TransactionStatus;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;
import nomina.bean.NomTipoClavePresupBean;
import general.bean.MensajeTransaccionBean;
import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.support.TransactionCallback;


import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class NomTipoClavePresupDAO extends BaseDAO{

	public NomTipoClavePresupDAO(){
		super();
	}

	/*********************************************************************************************************************/
	/***************************** METODO PARA DAR DE ALTA LOS TIPOS DE CLAVES PRESUPUESTALES ****************************/
	public MensajeTransaccionBean tipoClavePresupAlt(final NomTipoClavePresupBean nomTipoClavePresupBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMTIPOCLAVEPRESUPALT( ?,?,?,?,?,  " +
																		"?,?,?,?,?, " +
																		"?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_Descripcion",nomTipoClavePresupBean.getDescripcion());
							sentenciaStore.setString("Par_ReqClave",nomTipoClavePresupBean.getReqClave());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomTipoClavePresupDAO.tipoClavePresupAlt");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomTipoClavePresupDAO.tipoClavePresupAlt");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomTipoClavePresupDAO.tipoClavePresupAlt");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Tipos de Clave Presupuestal" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*********************************************************************************************************************/
	/******************************* METODO PARA MODIFICAR LOS TIPOS DE CLAVES PRESUPUESTALES ****************************/
	public MensajeTransaccionBean tipoClavePresupMod(final NomTipoClavePresupBean nomTipoClavePresupBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMTIPOCLAVEPRESUPMOD( ?,?,?,?,?,  " +
																		"?,?,?,?,?, " +
																		"?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_NomTipoClavePresupID",Utileria.convierteEntero(nomTipoClavePresupBean.getNomTipoClavePresupID()));
							sentenciaStore.setString("Par_Descripcion",nomTipoClavePresupBean.getDescripcion());
							sentenciaStore.setString("Par_ReqClave",nomTipoClavePresupBean.getReqClave());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomTipoClavePresupDAO.tipoClavePresupMod");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomTipoClavePresupDAO.tipoClavePresupMod");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomTipoClavePresupDAO.tipoClavePresupMod");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificacion de Tipos de Clave Presupuestal" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*********************************************************************************************************************/
	/*********************** METODO PARA DAR DE BAJA LOS TIPOS DE CLAVES PRESUPUESTALES POR ID ***************************/
	public MensajeTransaccionBean tipoClavePresupBaja(final NomTipoClavePresupBean nomTipoClavePresupBean, final int numProceso ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMTIPOCLAVEPRESUPBAJ( ?,?,?,?,?,  " +
																		"?,?,?,?,?, " +
																		"?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_NomTipoClavePresupID",Utileria.convierteEntero(nomTipoClavePresupBean.getNomTipoClavePresupID()));
							sentenciaStore.setInt("Par_NumBaj",numProceso);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomTipoClavePresupDAO.tipoClavePresupBaja");
							sentenciaStore.setInt("Aud_Sucursal",parametrosAuditoriaBean.getSucursal());
							sentenciaStore.setLong("Aud_NumTransaccion", parametrosAuditoriaBean.getNumeroTransaccion());

							loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,DataAccessException {
							MensajeTransaccionBean mensajeTransaccion = new MensajeTransaccionBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")));
								mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
								mensajeTransaccion.setNombreControl(resultadosStore.getString("control"));
								mensajeTransaccion.setConsecutivoString(resultadosStore.getString("consecutivo"));
							}else{
								mensajeTransaccion.setNumero(999);
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomTipoClavePresupDAO.tipoClavePresupBaja");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomTipoClavePresupDAO.tipoClavePresupAlt");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Baja de Tipos de Clave Presupuestal" + e);
					e.printStackTrace();
					if (mensajeBean.getNumero() == 0) {
						mensajeBean.setNumero(999);
					}
					mensajeBean.setDescripcion(e.getMessage());
				}
				return mensajeBean;
			}
		});
		return mensaje;
	}

	/*********************************************************************************************************************/
	/************************** METODO PARA EL LISTADO DE LOS TIPOS DE CLAVES PRESUPUESTALES *****************************/
	public List listaTiposClavePresup(final NomTipoClavePresupBean nomTipoClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMTIPOCLAVEPRESUPLIS( ?,?,?,?,?," +
													    "?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				nomTipoClavePresupBean.getDescripcion(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.listaTiposClavePresup",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMTIPOCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomTipoClavePresupBean nomTipoClavePresupBean = new NomTipoClavePresupBean();

					nomTipoClavePresupBean.setNomTipoClavePresupID(resultSet.getString("NomTipoClavePresupID"));
					nomTipoClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomTipoClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de Tipos de claves Presupuestales ", e);
		}
		return lista;
	}


	/*********************************************************************************************************************/
	/********************* METODO PARA EL LISTADO DE LOS TIPOS DE CLAVES PRESUPUESTALES TIPO COMBO ***********************/
	public List listaTiposClaveComb(final NomTipoClavePresupBean nomTipoClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMTIPOCLAVEPRESUPLIS( ?,?,?,?,?," +
													    "?,?,?,?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.listaTiposClaveComb",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMTIPOCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomTipoClavePresupBean nomTipoClavePresupBean = new NomTipoClavePresupBean();
					nomTipoClavePresupBean.setNomTipoClavePresupID(resultSet.getString("NomTipoClavePresupID"));
					nomTipoClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomTipoClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista Combo de Tipos de claves Presupuestales ", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/******************** METODO PARA LA CONSULTA DE INFORMACION DEL TIPOS DE CLAVES PRESUPUESTALES **********************/
	public NomTipoClavePresupBean conTipoClavePresup(final NomTipoClavePresupBean nomTipoClavePresupBean,int tipoConsulta) {
		NomTipoClavePresupBean nomTipoClavePresup = null;
		try{
			//Query con el Store Procedure
			String query = "call NOMTIPOCLAVEPRESUPCON(?,?,?,?,?," +
														"?,?,?,?);";
			Object[] parametros = {
					nomTipoClavePresupBean.getNomTipoClavePresupID(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMTIPOCLAVEPRESUPCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomTipoClavePresupBean bean = new NomTipoClavePresupBean();

					bean.setNomTipoClavePresupID(resultSet.getString("NomTipoClavePresupID"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setReqClave(resultSet.getString("ReqClave"));
					bean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					return bean;
				}
			});
			nomTipoClavePresup = matches.size() > 0 ? (NomTipoClavePresupBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta del tipos claves Presupuestal", e);
		}
		return nomTipoClavePresup;
	}


}
