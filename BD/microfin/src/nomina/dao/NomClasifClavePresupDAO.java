package nomina.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.NomClasifClavePresupBean;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.CallableStatementCallback;
import org.springframework.jdbc.core.CallableStatementCreator;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.Constantes;
import herramientas.Utileria;

public class NomClasifClavePresupDAO extends BaseDAO{

	/*********************************************************************************************************************/
	/******************** METODO PARA DAR DE ALTA LA CLASIFICACION DE LOS CLAVES PRESUPUESTALES **************************/
	public MensajeTransaccionBean clasifClavePresupAlt(final NomClasifClavePresupBean nomClasifClavePresupBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMCLASIFCLAVEPRESUPALT( 	?,?,?,?,?,  " +
																			"?,?,?,?,?, " +
																			"?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setString("Par_Descripcion",nomClasifClavePresupBean.getDescripcion());
							sentenciaStore.setString("Par_Prioridad",nomClasifClavePresupBean.getPrioridad());
							sentenciaStore.setString("Par_NomClavePresupID", nomClasifClavePresupBean.getNomClavePresupID());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomClasifClavePresupDAO.clasifClavePresupAlt");
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClasifClavePresupDAO.clasifClavePresupAlt");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomClasifClavePresupDAO.clasifClavePresupAlt");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Clasificacion de Clave Presupuestal" + e);
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
	/********************** METODO PARA MODIFICAR LA CLASIFICACION DE LOS CLAVES PRESUPUESTALES **************************/
	public MensajeTransaccionBean clasifClavePresupMod(final NomClasifClavePresupBean nomClasifClavePresupBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMCLASIFCLAVEPRESUPMOD( 	?,?,?,?,?,  " +
																			"?,?,?,?,?, " +
																			"?,?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_NomClasifClavPresupID",Utileria.convierteEntero(nomClasifClavePresupBean.getNomClasifClavPresupID()));
							sentenciaStore.setString("Par_Estatus",nomClasifClavePresupBean.getEstatus());
							sentenciaStore.setString("Par_Descripcion",nomClasifClavePresupBean.getDescripcion());
							sentenciaStore.setInt("Par_Prioridad",Utileria.convierteEntero(nomClasifClavePresupBean.getPrioridad()));
							sentenciaStore.setString("Par_NomClavePresupID", nomClasifClavePresupBean.getNomClavePresupID());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomClasifClavePresupDAO.clasifClavePresupMod");
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClasifClavePresupDAO.clasifClavePresupMod");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomClasifClavePresupDAO.clasifClavePresupMod");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificacion de Clasificacion de Clave Presupuestal" + e);
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
	/********************** METODO PARA EL LISTADO DE LAS CLASIFICACION DE CLAVES PRESUPUESTALES *************************/
	public List listaClasifClavePresup(final NomClasifClavePresupBean nomClasifClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLASIFCLAVEPRESUPLIS( ?,?,?,?,?," +
													      "?,?,?,?,?," +
													      "?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				nomClasifClavePresupBean.getDescripcion(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomClasifClavePresupDAO.listaClasifClavePresup",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLASIFCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClasifClavePresupBean nomClasifClavePresupBean = new NomClasifClavePresupBean();

					nomClasifClavePresupBean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));
					nomClasifClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomClasifClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de las Clasificaciones de claves Presupuestales ", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/******************** METODO PARA EL LISTADO DE LAS CLASIFICACION DE CLAVES PRESUPUESTALES COMBO *********************/
	public List listaClasifClaveCombo(final NomClasifClavePresupBean nomClasifClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLASIFCLAVEPRESUPLIS( ?,?,?,?,?," +
													      "?,?,?,?,?," +
													      "?,?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomClasifClavePresupDAO.listaClasifClaveCombo",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLASIFCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClasifClavePresupBean nomClasifClavePresupBean = new NomClasifClavePresupBean();

					nomClasifClavePresupBean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));
					nomClasifClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));
					nomClasifClavePresupBean.setEstatus(resultSet.getString("Estatus"));
					nomClasifClavePresupBean.setPrioridad(resultSet.getString("Prioridad"));
					nomClasifClavePresupBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));

					return nomClasifClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de las Clasificaciones de claves Presupuestales Combo", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/******************** METODO PARA EL LISTADO DE LAS CLASIFICACION DE CLAVES PRESUPUESTALES  **************************/
	public List listaClasifClave(final NomClasifClavePresupBean nomClasifClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLASIFCLAVEPRESUPLIS( ?,?,?,?,?," +
													      "?,?,?,?,?," +
													      "?,?);";
			Object[] parametros = {
				nomClasifClavePresupBean.getNomClasifClavPresupID(),
				Constantes.STRING_VACIO,
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomClasifClavePresupDAO.listaClasifClave",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLASIFCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClasifClavePresupBean nomClasifClavePresupBean = new NomClasifClavePresupBean();

					nomClasifClavePresupBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					nomClasifClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomClasifClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de las Clasificaciones de claves Presupuestales", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/******************** METODO PARA EL LISTADO DE LAS CLASIFICACION DE CLAVES PRESUPUESTALES COMBO *********************/
	public List listaClavPresupConv(final NomClasifClavePresupBean nomClasifClavePresupBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLASIFCLAVEPRESUPLIS( ?,?,?,?,?," +
													      "?,?,?,?,?," +
													      "?,?);";
			Object[] parametros = {
				nomClasifClavePresupBean.getNomClasifClavPresupID(),
				Constantes.STRING_VACIO,
				nomClasifClavePresupBean.getInstitNominaID(),
				nomClasifClavePresupBean.getConvenioNominaID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomClasifClavePresupDAO.listaClavPresupConv",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLASIFCLAVEPRESUPLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClasifClavePresupBean nomClasifClavePresupBean = new NomClasifClavePresupBean();

					nomClasifClavePresupBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					nomClasifClavePresupBean.setClave(resultSet.getString("Clave"));
					nomClasifClavePresupBean.setDescripcion(resultSet.getString("Descripcion"));
					nomClasifClavePresupBean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));
					nomClasifClavePresupBean.setDescClasifClavPresup(resultSet.getString("DescClasifClavPresup"));

					return nomClasifClavePresupBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de las claves Presupuestales por convenio de nomina", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/****************** METODO PARA LA CONSULTA DE INFORMACION DEL CLASIFICACION DE CLAVES PRESUPUESTALES ****************/
	public NomClasifClavePresupBean conClasifClavePresup(final NomClasifClavePresupBean nomClasifClavePresupBean,int tipoConsulta) {
		NomClasifClavePresupBean nomClasifClavePresup = null;
		try{
			//Query con el Store Procedure
			String query = "call NOMCLASIFCLAVEPRESUPCON(?,?,?,?,?," +
														"?,?,?,?);";
			Object[] parametros = {
					nomClasifClavePresupBean.getNomClasifClavPresupID(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLASIFCLAVEPRESUPCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClasifClavePresupBean bean = new NomClasifClavePresupBean();

					bean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));
					bean.setDescripcion(resultSet.getString("Descripcion"));
					bean.setEstatus(resultSet.getString("Estatus"));
					bean.setPrioridad(resultSet.getString("Prioridad"));
					bean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));

					return bean;
				}
			});
			nomClasifClavePresup = matches.size() > 0 ? (NomClasifClavePresupBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta del Clasificacion de clave Presupuestal", e);
		}
		return nomClasifClavePresup;
	}


}
