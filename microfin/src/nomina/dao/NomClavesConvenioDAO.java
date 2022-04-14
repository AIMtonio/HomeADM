package nomina.dao;

import java.sql.CallableStatement;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.Arrays;
import java.util.List;

import nomina.bean.NomClavesConvenioBean;
import nomina.bean.NomTipoClavePresupBean;

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

public class NomClavesConvenioDAO extends BaseDAO{

	public NomClavesConvenioDAO(){
		super();
	}

	/*********************************************************************************************************************/
	/*************************** METODO PARA DAR DE ALTA LAS CLAVES PRESUPUESTALES POR CONVENIO **************************/
	public MensajeTransaccionBean clavePorConvAlt(final NomClavesConvenioBean nomClavesConvenioBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMCLAVESCONVENIOALT( ?,?,?,?,?,  " +
																	   "?,?,?,?,?, " +
																	   "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(nomClavesConvenioBean.getInstitNominaID()));
							sentenciaStore.setLong("Par_ConvenioNominaID", Utileria.convierteLong(nomClavesConvenioBean.getConvenioID()));
							sentenciaStore.setString("Par_NomClavePresupID",nomClavesConvenioBean.getClavesPresupuestales());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomClavesConvenioDAO.clavePorConvAlt");
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClavesConvenioDAO.clavePorConvAlt");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomClavesConvenioDAO.clavePorConvAlt");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Registro de Convenio de Clave Presupuestal" + e);
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
	/***************************** METODO PARA MODIFICAR LAS CLAVES PRESUPUESTALES POR CONVENIO **************************/
	public MensajeTransaccionBean clavePorConvMod(final NomClavesConvenioBean nomClavesConvenioBean ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMCLAVESCONVENIOMOD( ?,?,?,?,?,  " +
																	   "?,?,?,?,?, " +
																	   "?,?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_NomClaveConvenioID", Utileria.convierteEntero(nomClavesConvenioBean.getNomClaveConvenioID()));
							sentenciaStore.setInt("Par_InstitNominaID", Utileria.convierteEntero(nomClavesConvenioBean.getInstitNominaID()));
							sentenciaStore.setLong("Par_ConvenioNominaID", Utileria.convierteLong(nomClavesConvenioBean.getConvenioID()));
							sentenciaStore.setString("Par_NomClavePresupID",nomClavesConvenioBean.getClavesPresupuestales());

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomClavesConvenioDAO.clavePorConvMod");
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClavesConvenioDAO.clavePorConvMod");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomClavesConvenioDAO.clavePorConvMod");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en la Modificacion de Convenio de Clave Presupuestal" + e);
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
	/*********************** METODO PARA DAR DE BAJA LA CLAVE PRESUPUESTAL POR CONVENIO POR ID ***************************/
	public MensajeTransaccionBean clavePresupConvBaja(final NomClavesConvenioBean nomClavesConvenioBean, final int numProceso ) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();

				try {
					// Query con el Store Procedure
					mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "CALL NOMCLAVESCONVENIOBAJ( ?,?,?,?,?,  " +
																	   "?,?,?,?,?, " +
																	   "?,?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);

							sentenciaStore.setInt("Par_NomClaveConvenioID",Utileria.convierteEntero(nomClavesConvenioBean.getNomClaveConvenioID()));
							sentenciaStore.setInt("Par_InstitNominaID",Utileria.convierteEntero(nomClavesConvenioBean.getInstitNominaID()));
							sentenciaStore.setInt("Par_NumBaj",numProceso);

							sentenciaStore.setString("Par_Salida",Constantes.salidaSI);
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID", parametrosAuditoriaBean.getEmpresaID());
							sentenciaStore.setInt("Aud_Usuario", parametrosAuditoriaBean.getUsuario());
							sentenciaStore.setDate("Aud_FechaActual", parametrosAuditoriaBean.getFecha());
							sentenciaStore.setString("Aud_DireccionIP",parametrosAuditoriaBean.getDireccionIP());
							sentenciaStore.setString("Aud_ProgramaID", "NomClavesConvenioDAO.clavePresupConvBaja");
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .NomClavesConvenioDAO.clavePresupConvBaja");
								mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
								mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
							}
							return mensajeTransaccion;
						}
					});
					if(mensajeBean ==  null){
						mensajeBean = new MensajeTransaccionBean();
						mensajeBean.setNumero(999);
						throw new Exception(Constantes.MSG_ERROR + " .NomClavesConvenioDAO.clavePresupConvBaja");
					}else if(mensajeBean.getNumero()!=0){
						throw new Exception(mensajeBean.getDescripcion());
					}
				} catch (Exception e) {
					loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en el Proceso de Baja de Clave Presupuestal por convenio de Nomina" + e);
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
	/************************** METODO PARA EL LISTADO DE LOS CLAVES PRESUPUESTALES POR CONVENIO *************************/
	public List listaClavePresupConv(final NomClavesConvenioBean nomClavesConvenioBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLAVESCONVENIOLIS( ?,?,?,?,?," +
													   "?,?,?,?,?," +
													   "?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				Utileria.convierteEntero(nomClavesConvenioBean.getInstitNominaID()),
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.listaClavePresupConv",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLAVESCONVENIOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClavesConvenioBean nomClavesConvenioBean = new NomClavesConvenioBean();

					nomClavesConvenioBean.setNomClaveConvenioID(resultSet.getString("NomClaveConvenioID"));
					nomClavesConvenioBean.setDescripcion(resultSet.getString("Descripcion"));
					nomClavesConvenioBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));

					return nomClavesConvenioBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de claves Presupuestales por Convenio", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/************************** METODO PARA EL LISTADO DE LOS CLAVES PRESUPUESTALES POR CONVENIOS COMBO *************************/
	public List listaClavePresupCombo(final NomClavesConvenioBean nomClavesConvenioBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLAVESCONVENIOLIS( ?,?,?,?,?," +
													   "?,?,?,?,?," +
													   "?);";
			Object[] parametros = {
				nomClavesConvenioBean.getNomClaveConvenioID(),
				Constantes.ENTERO_CERO,
				Constantes.ENTERO_CERO,
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.listaClavePresupConv",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLAVESCONVENIOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClavesConvenioBean nomClavesConvenioBean = new NomClavesConvenioBean();

					nomClavesConvenioBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));
					nomClavesConvenioBean.setDescripcion(resultSet.getString("Descripcion"));

					return nomClavesConvenioBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista de claves Presupuestales del convenio", e);
		}
		return lista;
	}

	/*********************************************************************************************************************/
	/************************** METODO PARA EL LISTADO DE LOS CLAVES PRESUPUESTALES POR CONVENIOS COMBO *************************/
	public List listaClasiClavPresupConv(final NomClavesConvenioBean nomClavesConvenioBean, final int tipoLista){
		List lista = null;
		try{
			String query = "call NOMCLAVESCONVENIOLIS( ?,?,?,?,?," +
													   "?,?,?,?,?," +
													   "?);";
			Object[] parametros = {
				Constantes.ENTERO_CERO,
				nomClavesConvenioBean.getInstitNominaID(),
				nomClavesConvenioBean.getConvenioID(),
				tipoLista,
				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				"NomTipoClavePresupDAO.ClasiClavPresupConv",
				parametrosAuditoriaBean.getSucursal(),
				Constantes.ENTERO_CERO
			};
			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLAVESCONVENIOLIS(" + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClavesConvenioBean nomClavesConvenioBean = new NomClavesConvenioBean();

					nomClavesConvenioBean.setNomClasifClavPresupID(resultSet.getString("NomClasifClavPresupID"));
					nomClavesConvenioBean.setDescripcion(resultSet.getString("Descripcion"));
					nomClavesConvenioBean.setPrioridad(resultSet.getString("Prioridad"));
					return nomClavesConvenioBean;
				}
			});
			lista= matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en lista deClasificacion de claves Presupuestales del convenio", e);
		}
		return lista;
	}


	/*********************************************************************************************************************/
	/******************** METODO PARA LA CONSULTA DE INFORMACION DE CLAVES PRESUPUESTALES POR CONVENIO *******************/
	public NomClavesConvenioBean conClavePresupConv(final NomClavesConvenioBean nomClavesConvenioBean,int tipoConsulta) {
		NomClavesConvenioBean nomClavesConvenio = null;
		try{
			//Query con el Store Procedure
			String query = "call NOMCLAVESCONVENIOCON(?,?,?,?,?," +
													  "?,?,?,?,?," +
													  "?);";
			Object[] parametros = {
					Constantes.ENTERO_CERO,
					nomClavesConvenioBean.getInstitNominaID(),
					nomClavesConvenioBean.getConvenioID(),
					tipoConsulta,

					parametrosAuditoriaBean.getEmpresaID(),
					parametrosAuditoriaBean.getUsuario(),
					parametrosAuditoriaBean.getFecha(),
					parametrosAuditoriaBean.getDireccionIP(),
					parametrosAuditoriaBean.getNombrePrograma(),
					parametrosAuditoriaBean.getSucursal(),
					parametrosAuditoriaBean.getNumeroTransaccion()
				};

			loggerSAFI.info(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"call NOMCLAVESCONVENIOCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					NomClavesConvenioBean nomClavesConvenioBean = new NomClavesConvenioBean();

					nomClavesConvenioBean.setNomClaveConvenioID(resultSet.getString("NomClaveConvenioID"));
					nomClavesConvenioBean.setInstitNominaID(resultSet.getString("InstitNominaID"));
					nomClavesConvenioBean.setConvenioID(resultSet.getString("ConvenioNominaID"));
					nomClavesConvenioBean.setNomClavePresupID(resultSet.getString("NomClavePresupID"));

					return nomClavesConvenioBean;
				}
			});
			nomClavesConvenio = matches.size() > 0 ? (NomClavesConvenioBean) matches.get(0) : null;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta claves Presupuestal por convenio", e);
		}
		return nomClavesConvenio;
	}



}
