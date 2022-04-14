package cobranza.dao;

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
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.core.RowMapper;
import org.springframework.transaction.TransactionStatus;
import org.springframework.transaction.support.TransactionCallback;
import org.springframework.transaction.support.TransactionTemplate;

import cobranza.bean.GestoresCobranzaBean;

public class GestoresCobranzaDAO extends BaseDAO{
	private final static String salidaPantalla = "S";

	public GestoresCobranzaDAO(){
		super();
	}

	/* Alta del Gestores de Cobranza */
	public MensajeTransaccionBean altaGestoresCobranza(final GestoresCobranzaBean gestoresCobranza) {
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
								gestoresCobranza.setTelefonoCelular(gestoresCobranza.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								gestoresCobranza.setTelefonoParticular(gestoresCobranza.getTelefonoParticular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

									String query = "call GESTORESCOBRANZAALT(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?," +
										"?,?,?, ?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setString("Par_TipoGestor", gestoresCobranza.getTipoGestor());
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(gestoresCobranza.getUsuarioID()));
									sentenciaStore.setString("Par_Nombre", gestoresCobranza.getNombre());
									sentenciaStore.setString("Par_ApePaterno", gestoresCobranza.getApellidoPaterno());
									sentenciaStore.setString("Par_ApeMaterno", gestoresCobranza.getApellidoMaterno());

									sentenciaStore.setString("Par_TelParticular", gestoresCobranza.getTelefonoParticular());
									sentenciaStore.setString("Par_TelCelular", gestoresCobranza.getTelefonoCelular());
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(gestoresCobranza.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(gestoresCobranza.getMunicipioID()));
									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(gestoresCobranza.getLocalidadID()));

									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(gestoresCobranza.getColoniaID()));
									sentenciaStore.setString("Par_Calle", gestoresCobranza.getCalle());
									sentenciaStore.setString("Par_NumeroCasa", gestoresCobranza.getNumeroCasa());
									sentenciaStore.setString("Par_NumInterior", gestoresCobranza.getNumInterior());
									sentenciaStore.setString("Par_Piso", gestoresCobranza.getPiso());

									sentenciaStore.setString("Par_PrimEntreCalle", gestoresCobranza.getPrimeraEntreCalle());
									sentenciaStore.setString("Par_SegEntreCalle", gestoresCobranza.getSegundaEntreCalle());
									sentenciaStore.setString("Par_CP", gestoresCobranza.getCP());
									sentenciaStore.setDouble("Par_PorcenComision", Utileria.convierteDoble(gestoresCobranza.getPorcentajeComision()));
									sentenciaStore.setInt("Par_TipoAsigCobraID", Utileria.convierteEntero(gestoresCobranza.getTipoAsigCobranzaID()));

									sentenciaStore.setInt("Par_UsuarioRegID", Utileria.convierteEntero(gestoresCobranza.getUsuarioLogeadoID()));
									sentenciaStore.setDate("Par_FechaRegistro",OperacionesFechas.conversionStrDate(gestoresCobranza.getFechaSis()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GestoresCobranzaDAO.altaGestoresCobranza");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .GestoresCobranzaDAO.altaGestoresCobranza");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Gestores Cobranza: " + mensajeBean.getDescripcion());
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Gestores Cobranza" + e);
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

	/* Modificacion del Gestores de Cobranza */
	public MensajeTransaccionBean modificacionGestoresCobranza(final GestoresCobranzaBean gestoresCobranza) {
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
								gestoresCobranza.setTelefonoCelular(gestoresCobranza.getTelefonoCelular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));
								gestoresCobranza.setTelefonoParticular(gestoresCobranza.getTelefonoParticular().trim().replaceAll("\\(","").replaceAll("\\)","").replaceAll(" ","").replaceAll("\\-",""));

									String query = "call GESTORESCOBRANZAMOD(" +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?,?,?,?,?, ?,?,?,?,?," +
										"?," +
										"?,?,?, ?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_GestorID", Utileria.convierteEntero(gestoresCobranza.getGestorID()));
									sentenciaStore.setString("Par_TipoGestor", gestoresCobranza.getTipoGestor());
									sentenciaStore.setInt("Par_UsuarioID", Utileria.convierteEntero(gestoresCobranza.getUsuarioID()));
									sentenciaStore.setString("Par_Nombre", gestoresCobranza.getNombre());
									sentenciaStore.setString("Par_ApePaterno", gestoresCobranza.getApellidoPaterno());

									sentenciaStore.setString("Par_ApeMaterno", gestoresCobranza.getApellidoMaterno());
									sentenciaStore.setString("Par_TelParticular", gestoresCobranza.getTelefonoParticular());
									sentenciaStore.setString("Par_TelCelular", gestoresCobranza.getTelefonoCelular());
									sentenciaStore.setInt("Par_EstadoID", Utileria.convierteEntero(gestoresCobranza.getEstadoID()));
									sentenciaStore.setInt("Par_MunicipioID", Utileria.convierteEntero(gestoresCobranza.getMunicipioID()));

									sentenciaStore.setInt("Par_LocalidadID", Utileria.convierteEntero(gestoresCobranza.getLocalidadID()));
									sentenciaStore.setInt("Par_ColoniaID", Utileria.convierteEntero(gestoresCobranza.getColoniaID()));
									sentenciaStore.setString("Par_Calle", gestoresCobranza.getCalle());
									sentenciaStore.setString("Par_NumeroCasa", gestoresCobranza.getNumeroCasa());
									sentenciaStore.setString("Par_NumInterior", gestoresCobranza.getNumInterior());

									sentenciaStore.setString("Par_Piso", gestoresCobranza.getPiso());
									sentenciaStore.setString("Par_PrimEntreCalle", gestoresCobranza.getPrimeraEntreCalle());
									sentenciaStore.setString("Par_SegEntreCalle", gestoresCobranza.getSegundaEntreCalle());
									sentenciaStore.setString("Par_CP", gestoresCobranza.getCP());
									sentenciaStore.setDouble("Par_PorcenComision", Utileria.convierteDoble(gestoresCobranza.getPorcentajeComision()));

									sentenciaStore.setInt("Par_TipoAsigCobraID", Utileria.convierteEntero(gestoresCobranza.getTipoAsigCobranzaID()));

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GestoresCobranzaDAO.altaGestoresCobranza");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .GestoresCobranzaDAO.altaGestoresCobranza");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Gestores Cobranza: " + mensajeBean.getDescripcion());
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Gestores Cobranza" + e);
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

	public MensajeTransaccionBean actualizaGestoresCobranza(final GestoresCobranzaBean gestoresCobranza,final int tipoAct) {
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

									String query = "call GESTORESCOBRANZAACT(" +
										"?,?,?,?," +
										"?,?,?, ?,?,?,?,?,?,?);";//parametros de auditoria
									CallableStatement sentenciaStore = arg0.prepareCall(query);

									sentenciaStore.setInt("Par_GestorID", Utileria.convierteEntero(gestoresCobranza.getGestorID()));
									sentenciaStore.setDate("Par_FechaSis",OperacionesFechas.conversionStrDate(gestoresCobranza.getFechaSis()));
									sentenciaStore.setInt("Par_UsuLogeadoID", Utileria.convierteEntero(gestoresCobranza.getUsuarioLogeadoID()));
									sentenciaStore.setInt("Par_NumAct", tipoAct);

									sentenciaStore.setString("Par_Salida",salidaPantalla);
									sentenciaStore.registerOutParameter("Par_NumErr", Types.INTEGER);
									sentenciaStore.registerOutParameter("Par_ErrMen", Types.VARCHAR);

									//Parametros de Auditoria
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
										mensajeTransaccion.setNumero(Integer.valueOf(resultadosStore.getString("NumErr")).intValue());
										mensajeTransaccion.setDescripcion(resultadosStore.getString("ErrMen"));
										mensajeTransaccion.setNombreControl(resultadosStore.getString("Control"));
										mensajeTransaccion.setConsecutivoString(resultadosStore.getString("Consecutivo"));

									}else{
										mensajeTransaccion.setNumero(999);
										mensajeTransaccion.setDescripcion(Constantes.MSG_ERROR + " .GestoresCobranzaDAO.altaGestoresCobranza");
										mensajeTransaccion.setNombreControl(Constantes.STRING_VACIO);
										mensajeTransaccion.setConsecutivoString(Constantes.STRING_VACIO);
										mensajeTransaccion.setCampoGenerico(Constantes.STRING_CERO);
									}

									return mensajeTransaccion;
								}
							}
							);

						if(mensajeBean ==  null){
							mensajeBean = new MensajeTransaccionBean();
							mensajeBean.setNumero(999);
							throw new Exception(Constantes.MSG_ERROR + " .GestoresCobranzaDAO.altaGestoresCobranza");
						}else if(mensajeBean.getNumero()!=0){
							if(mensajeBean.getNumero()==50){ // Error que corresponde cuando se detecta en lista de pers bloqueadas
								loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Gestores Cobranza: " + mensajeBean.getDescripcion());
							} else {
								throw new Exception(mensajeBean.getDescripcion());
							}
						}
					} catch (Exception e) {
						loggerSAFI.error(parametrosAuditoriaBean.getOrigenDatos()+"-"+"Error en Alta de Gestores Cobranza" + e);
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

	/* Lista de gestores de cobranza*/
	public List listaGestores(int tipoLista, GestoresCobranzaBean gestoresBean){

		String query = "call GESTORESCOBRANZALIS(?,?, ?,?,?,?,?,?,?);";
		Object[] parametros = {
				gestoresBean.getNombre(),
				tipoLista,

				parametrosAuditoriaBean.getEmpresaID(),
				parametrosAuditoriaBean.getUsuario(),
				parametrosAuditoriaBean.getFecha(),
				parametrosAuditoriaBean.getDireccionIP(),
				parametrosAuditoriaBean.getNombrePrograma(),
				parametrosAuditoriaBean.getSucursal(),
				parametrosAuditoriaBean.getNumeroTransaccion()
		};

		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GESTORESCOBRANZALIS(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GestoresCobranzaBean gestor = new GestoresCobranzaBean();
				gestor.setGestorID(resultSet.getString("GestorID"));
				gestor.setNombreCompleto(resultSet.getString("NombreCompleto"));
				gestor.setEstatus(resultSet.getString("Estatus"));
				gestor.setTipoGestor(resultSet.getString("TipoGestor"));


				return gestor;
			}
		});

		return matches;
	}

	// listaTipos de Asignacion combobox
	public List listaTiposAsignacion(int tipoLista){
		String query = "call TIPOASIGCOBRANZACON(?, ?,?,?,?,?,?,?);";

		Object[] parametros = {	tipoLista,
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO,
								Constantes.FECHA_VACIA,
								Constantes.STRING_VACIO,
								"TiposDireccionDAO.listaTiposAsignacion",
								Constantes.ENTERO_CERO,
								Constantes.ENTERO_CERO};
		loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call TIPOASIGCOBRANZACON(" + Arrays.toString(parametros) + ")");

		List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
			public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
				GestoresCobranzaBean gestor = new GestoresCobranzaBean();

				gestor.setTipoAsigCobranzaID(String.valueOf(resultSet.getInt(1)));
				gestor.setDescripcion(resultSet.getString(2));

				return gestor;
			}
		});
		return matches;

	}

		public GestoresCobranzaBean consultaPrincipal(int tipoConsulta, GestoresCobranzaBean gestoresBean) {
			//Query con el Store Procedure
			String query = "call GESTORESCOBRANZACON(?,?, ?,?,?,?,?,?,?);";
			Object[] parametros = {	gestoresBean.getGestorID(),
									tipoConsulta,

									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO,
									Constantes.FECHA_VACIA,
									Constantes.STRING_VACIO,
									"GestoresCobranzaDAO.consulta",
									Constantes.ENTERO_CERO,
									Constantes.ENTERO_CERO
								};
			loggerSAFI.info(parametrosAuditoriaBean.getOrigenDatos()+"-"+"call GESTORESCOBRANZACON(" + Arrays.toString(parametros) +")");

			List matches= ((JdbcTemplate)conexionOrigenDatosBean.getOrigenDatosMapa().get(parametrosAuditoriaBean.getOrigenDatos())).query(query,parametros  ,new RowMapper() {
				public Object mapRow(ResultSet resultSet, int rowNum) throws SQLException {
					GestoresCobranzaBean gestor = new GestoresCobranzaBean();

								gestor.setGestorID(String.valueOf(resultSet.getInt("GestorID")));
								gestor.setTipoGestor(resultSet.getString("TipoGestor"));
								gestor.setUsuarioID(resultSet.getString("UsuarioID"));
								gestor.setNombre(resultSet.getString("Nombre"));
								gestor.setApellidoPaterno(resultSet.getString("ApellidoPaterno"));

								gestor.setApellidoMaterno(resultSet.getString("ApellidoMaterno"));
								gestor.setTelefonoParticular(resultSet.getString("TelefonoParticular"));
								gestor.setTelefonoCelular(resultSet.getString("TelefonoCelular"));
								gestor.setEstadoID(resultSet.getString("EstadoID"));
								gestor.setMunicipioID(resultSet.getString("MunicipioID"));

								gestor.setLocalidadID(resultSet.getString("LocalidadID"));
								gestor.setColoniaID(resultSet.getString("ColoniaID"));
								gestor.setCalle(resultSet.getString("Calle"));
								gestor.setNumeroCasa(resultSet.getString("NumeroCasa"));
								gestor.setNumInterior(resultSet.getString("NumInterior"));

								gestor.setPiso(resultSet.getString("Piso"));
								gestor.setPrimeraEntreCalle(resultSet.getString("PrimeraEntreCalle"));
								gestor.setSegundaEntreCalle(resultSet.getString("SegundaEntreCalle"));
								gestor.setCP(resultSet.getString("CP"));
								gestor.setPorcentajeComision(resultSet.getString("PorcentajeComision"));

								gestor.setTipoAsigCobranzaID(resultSet.getString("TipoAsigCobranzaID"));
								gestor.setEstatus(resultSet.getString("Estatus"));
								gestor.setFechaRegistro(resultSet.getString("FechaRegistro"));
								gestor.setFechaActivacion(resultSet.getString("FechaActivacion"));
								gestor.setFechaBaja(resultSet.getString("FechaBaja"));

								gestor.setUsuarioRegistroID(resultSet.getString("UsuarioRegistroID"));
								gestor.setUsuarioActivaID(resultSet.getString("UsuarioActivaID"));
								gestor.setUsuarioBajaID(resultSet.getString("UsuarioBajaID"));

								gestor.setNombreCompleto(resultSet.getString("NombreCompleto"));

								return gestor;
				}
			});

			return matches.size() > 0 ? (GestoresCobranzaBean) matches.get(0) : null;
		}

}
