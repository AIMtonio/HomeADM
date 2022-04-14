package credito.dao;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.transaction.support.TransactionTemplate;

import general.bean.MensajeTransaccionBean;
import general.dao.BaseDAO;
import herramientas.CalculosyOperaciones;
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

import credito.bean.GruposCreditoBean;

public class GruposCreditoDAO extends BaseDAO{

	java.sql.Date fecha = null;
	public GruposCreditoDAO() {
		super();
	}

	private final static String salidaPantalla = "S";

	 /* Alta de Grupos de Credito */

	public MensajeTransaccionBean altaGrupos(final GruposCreditoBean gruposCreditoBean) {
		MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
		transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
			public Object doInTransaction(TransactionStatus transaction) {
				MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
				try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call GRUPOSCREDITOALT(?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?,?,?);";

					CallableStatement sentenciaStore = arg0.prepareCall(query);

					sentenciaStore.setString("Par_NombreGrupo",gruposCreditoBean.getNombreGrupo());
					sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(gruposCreditoBean.getSucursalID()));
					sentenciaStore.setInt("Par_CicloActual",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
					sentenciaStore.setString("Par_EstatusCiclo",gruposCreditoBean.getEstatusCiclo());
					sentenciaStore.setDate("Par_FechaUltCiclo",OperacionesFechas.conversionStrDate(gruposCreditoBean.getFechaUltCiclo()));

					// modulo Agro
					sentenciaStore.setString("Par_EsAgro",gruposCreditoBean.getEsAgropecuario());
					sentenciaStore.setString("Par_TipoOpeAgro",gruposCreditoBean.getTipoOperacion());

					sentenciaStore.setString("Par_Salida",salidaPantalla);
					//Parametros de OutPut
					sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
					sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

					//Parametros de Auditoria
					sentenciaStore.setInt("Aud_EmpresaID",parametrosAuditoriaBean.getEmpresaID());
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
						mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GruposCreditoDAO.altaGrupos");
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
			throw new Exception(Constantes.MSG_ERROR + " .GruposCreditoDAO.altaGrupos");
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
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en alta de grupo de credito", e);
	}
	return mensajeBean;
}
});
return mensaje;
}


	//Query con el Store Procedure Para la consulta principal para construir el nombre

	public GruposCreditoBean consultaPrincipal(GruposCreditoBean gruposCreditoBean, int tipoConsulta){

		GruposCreditoBean gruposCredito = null;
		try {
			String query = "CALL GRUPOSCREDITOCON(?,?,?,?,?, ?,?,?,?,?);";

			Object[] parametros = {
					Utileria.convierteEntero(gruposCreditoBean.getGrupoID()),
					Utileria.convierteEntero(gruposCreditoBean.getCicloActual()),

					tipoConsulta,
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"GruposCreditoDAO.ConsultaGrupos",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO};

			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"CALL GRUPOSCREDITOCON(  " + Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {

					GruposCreditoBean grupos = new GruposCreditoBean();

					try{
						grupos.setGrupoID(resultSet.getString(1));
						grupos.setNombreGrupo(resultSet.getString(2));
						grupos.setFechaRegistro(resultSet.getString(3));
						grupos.setSucursalID(resultSet.getString(4));
						grupos.setCicloActual(resultSet.getString(5));
						grupos.setEstatusCiclo(resultSet.getString(6));
						grupos.setFechaUltCiclo(resultSet.getString(7));
						grupos.setProductoCre(resultSet.getString(8));
						grupos.setNombreSucursal(resultSet.getString(9));
						grupos.setProrrateaPago(resultSet.getString("ProrrateaPago"));
						grupos.setRefPayCash(resultSet.getString("RefPayCash"));
					} catch(Exception ex){
						ex.printStackTrace();
						return null;
					}
					return grupos;
				}
			});
			gruposCredito = matches.size() > 0 ? (GruposCreditoBean) matches.get(0) : null;
		} catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta principal del Grupos ", exception);
			gruposCredito = null;
		}
		return gruposCredito;
	}


	 /* Modificación  de Grupos */

		public MensajeTransaccionBean ModificaGrupo(final GruposCreditoBean gruposCreditoBean) {
			MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
			transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
				public Object doInTransaction(TransactionStatus transaction) {
					MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
					try {
						//Query con el Store Procedure
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
							new CallableStatementCreator() {
								public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
						String query = "call GRUPOSCREDITOMOD(?,?,?,?,?, ?,?,?,?,?, ?,?,?,?,?, ?);";

						CallableStatement sentenciaStore = arg0.prepareCall(query);
						sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
						sentenciaStore.setString("Par_NombreGrupo",gruposCreditoBean.getNombreGrupo());
						sentenciaStore.setInt("Par_SucursalID",Utileria.convierteEntero(gruposCreditoBean.getSucursalID()));
						sentenciaStore.setInt("Par_CicloActual",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
						sentenciaStore.setString("Par_EstatusCiclo",gruposCreditoBean.getEstatusCiclo());
						sentenciaStore.setDate("Par_FechaUltCiclo",OperacionesFechas.conversionStrDate(gruposCreditoBean.getFechaUltCiclo()));

						sentenciaStore.setString("Par_Salida",salidaPantalla);
						//Parametros de OutPut
						sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
						sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

						//Parametros de Auditoria
						sentenciaStore.setInt("Aud_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
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
							mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GruposCreditoDAO.ModificaGrupo");
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
				throw new Exception(Constantes.MSG_ERROR + " .GruposCreditoDAO.ModificaGrupo");
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
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en modificacion de grupos", e);
		}
		return mensajeBean;
	}
	});
	return mensaje;
	}


		 /* Actualizacion  de Grupos */

			public MensajeTransaccionBean ActualizaGrupo(final GruposCreditoBean gruposCreditoBean, final int tipoActualizacion) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call GRUPOSCREDITOACT(?,?,?,?,?, ?,?,?,?,?, ?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
							sentenciaStore.setInt("Par_TipoAct",tipoActualizacion);


							sentenciaStore.setString("Par_Salida",salidaPantalla);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GruposCreditoDAO.ActualizaGrupo");
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
					throw new Exception(Constantes.MSG_ERROR + " .GruposCreditoDAO.ActualizaGrupo");
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error al actualizar grupo", e);
			}
			return mensajeBean;
		}
		});
		return mensaje;
		}



			 /* Actualizacion  de Grupos */

			public MensajeTransaccionBean ActualizaGrupoCierre(final GruposCreditoBean gruposCreditoBean, final int tipoActualizacion) {
				MensajeTransaccionBean mensaje = new MensajeTransaccionBean();
				transaccionDAO.generaNumeroTransaccion();
		mensaje = (MensajeTransaccionBean) ((TransactionTemplate)conexionOrigenDatosBean.getManejadorTransaccionesMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(new TransactionCallback<Object>() {
					public Object doInTransaction(TransactionStatus transaction) {
						MensajeTransaccionBean mensajeBean = new MensajeTransaccionBean();
						try {
			mensajeBean = (MensajeTransaccionBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
								new CallableStatementCreator() {
									public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
							String query = "call GRUPOSCREDITOACT(?,?,?,?,?, ?,?,?,?,?, ?,?);";

							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID", Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
							sentenciaStore.setInt("Par_TipoAct",tipoActualizacion);
							sentenciaStore.setString("Par_Salida",salidaPantalla);
							//Parametros de OutPut
							sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
							sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

							//Parametros de Auditoria
							sentenciaStore.setInt("Aud_EmpresaID",(parametrosAuditoriaBean.getEmpresaID()));
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
								mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GruposCreditoDAO.ActualizaGrupo");
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
					throw new Exception(Constantes.MSG_ERROR + " .GruposCreditoDAO.ActualizaGrupo");
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
				loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en actualizacion de credito grupal", e);
			}
			return mensajeBean;
		}
		});
		return mensaje;
		}

			public List listaAlfanumerica(GruposCreditoBean gruposCreditoBean, int tipoLista){
				String query = "call GRUPOSCREDITOLIS(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

						gruposCreditoBean.getNombreGrupo(),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"AreasDAO.listaAlfanumerica",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOLIS(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GruposCreditoBean grupos = new GruposCreditoBean();
						grupos.setGrupoID(resultSet.getString(1));
						grupos.setNombreGrupo(resultSet.getString(2));
						grupos.setNombreSucursal(resultSet.getString(3));
						return grupos;

					}
				});
				return matches;
				}

			public List listaRompimientoGrupos(GruposCreditoBean gruposCreditoBean, int tipoLista){
				String query = "call GRUPOSCREDITOLIS(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

							gruposCreditoBean.getNombreGrupo(),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GruposCreditoDAO.listaRompimientoGrupos",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOLIS(" +Arrays.toString(parametros) + ")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GruposCreditoBean grupos = new GruposCreditoBean();
						grupos.setGrupoID(resultSet.getString("GrupoID"));
						grupos.setNombreGrupo(resultSet.getString("NombreGrupo"));
						grupos.setNombreSucursal(resultSet.getString("NombreSucurs"));
						return grupos;

					}
				});
				return matches;
				}

			/* Lista de Grupos con Solicitudes Liberadas */
			public List listaSolicitudLiberada(GruposCreditoBean gruposCreditoBean, int tipoLista){
				String query = "call GRUPOSCREDITOLIS(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

							gruposCreditoBean.getNombreGrupo(),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GruposCreditoDAO.listaSolicitudLiberada",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOLIS(" +Arrays.toString(parametros) + ")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GruposCreditoBean grupos = new GruposCreditoBean();
						grupos.setGrupoID(resultSet.getString("GrupoID"));
						grupos.setNombreGrupo(resultSet.getString("NombreGrupo"));
						grupos.setNombreSucursal(resultSet.getString("NombreSucurs"));
						return grupos;

					}
				});
				return matches;
				}

			/* Lista de Grupos para Cambio de Puestos Integrantes */
			public List listaCambioPuestosGrupos(GruposCreditoBean gruposCreditoBean, int tipoLista){
				String query = "call GRUPOSCREDITOLIS(?,?,?,?,?,?,?,?,?);";
				Object[] parametros = {

							gruposCreditoBean.getNombreGrupo(),
							tipoLista,

							parametrosAuditoriaBean.getEmpresaID(),
							parametrosAuditoriaBean.getUsuario(),
							parametrosAuditoriaBean.getFecha(),
							parametrosAuditoriaBean.getDireccionIP(),
							"GruposCreditoDAO.listaCambioPuestosGrupos",
							parametrosAuditoriaBean.getSucursal(),
							parametrosAuditoriaBean.getNumeroTransaccion()
						};
				loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOLIS(" +Arrays.toString(parametros) + ")");
				List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
					public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
						GruposCreditoBean grupos = new GruposCreditoBean();
						grupos.setGrupoID(resultSet.getString("GrupoID"));
						grupos.setNombreGrupo(resultSet.getString("NombreGrupo"));
						grupos.setNombreSucursal(resultSet.getString("NombreSucurs"));
						return grupos;

					}
				});
				return matches;
				}

	//Query con el Store Procedure Para la consulta de Deuda Total
	public GruposCreditoBean consultaDeudaTotal(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
		GruposCreditoBean gruposBean =null;
		try {
			gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call GRUPOSCREDITOCON(" +
							"?,?,?,?,?, ?,?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
					sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
					sentenciaStore.setInt("Par_NumCon",tipoConsulta);
					sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual", fecha);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
				DataAccessException {
					GruposCreditoBean grupos = new GruposCreditoBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						grupos.setMontoTotDeuda(resultadosStore.getString(1));
						grupos.setNombreGrupo(resultadosStore.getString(2));
					}
					return grupos;
				}
			});
			return gruposBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consuta de deuda de credito grupal", e);
			return null;
		}
	}


	//Query con el Store Procedure Para la consulta de Deuda Total
	public GruposCreditoBean consultaFiniquito(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
		GruposCreditoBean gruposBean =null;
		try {
			gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call GRUPOSCREDITOCON(" +
							"?,?,?,?,?, ?,?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
					sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
					sentenciaStore.setInt("Par_NumCon",tipoConsulta);
					sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual", fecha);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
				DataAccessException {
					GruposCreditoBean grupos = new GruposCreditoBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						grupos.setMontoTotDeuda(resultadosStore.getString(1));
					}
					return grupos;
				}
			});
			return gruposBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consuta de deuda de credito grupal", e);
			return null;
		}
	}

	//Query con el Store Procedure Para la consulta de Total Exigible
	public GruposCreditoBean consultaTotalExigible(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
		GruposCreditoBean gruposBean =null;
		try {
			gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call GRUPOSCREDITOCON(" +
							"?,?,?,?,?, ?,?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
					sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
					sentenciaStore.setInt("Par_NumCon",tipoConsulta);
					sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual", fecha);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
				DataAccessException {
					GruposCreditoBean grupos = new GruposCreditoBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						grupos.setMontoTotDeuda(resultadosStore.getString("Mon_TotDeuda"));
						grupos.setTotalCuotaAdelantada(Utileria.convierteDoble((resultadosStore.getString("Mon_TotProyecta")).replace(",", "")));

					    double totalExigibleGrupal = Utileria.convierteDoble((resultadosStore.getString("Mon_TotDeuda")).replace(",",""));
					    if(totalExigibleGrupal > Constantes.DOUBLE_VACIO ){
					    	grupos.setTotalExigibleDia(CalculosyOperaciones.resta(totalExigibleGrupal, grupos.getTotalCuotaAdelantada()));
					    }else{
					    	grupos.setTotalExigibleDia(Constantes.DOUBLE_VACIO);
					    }

					}
					return grupos;
				}
			});
			return gruposBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error e consulta total exigible de credito de grupo", e);
			return null;
		}
	}

	//Query con el Store Procedure Para la consulta de Total Exigible
	public GruposCreditoBean consultaCondonacion(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
		GruposCreditoBean gruposBean =null;
		try {
			gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
			new CallableStatementCreator() {
				public CallableStatement createCallableStatement(Connection arg0) throws SQLException {
					String query = "call GRUPOSCREDITOCON(" +
							"?,?,?,?,?, ?,?,?,?,?);";
					CallableStatement sentenciaStore = arg0.prepareCall(query);
					sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
					sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
					sentenciaStore.setInt("Par_NumCon",tipoConsulta);
					sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
					sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
					sentenciaStore.setDate("Aud_FechaActual", fecha);
					sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
					sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
					sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
					sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
					loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
					return sentenciaStore;
				}
			},new CallableStatementCallback() {
				public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
				DataAccessException {
					GruposCreditoBean grupos = new GruposCreditoBean();
					if(callableStatement.execute()){
						ResultSet resultadosStore = callableStatement.getResultSet();

						resultadosStore.next();
						grupos.setMontoTotDeuda(resultadosStore.getString(1));
					}
					return grupos;
				}
			});
			return gruposBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error e consulta total exigible de credito de grupo", e);
			return null;
		}
	}

	//Consulta que devuelve los creditos que integran un grupo
	public List consultaCreditosIntegranGrupo(GruposCreditoBean gruposCreditoBean, int tipoLista){
		List gruposCreditos = null ;
		try{
			String query = "call GRUPOSCREDITOCON(" +
					"?,?,?,?,?, ?,?,?,?,?);";
			Object[] parametros = {
					Utileria.convierteEntero(gruposCreditoBean.getGrupoID()),
					Utileria.convierteEntero(gruposCreditoBean.getCicloActual()),
					tipoLista,

					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO,
					Constantes.FECHA_VACIA,
					Constantes.STRING_VACIO,
					"gruposDao.consultacred",
					Constantes.ENTERO_CERO,
					Constantes.ENTERO_CERO
			};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GruposCreditoBean grupos = new GruposCreditoBean();
					grupos.setCreditoID(resultSet.getString(1));
					return grupos;
				}
			});
			gruposCreditos =  matches;
		}catch(Exception e){
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de credito que integran al grupo", e);
		}
		return gruposCreditos;
	}


	//Query con el Store Procedure Para la consulta de verificar integrantes
	public GruposCreditoBean consultaVerificaInte(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
		GruposCreditoBean gruposBean =null;
		try {

			gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call GRUPOSCREDITOCON(" +
									"?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
							sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
							GruposCreditoBean grupos = new GruposCreditoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								grupos.setValidaInt(resultadosStore.getString(1));
							}
							return grupos;
						}
					});
		return gruposBean;
	} catch (Exception e) {
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en verificacion de integrantes de credito de grupo", e);
		return null;
	}
}



	//Query con el Store Procedure Para la consulta de verificar integrantes
	public GruposCreditoBean consultaCicloGrupo(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
		GruposCreditoBean gruposBean =null;
		try {

			gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call GRUPOSCREDITOCON(" +
									"?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
							sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
							GruposCreditoBean grupos = new GruposCreditoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								grupos.setGrupoID(resultadosStore.getString(1));
								grupos.setCicloActual(resultadosStore.getString(2));
							}
							return grupos;
						}
					});
		return gruposBean;
	} catch (Exception e) {
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en verificacion de integrantes", e);
		return null;
	}
}


	//Query con el Store Procedure Para la consulta de verificar integrantes
	public GruposCreditoBean consultaIntegrantesGrupo(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
		GruposCreditoBean gruposBean =null;
		try {

			gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(
					new CallableStatementCreator() {
						public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

							String query = "call GRUPOSCREDITOCON(" +
									"?,?,?,?,?, ?,?,?,?,?);";
							CallableStatement sentenciaStore = arg0.prepareCall(query);
							sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
							sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
							sentenciaStore.setInt("Par_NumCon",tipoConsulta);
							sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
							sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
							sentenciaStore.setDate("Aud_FechaActual", fecha);
							sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
							sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
							sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
							sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
							loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
							return sentenciaStore;
						}
					},new CallableStatementCallback() {
						public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																											DataAccessException {
							GruposCreditoBean grupos = new GruposCreditoBean();
							if(callableStatement.execute()){
								ResultSet resultadosStore = callableStatement.getResultSet();

								resultadosStore.next();
								grupos.settInt(resultadosStore.getString(1));
								grupos.settMS(resultadosStore.getString(2));
								grupos.settM(resultadosStore.getString(3));
								grupos.settH(resultadosStore.getString(4));

							}
							return grupos;
						}
					});
		return gruposBean;
	} catch (Exception e) {
		e.printStackTrace();
		loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta de verificacion de integrantes", e);
		return null;
	}
}

	//Consulta rompimiento Grupos Creditos
	public GruposCreditoBean consultaRompimiento(GruposCreditoBean gruposCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call GRUPOSCREDITOCON(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(gruposCredito.getGrupoID()),
								Utileria.convierteEntero(gruposCredito.getCicloActual()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposCreditoDAO.consultaRompimiento",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GruposCreditoBean gruposCredito = new GruposCreditoBean();
				gruposCredito.setGrupoID(resultSet.getString("GrupoID"));
				gruposCredito.setNombreGrupo(resultSet.getString("NombreGrupo"));
				gruposCredito.setSucursalID(resultSet.getString("SucursalID"));
				gruposCredito.setUsuario(resultSet.getString("UsuarioID"));
				return gruposCredito;

			}
		});
		return matches.size() > 0 ? (GruposCreditoBean) matches.get(0) : null;
	}

	//Consulta de Grupos con Solicitud Liberada
	public GruposCreditoBean consultaSolicitudLiberada(GruposCreditoBean gruposCredito, int tipoConsulta) {

		GruposCreditoBean beanGrupos = null;
		try {
		//Query con el Store Procedure
			String query = "call GRUPOSCREDITOCON(?,?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = { Utileria.convierteEntero(gruposCredito.getGrupoID()),
									Utileria.convierteEntero(gruposCredito.getCicloActual()),
									tipoConsulta,
									Constantes.ENTERO_CERO,
									gruposCredito.getUsuario(),
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"GruposCreditoDAO.consultaGrupo",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
									};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOCON(" +Arrays.toString(parametros) + ")");
			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper<Object>() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GruposCreditoBean gruposCredito = new GruposCreditoBean();
					gruposCredito.setGrupoID(resultSet.getString("GrupoID"));
					gruposCredito.setNombreGrupo(resultSet.getString("NombreGrupo"));
					gruposCredito.setCicloActual(resultSet.getString("CicloActual"));
					gruposCredito.setEstatusSol(resultSet.getString("Estatus"));
					gruposCredito.setSucursalID(resultSet.getString("SucursalID"));
					gruposCredito.setSucursalPromotor(resultSet.getString("SucursalPromotor"));
					gruposCredito.setPromAtiendeSuc(resultSet.getString("PromotAtiendeSucursal"));
					return gruposCredito;

				}
			});
			beanGrupos = matches.size() > 0 ? (GruposCreditoBean) matches.get(0) : null;
		}catch (Exception exception) {
			exception.getMessage();
			exception.printStackTrace();
			loggerSAFI.error(this.getClass()+" - "+parametrosAuditoriaBean.getOrigenDatos()+" - "+"error en consulta del grupo de credito ", exception);
			beanGrupos = null;
		}
		return beanGrupos;
	}

	//Consulta de pagares de grupos
	public GruposCreditoBean consultaPagareGrupo(GruposCreditoBean gruposCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call GRUPOSCREDITOCON(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(gruposCredito.getGrupoID()),
								Utileria.convierteEntero(gruposCredito.getCicloActual()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								gruposCredito.getUsuario(),
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposCreditoDAO.consultaPagareGrupo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOCON(" +Arrays.toString(parametros) + ")");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GruposCreditoBean gruposCredito = new GruposCreditoBean();
				gruposCredito.setGrupoID(resultSet.getString("GrupoID"));
				gruposCredito.setPagareImpreso(resultSet.getString("PagareImpreso"));
				return gruposCredito;

			}
		});
		return matches.size() > 0 ? (GruposCreditoBean) matches.get(0) : null;
	}

	// Consulta la existencia del Grupo, y el total de sus integrantes usado para
	// alta de solicitudes de credito via WS SANA TUS FINANZAS
	public GruposCreditoBean consultaExistenciaGrupo(GruposCreditoBean gruposCredito, int tipoConsulta) {
		//Query con el Store Procedure
		String query = "call GRUPOSCREDITOCON(?,?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = { Utileria.convierteEntero(gruposCredito.getGrupoID()),
								Utileria.convierteEntero(gruposCredito.getCicloActual()),
								tipoConsulta,
								Constantes.ENTERO_CERO,
								gruposCredito.getUsuario(),
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"GruposCreditoDAO.consultaExistenciaGrupo",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO
								};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GRUPOSCREDITOCON(" +Arrays.toString(parametros) + ");");
		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GruposCreditoBean gruposCredito = new GruposCreditoBean();
				gruposCredito.setGrupoID(resultSet.getString("GrupoID"));
				gruposCredito.settInt(resultSet.getString("TotalIntegrantes"));
				return gruposCredito;

			}
		});
		return matches.size() > 0 ? (GruposCreditoBean) matches.get(0) : null;
	}

	//Query con el Store Procedure Para la consulta principal para construir el nombre

		public GruposCreditoBean consultaPrincipalAgro(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
			GruposCreditoBean gruposBean =null;
			try {

				gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call GRUPOSCREDITOCON(" +
										"?,?,?,?,?, ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
								sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);

								sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual", fecha);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
								GruposCreditoBean grupos = new GruposCreditoBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									grupos.setGrupoID(resultadosStore.getString(1));
									grupos.setNombreGrupo(resultadosStore.getString(2));
									grupos.setFechaRegistro(resultadosStore.getString(3));
									grupos.setSucursalID(resultadosStore.getString(4));
									grupos.setCicloActual(resultadosStore.getString(5));
									grupos.setEstatusCiclo(resultadosStore.getString(6));
									grupos.setFechaUltCiclo(resultadosStore.getString(7));
									grupos.setProductoCre(resultadosStore.getString(8));
									grupos.setNombreSucursal(resultadosStore.getString(9));
									grupos.setTipoOperacion(resultadosStore.getString(10));
								}
								return grupos;
							}
						});
			return gruposBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal para construccion de nombre", e);
			return null;
		}
	}

	//Query con el Store Procedure Para la consulta principal para construir el nombre

	public GruposCreditoBean consultaDesembolsosGrupo(final GruposCreditoBean gruposCreditoBean, final int tipoConsulta){
			GruposCreditoBean gruposBean =null;
			try {

				gruposBean = (GruposCreditoBean) ((JdbcTemplate) conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).execute(

						new CallableStatementCreator() {
							public CallableStatement createCallableStatement(Connection arg0) throws SQLException {

								String query = "call GRUPOSCREDITOCON(" +
										"?,?,?,?,?, ?,?,?,?,?);";
								CallableStatement sentenciaStore = arg0.prepareCall(query);
								sentenciaStore.setInt("Par_GrupoID",Utileria.convierteEntero(gruposCreditoBean.getGrupoID()));
								sentenciaStore.setInt("Par_CicloGrupo",Utileria.convierteEntero(gruposCreditoBean.getCicloActual()));
								sentenciaStore.setInt("Par_NumCon",tipoConsulta);

								sentenciaStore.setInt("Aud_EmpresaID",Constantes.ENTERO_CERO);
								sentenciaStore.setInt("Aud_Usuario", Constantes.ENTERO_CERO);
								sentenciaStore.setDate("Aud_FechaActual", fecha);
								sentenciaStore.setString("Aud_DireccionIP",Constantes.STRING_VACIO);
								sentenciaStore.setString("Aud_ProgramaID","ConsultaGrupos");
								sentenciaStore.setInt("Aud_Sucursal",Constantes.ENTERO_CERO);
								sentenciaStore.setLong("Aud_NumTransaccion",Constantes.ENTERO_CERO);
								loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+sentenciaStore.toString());
								return sentenciaStore;
							}
						},new CallableStatementCallback() {
							public Object doInCallableStatement(CallableStatement callableStatement) throws SQLException,
																												DataAccessException {
								GruposCreditoBean grupos = new GruposCreditoBean();
								if(callableStatement.execute()){
									ResultSet resultadosStore = callableStatement.getResultSet();

									resultadosStore.next();
									grupos.setGrupoID((resultadosStore.getString("GrupoID")));
									grupos.setNombreGrupo(resultadosStore.getString("NombreGrupo"));
									grupos.setNumCreditos(resultadosStore.getString("NumCreditos"));
								}
								return grupos;
							}
						});
			return gruposBean;
		} catch (Exception e) {
			e.printStackTrace();
			loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"error en consulta principal para construccion de nombre", e);
			return null;
		}
	}

}
